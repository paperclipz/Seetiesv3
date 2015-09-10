//
//  EditPostViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditPostViewController.h"
#import "UIImageViewModeScaleAspect.h"
#import "UIImageView+WebCache.h"
#import "UIImage+FX.h"
#import "EditPhotoViewController.h"
#import "AddNewPlaceViewController.h"
#import "HMSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

#import "EditPostDetailVIew.h"
#import "CategorySelectionViewController.h"

@interface EditPostViewController ()
{
    NSString* postURL;
    BOOL isDualLanguge;

}

// =============== model ===============//
@property(nonatomic,strong)RecommendationModel* recommendationModel;

// =============== model ===============//

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descViewTopLayoutConstraint;

@property(nonatomic,strong)EditPhotoViewController* editPhotoViewController;
@property(nonatomic,strong)AddNewPlaceViewController* addNewPlaceViewController;
@property(nonatomic,strong)UINavigationController* navAddNewPlaceViewController;
@property(nonatomic,strong)CategorySelectionViewController* categorySelectionViewController;
@property(nonatomic,strong)HMSegmentedControl* segmentedControl;
@property(nonatomic,strong)IBOutlet UISegmentedControl* postSegmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UIView *ibDescContentView;
@property(nonatomic,strong)EditPostDetailVIew* editPostView;
@property(nonatomic,strong)EditPostDetailVIew* editPostViewSecond;

@property(nonatomic,strong)UIAlertView* urlAlertView;
@end

@implementation EditPostViewController
- (IBAction)btnPublishClicked:(id)sender {
    
    [self presentViewController:self.categorySelectionViewController animated:YES completion:nil];

    
}
- (IBAction)segmentedControlClicked:(id)sender {
    
    UISegmentedControl* temp = (UISegmentedControl*)sender;
    BOOL isFirstView = temp.selectedSegmentIndex==1;
 
    [UIView transitionWithView:self.ibDescContentView
                      duration:1.0
                       options:isFirstView?UIViewAnimationOptionTransitionFlipFromLeft :UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{

                        self.editPostViewSecond.hidden = !isFirstView;
                        self.editPostView.hidden = isFirstView;

                    } completion:^(BOOL finished) {
                        self.editPostView.hidden = isFirstView;
                        self.editPostViewSecond.hidden = !isFirstView;

                    }
     ];
    
 }

- (IBAction)btnBackClicked:(id)sender {
    
    [UIAlertView showWithTitle:@"New Recommendation"
                       message:@"You are exiting the editor. Save Changes?"
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@[@"Discard", @"Save"]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex]) {
                              NSLog(@"Cancelled");

                          } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Discard"]) {
                              NSLog(@"Discard");
                              [self dismissViewControllerAnimated:YES completion:nil];

                          } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save"]) {
                              NSLog(@"Save");
                              [self.navigationController popViewControllerAnimated:YES];
                          }
                      }];
}

-(void)initData:(RecommendationModel*)model
{
    self.recommendationModel = model;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
}

-(void)reloadData
{
    EditPhotoModel* edifotoModel = self.recommendationModel.arrPostImagesList[0];
    
    
    if (edifotoModel) {
        self.ibImageView.image = [edifotoModel.image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadData];

    //    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //    [manager downloadImageWithURL:[NSURL URLWithString:@"http://cdn3.denofgeek.us/sites/denofgeekus/files/scarlett_johansson.jpg"]
    //                          options:0
    //                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //                             // progression tracking code
    //                         }
    //                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    //                            if (image) {
    //
    //                                self.ibImageView.image = [image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
    //                            }
    //                        }];


}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    switch ((long)segmentedControl.selectedSegmentIndex) {
       
        default:
        case 0:
        {
            //[self.customPickerViewController show];
            
            [self.urlAlertView show];

        }
            break;
        case 1:
        {
            [self presentViewController:self.navAddNewPlaceViewController animated:YES completion:^{
                [self.addNewPlaceViewController initData:self.recommendationModel.reccomendVenueModel];
            }];

        }

            break;
            
        case 2:
        {
            _editPhotoViewController = nil;
            
            [self.editPhotoViewController initData:self.recommendationModel];

            [self presentViewController:self.editPhotoViewController animated:YES completion:nil];
                 __weak typeof (self)weakSelf = self;
                self.editPhotoViewController.doneBlock = ^(NSArray* array)
                {
                
                weakSelf.recommendationModel.arrPostImagesList = nil;
                weakSelf.recommendationModel.arrPostImagesList = [[NSMutableArray alloc]initWithArray:array];
                };

        }
            break;
        case 3:
            
            [self saveData];
            break;
    }
    
    segmentedControl.selectedSegmentIndex = -1;
}

