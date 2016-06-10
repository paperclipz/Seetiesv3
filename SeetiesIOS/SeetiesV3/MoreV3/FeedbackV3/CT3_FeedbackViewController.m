//
//  CT3_FeedbackViewController.m
//  Seeties
//
//  Created by Lup Meng Poo on 31/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_FeedbackViewController.h"
#import "IDMPhotoBrowser.h"

@interface CT3_FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibFeedbackLbl;
@property (weak, nonatomic) IBOutlet UITextView *ibFeedbackTxt;
@property (weak, nonatomic) IBOutlet UILabel *ibEmailLbl;
@property (weak, nonatomic) IBOutlet UITextField *ibEmailTxt;
@property (weak, nonatomic) IBOutlet UIView *ibSSView;
@property (weak, nonatomic) IBOutlet UIView *ibNoSSView;
@property (weak, nonatomic) IBOutlet UIImageView *ibSSIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibSSLbl;
@property (weak, nonatomic) IBOutlet UIView *ibWithSSView;
@property (weak, nonatomic) IBOutlet UIImageView *ibSSImg;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibContentViewHeighConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibScreenshotViewHeightConstraint;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property(nonatomic) BOOL isSending;
@property(nonatomic) BOOL hasSent;
@end

@implementation CT3_FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.ibSSIcon.image = [self.ibSSIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [Utils setRoundBorder:self.ibFeedbackTxt color:LINE_COLOR borderRadius:5.0f borderWidth:1.0f];
    
    self.isSending = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)changeLanguage{
    self.ibHeaderTitle.text = LocalisedString(@"Speak to Us");
    self.ibFeedbackLbl.text = LocalisedString(@"Feedback");
    self.ibFeedbackTxt.placeholder = LocalisedString(@"Kindly fill in all required fields");
    self.ibEmailLbl.text = LocalisedString(@"Email");
    self.ibEmailTxt.placeholder = LocalisedString(@"Kindly key in your valid email");
    self.ibSSLbl.text = LocalisedString(@"Include Screenshot");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

#pragma mark - IBAction
- (IBAction)btnDoneClicked:(id)sender {
    if ([Utils isStringNull:self.ibEmailTxt.text] || [Utils isStringNull:self.ibFeedbackTxt.text]) {
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Kindly fill in all required fields") cancelButtonTitle:LocalisedString(@"Okay!") otherButtonTitles:nil tapBlock:nil];
        return;
    }
    
    if ([self validateEmail:self.ibEmailTxt.text]) {
        [self requestServerToSendFeedback];
    }
    else{
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Invalid email address") cancelButtonTitle:LocalisedString(@"Okay!") otherButtonTitles:nil tapBlock:nil];
    }
}

- (IBAction)btnIncludeSSClicked:(id)sender {
    self.imagePickerController = nil;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)btnRemoveSSClicked:(id)sender {
    [self.ibSSImg setImage:nil];
    self.ibScreenshotViewHeightConstraint.constant = 50;
    self.ibContentViewHeighConstraint.constant = self.ibSSView.frame.origin.y + self.ibScreenshotViewHeightConstraint.constant;
    
    self.ibNoSSView.hidden = NO;
    self.ibWithSSView.hidden = YES;
}

#pragma mark - DelegateImplementation
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *screenshot = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (screenshot) {
        self.ibScreenshotViewHeightConstraint.constant = 120 + 32;
        self.ibContentViewHeighConstraint.constant = self.ibSSView.frame.origin.y + self.ibScreenshotViewHeightConstraint.constant;
        [self.ibSSImg setImage:screenshot];
        [Utils setRoundBorder:self.ibSSImg color:OUTLINE_COLOR borderRadius:5.0f];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
        [self.ibSSImg addGestureRecognizer:tapGesture];
        
        self.ibNoSSView.hidden = YES;
        self.ibWithSSView.hidden = NO;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imageTapped{
    if (self.ibSSImg.image) {
        IDMPhoto *photo = [IDMPhoto photoWithImage:self.ibSSImg.image];
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo] animatedFromView:self.ibSSImg];
        [self presentViewController:browser animated:YES completion:nil];
    }
}

#pragma mark - Declaration
-(UIImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return _imagePickerController;
}

-(BOOL)toResetPage{
    return self.hasSent;
}

#pragma mark - RequestServer
-(void)requestServerToSendFeedback{
    if (self.isSending) {
        return;
    }
    
    NSString *spec = [NSString stringWithFormat:@"%@, %@, %@", [[UIDevice currentDevice] name],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    
    NSDictionary *dict = @{@"email": self.ibEmailTxt.text? self.ibEmailTxt.text : @"",
                           @"type": @"feedback",
                           @"message": self.ibFeedbackTxt.text? self.ibFeedbackTxt.text : @"",
                           @"spec": spec};
    
    NSMutableArray *metaArray = [[NSMutableArray alloc] init];
    if (self.ibSSImg.image) {
        PhotoModel *photo = [[PhotoModel alloc] init];
        photo.image = self.ibSSImg.image;
        photo.photo_id = @"screenshot";
        [metaArray addObject:photo];
    }
    
    [LoadingManager show];
    self.isSending = YES;
    
    [[ConnectionManager Instance] requestServerWithPost:ServerRequestTypePostLogFeedback param:dict appendString:nil meta:metaArray completeHandler:^(id object) {
        self.isSending = NO;
        [LoadingManager hide];
        self.hasSent = YES;
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Thank you for your feedback!") cancelButtonTitle:LocalisedString(@"Okay!") otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } errorBlock:^(id object) {
        self.isSending = NO;
        [LoadingManager hide];
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Error in submitting") cancelButtonTitle:LocalisedString(@"Okay!") otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        }];
    }];
}

@end
