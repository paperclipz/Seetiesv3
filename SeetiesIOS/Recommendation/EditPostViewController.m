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

@interface EditPostViewController ()
{
    NSString* postURL;
    BOOL isDualLanguge;

}

// =============== model ===============//
@property(nonatomic,strong)RecommendationModel* recommendationModel;

// =============== model ===============//

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@property (weak, nonatomic) IBOutlet UIView *ibDescContentView;
@property(nonatomic,strong)EditPhotoViewController* editPhotoViewController;
@property(nonatomic,strong)AddNewPlaceViewController* addNewPlaceViewController;

@property(nonatomic,strong)HMSegmentedControl* segmentedControl;
@property(nonatomic,strong)IBOutlet UISegmentedControl* postSegmentedControl;


@property(nonatomic,strong)EditPostDetailVIew* editPostView;
@property(nonatomic,strong)EditPostDetailVIew* editPostViewSecond;

@end

@implementation EditPostViewController
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

- (IBAction)btnEditPhotoClicked:(id)sender {
    
    //[self.navigationController pushViewController:self.editPhotoViewController animated:YES];
    
    [self.editPhotoViewController initData:self.recommendationModel];
      [self presentViewController:self.editPhotoViewController animated:YES completion:nil];
}
- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initData:(RecommendationModel*)model
{
    self.recommendationModel = model;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:@"http://cdn3.denofgeek.us/sites/denofgeekus/files/scarlett_johansson.jpg"]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {

                                self.ibImageView.image = [image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
                            }
                        }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    switch ((long)segmentedControl.selectedSegmentIndex) {
       
        default:
        case 0:
        {
            [self.customPickerViewController show];
        }
            break;
        case 1:
            [self presentViewController:self.addNewPlaceViewController animated:YES completion:nil];

            break;
            
        case 2:
            [self.editPhotoViewController initData:self.recommendationModel];
            [self presentViewController:self.editPhotoViewController animated:YES completion:nil];

            break;
    }
    
    segmentedControl.selectedSegmentIndex = -1;
}

-(CustomPickerViewController*)customPickerViewController
{
    
    if (!_customPickerViewController) {
        _customPickerViewController = [CustomPickerViewController initializeWithAddURLBlock:^(id object) {
            [self showAlertView];
        } AddLangBlock:^(id object) {
            
        }];
        [self.view addSubview:_customPickerViewController.view];
        [_customPickerViewController hideWithAnimation:NO];

    }
    return _customPickerViewController;
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
-(void)showAlertView
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add URL"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Done", nil];
    
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [av textFieldAtIndex:0];
    textField.placeholder = @"www.seeties.me";
    
    av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            postURL =[[alertView textFieldAtIndex:0] text];

            self.recommendationModel.postURL = postURL;
            NSLog(@"web url Link: %@", postURL);
        } else if (buttonIndex == alertView.cancelButtonIndex) {
            NSLog(@"Cancelled.");
        }
    };
    
    [av show];
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
    }
    return _addNewPlaceViewController;
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
@end