-(void)initSelfView
{
    
    [self setHasDualLanguage:YES];
    self.segmentedControl.selectedSegmentIndex = -1;

    self.editPostView.frame = CGRectMake(0, 0, self.ibDescContentView.frame.size.width, self.ibDescContentView.frame.size.width);
    self.editPostViewSecond.frame = CGRectMake(0, 0, self.ibDescContentView.frame.size.width, self.ibDescContentView.frame.size.width);

    [self.view addSubview:self.segmentedControl];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Alert View
-(UIAlertView*)urlAlertView
{
    if (!_urlAlertView) {
        _urlAlertView = [[UIAlertView alloc] initWithTitle:@"Add URL"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Done", nil];
        
        _urlAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [_urlAlertView textFieldAtIndex:0];
        textField.placeholder = @"www.seeties.me";
        
        
        __weak typeof (self)weakSelf = self;
        _urlAlertView.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == alertView.firstOtherButtonIndex) {
                
                weakSelf.recommendationModel.postURL = [[alertView textFieldAtIndex:0] text];

            } else if (buttonIndex == alertView.cancelButtonIndex) {
                NSLog(@"Cancelled.");
            }
        };

    }
    
    _urlAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [_urlAlertView textFieldAtIndex:0];
    if (self.recommendationModel.postURL) {
        textField.text = self.recommendationModel.postURL;
    }
    
    return _urlAlertView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Declarations
-(CategorySelectionViewController*)categorySelectionViewController
{
    if(!_categorySelectionViewController)
    {
        
        __weak typeof(self)weakSelf = self;
        _categorySelectionViewController = [CategorySelectionViewController new];
        _categorySelectionViewController.doneClickBlock = ^(id object)
        {
            [weakSelf requestServerForPublishPost];
        };
        
    }
    return _categorySelectionViewController;
}

-(NSArray*)arrTabImages
{
    
    return @[[UIImage imageNamed:@"addurl_icon@2x.png"],[UIImage imageNamed:@"editplace_icon@2x.png"],[UIImage imageNamed:@"qr_icon@2x.png"],[UIImage imageNamed:@"save_icon@2x.png"]];
}

-(EditPhotoViewController*)editPhotoViewController
{
    if(!_editPhotoViewController)
    {
        _editPhotoViewController = [EditPhotoViewController new];
    }
    
    return _editPhotoViewController;
}

-(HMSegmentedControl*)segmentedControl
{
    if(!_segmentedControl)
    {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:self.arrTabImages sectionSelectedImages:self.arrTabImages];
        _segmentedControl.frame = CGRectMake(0, [Utils getDeviceScreenSize].size.height-60, [Utils getDeviceScreenSize].size.width,  60);
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
     //   _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;

    }
    
    return _segmentedControl;
}
-(AddNewPlaceViewController*)addNewPlaceViewController
{
    
    if(!_addNewPlaceViewController)
    {
        _addNewPlaceViewController = [AddNewPlaceViewController new];
        __weak typeof (self)weakSelf = self;
        _addNewPlaceViewController.btnBackBlock = ^(id object)
        {
            [weakSelf.addNewPlaceViewController dismissViewControllerAnimated:YES completion:nil];
        };
        
        
        _addNewPlaceViewController.btnPressDoneBlock = ^(id object)
        {
            RecommendationVenueModel* temp = (RecommendationVenueModel*)object;
            
            weakSelf.recommendationModel.reccomendVenueModel = temp;
            [weakSelf.addNewPlaceViewController dismissViewControllerAnimated:YES completion:nil];

        };
      
    }
    return _addNewPlaceViewController;
}


