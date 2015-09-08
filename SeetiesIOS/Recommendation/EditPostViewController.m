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

@end

@implementation EditPostViewController
- (IBAction)btnPublishClicked:(id)sender {
    
    [self requestServerForPublishPost];
    
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
            
            [self showAlertView];

        }
            break;
        case 1:
        {
            [self.addNewPlaceViewController initData:self.recommendationModel.reccomendVenueModel];
            [self presentViewController:self.navAddNewPlaceViewController animated:YES completion:nil];

        }

            break;
            
        case 2:
        {
                [self.editPhotoViewController initData:self.recommendationModel];
                [self presentViewController:self.editPhotoViewController animated:YES completion:nil];
                __weak typeof (self)weakSelf = self;
                self.editPhotoViewController.doneBlock = ^(NSArray* array)
                {
                
                weakSelf.recommendationModel.arrPostImagesList = nil;
                weakSelf.recommendationModel.arrPostImagesList = [[NSMutableArray alloc]initWithArray:array];
                };

        }
        case 3:
            [self presentViewController:self.categorySelectionViewController animated:YES completion:nil];
            
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
-(CategorySelectionViewController*)categorySelectionViewController
{
    if(!_categorySelectionViewController)
    {
        _categorySelectionViewController = [CategorySelectionViewController new];
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
       
    }
    return _addNewPlaceViewController;
}


-(UINavigationController*)navAddNewPlaceViewController
{
    
    if(!_navAddNewPlaceViewController)
    {
        _navAddNewPlaceViewController = [[UINavigationController alloc]initWithRootViewController:self.addNewPlaceViewController];
        _navAddNewPlaceViewController.navigationBarHidden = YES;
        
        
        __weak typeof (self)weakSelf = self;
        self.addNewPlaceViewController.btnBackBlock = ^(id object)
        {
            [weakSelf.addNewPlaceViewController dismissViewControllerAnimated:YES completion:nil];
        };
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
    
    for (int i =0; i<self.recommendationModel.arrPostImagesList.count; i++) {
        
        EditPhotoModel* model = self.recommendationModel.arrPostImagesList[i];
        [arrImages addObject: model.image];
    }
    
    NSDictionary* addressDict = @{@"route":@"setapak",@"locality":@"KL",@"administrative_area_level_1":@"Federal Territory of Kuala Lumpur",@"postalCode":@"123456",@"country":@"malaysia",@"political":@"abc"};

    NSDictionary* sourceDict = @{@"open_now":@"true",@"periods":@"",@"weekday_text":@""};
    
    NSDictionary* openingHourDict = @{@"open_now":@"false",@"periods":@""};

    NSDictionary* locationDict  = @{@"address_components":addressDict,@"name":@"setapak",@"formatted_address":@"",@"type":@2,@"reference":@"",@"expense":@"",@"rating":@11,@"contact_no":@"",@"source":sourceDict,@"opening_hours":openingHourDict,@"link":@"",@"lat":@"3.1333",@"lng":@"101.7000"};

    NSDictionary* photo_meta = @{@"photo_id":@"",@"position":@"",@"caption":@""};
    
    NSDictionary* dict = @{@"post_id":@"",@"token":@"JDJ5JDEwJDZyamE0MlZKbTNKbHpDSElxR0dpUGVnbkJQMzdzRC40eDJna2M3RlJiVFZVbnJzRVpTQTNt",@"status":@"0",[NSString stringWithFormat:@"title[%@]",ENGLISH_CODE]:@"title1",[NSString stringWithFormat:@"message[%@]",ENGLISH_CODE]:@"msg1",@"category":@[@1,@2],@"device_type":@2,@"location":[locationDict getJsonString],@"link":@"www.google.com",@"photo_meta":@[photo_meta,photo_meta]};
    
    
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostCreatePost param:dict images:arrImages  completeHandler:^(id object) {
        
    } errorBlock:nil];
    
   


}



@end