-(UINavigationController*)navAddNewPlaceViewController
{
    
    if(!_navAddNewPlaceViewController)
    {
        _navAddNewPlaceViewController = [[UINavigationController alloc]initWithRootViewController:self.addNewPlaceViewController];
        _navAddNewPlaceViewController.navigationBarHidden = YES;
        
    }
    
    return _navAddNewPlaceViewController;
}

-(EditPostDetailVIew*)editPostView
{
    
    if(!_editPostView)
    {
        _editPostView = [EditPostDetailVIew initializeCustomView];
        [self.ibDescContentView addSubview:_editPostView];

    }
    return _editPostView;
}

-(EditPostDetailVIew*)editPostViewSecond
{
    
    if(!_editPostViewSecond)
    {
        _editPostViewSecond = [EditPostDetailVIew initializeCustomView];
        [self.ibDescContentView addSubview:_editPostViewSecond];
        _editPostViewSecond.hidden = YES;

    }
    return _editPostViewSecond;
}

-(void)setHasDualLanguage:(BOOL)hasDualLang
{
    isDualLanguge = hasDualLang;

    self.descViewTopLayoutConstraint.constant = hasDualLang?33:0;

}

-(RecommendationModel*)recommendationModel
{
    if(!_recommendationModel)
    {
        _recommendationModel  = [RecommendationModel new];
        _recommendationModel.postMainDescription = @"main title Desc";
        _recommendationModel.postMainTitle = @"main title";
        _recommendationModel.postSecondDescription = @"second title Desc";
        _recommendationModel.postSecondTitle = @"second title";

    }
    return _recommendationModel;
}

#pragma mark - Server Request

-(void)requestServerForPublishPost
{
    NSMutableArray* arrImages = [NSMutableArray new];
    NSMutableArray* arrMeta = [NSMutableArray new];
    NSDictionary* photo_meta = @{@"photo_id":@"",@"position":@"",@"caption":@""};

    for (int i =0; i<self.recommendationModel.arrPostImagesList.count; i++) {
        
        EditPhotoModel* model = self.recommendationModel.arrPostImagesList[i];
        [arrImages addObject: model.image];
        [arrMeta addObject:photo_meta];
    }
    
    NSDictionary* addressDict = @{@"route":@"setapak",@"locality":@"KL",@"administrative_area_level_1":@"Federal Territory of Kuala Lumpur",@"postalCode":@"123456",@"country":@"malaysia",@"political":@"abc"};

    NSDictionary* sourceDict = @{@"open_now":@"true",@"periods":@"",@"weekday_text":@""};
    
    NSDictionary* openingHourDict = @{@"open_now":@"false",@"periods":@""};

    NSDictionary* locationDict  = @{@"address_components":addressDict,@"name":@"setapak",@"formatted_address":@"",@"type":@2,@"reference":@"",@"expense":@"",@"rating":@11,@"contact_no":@"",@"source":sourceDict,@"opening_hours":openingHourDict,@"link":@"",@"lat":@"3.1333",@"lng":@"101.7000"};
    
    
    NSDictionary* dict = @{@"post_id":@"",@"token":[Utils getAppToken],@"status":@"0",[NSString stringWithFormat:@"title[%@]",ENGLISH_CODE]:@"title1",[NSString stringWithFormat:@"message[%@]",ENGLISH_CODE]:@"msg1",@"category":@[@1,@2],@"device_type":@2,@"location":[locationDict getJsonString],@"link":@"www.google.com"};
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostCreatePost param:dict images:arrImages  completeHandler:^(id object) {
        
        SLog(@"recommendation response : %@",object);
    
    } errorBlock:nil];
    
}

#pragma mark - Sava Data

-(void)saveData
{
    self.recommendationModel.postMainTitle = self.editPostView.txtTitle.text;
    self.recommendationModel.postMainDescription = self.editPostView.txtDescription.text;
    self.recommendationModel.postSecondTitle = self.editPostViewSecond.txtTitle.text;
    self.recommendationModel.postSecondDescription = self.editPostViewSecond.txtDescription.text;

    [TSMessage showNotificationInViewController:self title:@"system" subtitle:@"message" type:TSMessageNotificationTypeSuccess duration:2.0 canBeDismissedByUser:YES];
   // [TSMessage showNotificationWithTitle:@"System" subtitle:@"Save To Draft" type:TSMessageNotificationTypeSuccess];
}

@end
