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
#import "NSArray+JSON.h"

@interface EditPostViewController ()
{
    NSString* postURL;
    BOOL isDualLanguge;
    BOOL isSaved;

}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnPublish;

// =============== model ===============//
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfPhotos;

@property(nonatomic,strong)RecommendationModel* recommendationModel;

@property(nonatomic,strong)RecommendationModel* tempSavedRecommendationModel;

@property(nonatomic,strong)CategoriesModel* categoriesModel;

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
@property(nonatomic,weak)EditPostDetailVIew* editPostView;
@property(nonatomic,weak)EditPostDetailVIew* editPostViewSecond;

@property(nonatomic,strong)UIAlertView* urlAlertView;
@end

@implementation EditPostViewController

#pragma mark - IBACTION
- (IBAction)btnEditPhotoClicked:(id)sender {
    
    [self saveData];
    _editPhotoViewController = nil;
    
    [self.editPhotoViewController initData:self.recommendationModel];
    
    [self presentViewController:self.editPhotoViewController animated:YES completion:nil];
    __weak typeof (self)weakSelf = self;
    self.editPhotoViewController.doneBlock = ^(NSArray* arrayImages,NSArray* arrDeleteImages)
    {
        
        weakSelf.recommendationModel.arrPostImagesList = nil;
        weakSelf.recommendationModel.arrPostImagesList = [[NSMutableArray alloc]initWithArray:arrayImages];
        
        [weakSelf.recommendationModel.arrDeletedImages addObjectsFromArray:arrDeleteImages];
        
    };

}
- (IBAction)btnPublishClicked:(id)sender {
    
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    
    if (!self.categoriesModel) {
        
        [self requestServerForCategories:^(id object) {
            [self showCategory];
        }];
        
    }
    else{
        [self showCategory];
    }

}

-(void)showCategory
{
    _categorySelectionViewController = nil;

    self.categoriesModel = [[DataManager Instance] categoriesModel];
    self.categorySelectionViewController.arrCategories = [self.categoriesModel.categories mutableCopy];
    
    //check for selected category for existing post. draft and new post no need to check for it
    if (self.recommendationModel.selectedCategories && self.editPostType == EditPostTypePostEdit) {
        [self.categorySelectionViewController setPreSelectedCategories:self.recommendationModel.selectedCategories];
    }
    
    if(![self.categorySelectionViewController.view isDescendantOfView:self.view])
    {
        [self.view addSubview:self.categorySelectionViewController.view];
    }
    
    [self.categorySelectionViewController show];

}

- (IBAction)segmentedControlClicked:(id)sender {
    
    UISegmentedControl* temp = (UISegmentedControl*)sender;
    BOOL isFirstView = temp.selectedSegmentIndex==1;
    [UIView transitionWithView:self.ibDescContentView
                      duration:1.0
                       options:isFirstView?UIViewAnimationOptionTransitionCrossDissolve :UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{

                        self.editPostViewSecond.hidden = !isFirstView;
                        self.editPostView.hidden = isFirstView;

                    } completion:^(BOOL finished) {
                        self.editPostView.hidden = isFirstView;
                        self.editPostViewSecond.hidden = !isFirstView;

                    }
     ];
 }


-(void)dismissView
{
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    if (self.editPostBackBlock) {
        self.editPostBackBlock(self);
    }

}

- (IBAction)btnBackClicked:(id)sender {
    
    
    if (self.editPostType == EditPostTypePostEdit) {
        
        [self dismissView];
    
    }
    else{
        [UIAlertView showWithTitle:LocalisedString(@"New Recommendation")
                       message:LocalisedString(@"You are quiting the editor. Save changes?")
             cancelButtonTitle:LocalisedString(@"Cancel")
             otherButtonTitles:@[LocalisedString(@"Discard"), LocalisedString(@"Save")]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex]) {
                              NSLog(@"Cancelled");

                          } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalisedString(@"Discard")]) {
                              NSLog(@"Discard");
                              
                              if (self.navigationController) {
                                  [self.navigationController popViewControllerAnimated:YES];
                              }
                              else{
                                  [self dismissViewControllerAnimated:YES completion:nil];

                              }
                              if (self.editPostBackBlock) {
                                  self.editPostBackBlock(self);
                              }

                          } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalisedString(@"Save")]) {
                              NSLog(@"Save");
                              isSaved = true;
                              [self requestToSaveDraftOrPublish:YES];
                          }
                      }];
    }
}

#pragma mark - INITIALIZATION
-(void)initData:(RecommendationModel*)model
{
    
    self.editPostType = EditPostTypeDraftNew;
    self.recommendationModel = model;

}

-(void)initDataDraft:(DraftModel*)model
{
    
    self.editPostType = EditPostTypeDraft;
    self.recommendationModel = [[RecommendationModel alloc]initWithDraftModel:model];
    
   
}


-(void)initDataPostEdit:(DraftModel*)model
{

    self.editPostType = EditPostTypePostEdit;
    self.recommendationModel = [[RecommendationModel alloc]initWithDraftModel:model];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self changeLanguage];
    [self setViewWithNumberOfLanguage];

   // [self resetData];
}

#pragma mark - Change Language
-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Edit Post");
    [self.btnPublish setTitle:LocalisedString(@"Publish") forState:UIControlStateNormal];

}

-(void)loadData
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        [self.editPostView initData:self.recommendationModel viewNo:1];
        [self.editPostViewSecond initData:self.recommendationModel viewNo:2];
        [self reloadImage];

    } completion:nil];
   
}

-(void)setViewWithNumberOfLanguage
{
    switch (self.editPostType) {
        case EditPostTypeDraft:
        {
            [self.postSegmentedControl setTitle:[Utils getLanguageName:self.recommendationModel.postMainLanguage] forSegmentAtIndex:0];
            
            if (!self.recommendationModel.postSecondTitle) {
                [self setHasDualLanguage:NO];
                
            }
            else{
                [self.postSegmentedControl setTitle:[Utils getLanguageName:self.recommendationModel.postSeconLanguage] forSegmentAtIndex:1];
                [self setHasDualLanguage:YES];

            }
        }
            break;
            
        default:
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString* langOne = [defaults objectForKey:@"UserData_Language1"];
            NSString* langTwo = [defaults objectForKey:@"UserData_Language2"];
            
            self.recommendationModel.postMainLanguage = [Utils getLanguageCode:langOne];
            [self.postSegmentedControl setTitle:langOne forSegmentAtIndex:0];
            
            if (!langTwo || [langTwo isEqualToString:@""]) {
                [self setHasDualLanguage:NO];
            }
            else{
                [self.postSegmentedControl setTitle:langTwo forSegmentAtIndex:1];
                self.recommendationModel.postSeconLanguage = [Utils getLanguageCode:langTwo];
                [self setHasDualLanguage:YES];

            }
            
        }
            break;
    }
}

-(void)resetData
{
    self.editPostView.txtTitle.text = @"";
    self.editPostView.txtDescription.text = @"";
    
    self.editPostViewSecond.txtTitle.text = @"";
    self.editPostViewSecond.txtDescription.text = @"";
}

-(void)reloadImage
{
    int photoCount = (int)self.recommendationModel.arrPostImagesList.count;
    self.lblNumberOfPhotos.text = [NSString stringWithFormat:@"%d %@",photoCount,LOCALIZATION(@"Photos")];
        if (self.recommendationModel.arrPostImagesList && photoCount>0) {
            
            PhotoModel* edifotoModel = self.recommendationModel.arrPostImagesList[0];
            
            if (edifotoModel.image) {
                
                self.ibImageView.image = [edifotoModel.image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];

            }
            else if(edifotoModel.imageURL)
            {
                
                [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:edifotoModel.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    self.ibImageView.image = [image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
                    
                }];

            }

//            switch (self.editPostType) {
//                default:
//                case EditPostTypeDraftNew:
//                    self.ibImageView.image = [edifotoModel.image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
//
//                    break;
//                    
//                    case EditPostTypeDraft:
//                    
//                    [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:edifotoModel.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                        self.ibImageView.image = [image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
//
//                    }];
//
//                    break;
//            }
            
            
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isSaved = false;
    [self loadData];


}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    [self saveData];
    switch ((long)segmentedControl.selectedSegmentIndex) {
       
        default:
        case 0:
        {
            
            [self.urlAlertView show];

        }
            break;
        case 1:
        {
         
            [self showQrRecommendationView];
         
        }

            break;
            
        case 2:
        {
            
            
            [self.addNewPlaceViewController initData:self.recommendationModel.reccomendVenueModel];

            [self presentViewController:self.navAddNewPlaceViewController animated:YES completion:^{
                

            }];

            
        }
            break;
        case 3:
            
            [self requestToSaveDraftOrPublish:YES];
            break;
    }
    
    segmentedControl.selectedSegmentIndex = -1;
}

-(void)initSelfView
{
    
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
        _urlAlertView = [[UIAlertView alloc] initWithTitle:LocalisedString(@"Add URL")
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:LocalisedString(@"No thanks!")
                                         otherButtonTitles:LocalisedString(@"Done!"), nil];
        
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

-(void)showQrRecommendationView
{
    
    if(![self.articleViewController.view isDescendantOfView:self.view])
    {
        [self.view addSubview:self.articleViewController.view];

    }
    
    [self.articleViewController show];
}

#pragma mark - Declarations
-(CategorySelectionViewController*)categorySelectionViewController
{
    if(!_categorySelectionViewController)
    {
        
        __weak typeof(self)weakSelf = self;
        _categorySelectionViewController = [CategorySelectionViewController new];
        _categorySelectionViewController.doneClickBlock = ^(NSArray* arrCat)
        {
            
            weakSelf.categoriesModel.categories = [arrCat mutableCopy];
            [weakSelf requestToSaveDraftOrPublish:NO];
        };
        
    }
    return _categorySelectionViewController;
}

-(NSArray*)arrTabImages
{
    if ( self.editPostType == EditPostTypePostEdit) {
        return @[[UIImage imageNamed:@"AddLanguageBtn.png"],[UIImage imageNamed:@"StarRecommendationBtn.png"],[UIImage imageNamed:@"LocationBtn.png"]];

    }
    else{
        return @[[UIImage imageNamed:@"AddLanguageBtn.png"],[UIImage imageNamed:@"StarRecommendationBtn.png"],[UIImage imageNamed:@"LocationBtn.png"],[UIImage imageNamed:@"SaveDraftBtn.png"]];

    }
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
        _segmentedControl.verticalDividerColor = [UIColor grayColor];
        _segmentedControl.verticalDividerEnabled = YES;
        _segmentedControl.verticalDividerColor = TEXT_GRAY_COLOR;
        _segmentedControl.verticalDividerWidth = .5f;
        //_segmentedControl.selectionIndicatorHeight = 10.0f;
    }


    return _segmentedControl;
}
-(AddNewPlaceViewController*)addNewPlaceViewController
{
    
    if(!_addNewPlaceViewController)
    {
        _addNewPlaceViewController = [AddNewPlaceViewController new];
        _addNewPlaceViewController.title = LocalisedString(@"Edit Place Info");
        __weak typeof (self)weakSelf = self;
        _addNewPlaceViewController.btnBackBlock = ^(id object)
        {
            [weakSelf.addNewPlaceViewController dismissViewControllerAnimated:YES completion:nil];
        };
        
        
        _addNewPlaceViewController.btnPressDoneBlock = ^(id object)
        {
            RecommendationVenueModel* temp = (RecommendationVenueModel*)object;
            
            weakSelf.recommendationModel.reccomendVenueModel = temp;
            [weakSelf.addNewPlaceViewController dismissViewControllerAnimated:YES completion:^{
                [weakSelf reloadImage];
            }];

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


-(ArticleViewController*)articleViewController
{
    if (!_articleViewController) {
        _articleViewController = [ArticleViewController new];
    }
    
    return _articleViewController;
}

-(void)setHasDualLanguage:(BOOL)hasDualLang
{
    isDualLanguge = hasDualLang;

    self.descViewTopLayoutConstraint.constant = hasDualLang?43:0;

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

static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}


#define POST_DRAFT @"0"
#define POST_PUBLISH @"1"


-(void)requestToSaveDraftOrPublish:(BOOL)isDraft
{
    [self saveData];
    NSMutableArray* arrMeta = [NSMutableArray new];

    RecommendationModel* tempModel = self.recommendationModel;
    RecommendationVenueModel* tempVenueModel = tempModel.reccomendVenueModel;

    for (int i =0; i<self.recommendationModel.arrPostImagesList.count; i++) {
        
        PhotoModel* model = self.recommendationModel.arrPostImagesList[i];
        [arrMeta addObject:model];
    }
    
    NSDictionary* addressDict = @{@"route":ObjectOrNull(tempVenueModel.route),
                                  @"locality":ObjectOrNull(tempVenueModel.city),
                                  @"administrative_area_level_1":ObjectOrNull(tempVenueModel.state),
                                  @"postalCode":ObjectOrNull(tempVenueModel.postalCode),
                                  @"country":ObjectOrNull(tempVenueModel.country),
                                  @"political":@""};
    
    NSMutableArray* dictPeriods = [NSMutableArray new];

    for (int i = 0; i<tempVenueModel.arrOperatingHours.count; i++) {
        
        OperatingHoursModel* hourModel = tempVenueModel.arrOperatingHours[i];
        if (hourModel.isOpen)
            [dictPeriods addObject:[hourModel toDictionary]];
    }

//    NSArray* dictPeriods = @[@{@"close":@{@"day":@0,@"time":@"1111"},@"open":@{@"day":@0,@"time":@"1030"}},
//                             @{@"close":@{@"day":@1,@"time":@"1222"},@"open":@{@"day":@1,@"time":@"1030"}},
//                             @{@"close":@{@"day":@2,@"time":@"1333"},@"open":@{@"day":@2,@"time":@"1030"}},
//                             @{@"close":@{@"day":@3,@"time":@"1444"},@"open":@{@"day":@3,@"time":@"1030"}}];
//  
//    SLog(@"compiled dict 2222 : %@",dictPeriods);

    
    //  NSString* tempString = [string stringByReplacingOccurrencesOfString:@"open" withString:@"GG"];
    NSDictionary* openingHourDict = @{@"open_now":@"false",
                                      @"periods":ObjectOrNull(dictPeriods)};
    
    NSDictionary* locationDict  = @{@"address_components":addressDict,
                                    @"name":ObjectOrNull(tempVenueModel.name),
                                    @"formatted_address":ObjectOrNull(tempVenueModel.formattedAddress),
                                    @"type":@2,
                                    @"reference":ObjectOrNull(tempVenueModel.reference),
                                    @"expense":ObjectOrNull(tempVenueModel.expense),
                                    @"rating":@11,
                                    @"contact_no":ObjectOrNull(tempVenueModel.formattedPhone),
                                    @"source":@"",
                                    @"opening_hours":openingHourDict,
                                    @"link":ObjectOrNull(tempVenueModel.url),
                                    @"lat":ObjectOrNull(tempVenueModel.lat),
                                    @"lng":ObjectOrNull(tempVenueModel.lng)};
    
    
    NSMutableArray* categoriesSelected = [NSMutableArray new];
    
    for (int i = 0; i < self.categoriesModel.categories.count; i++) {
    
        CategoryModel* model = self.categoriesModel.categories[i];
        if (model.isSelected) {
            [categoriesSelected addObject:@(model.id)];

        }
    }
    
    NSDictionary* dict = @{@"token":[Utils getAppToken],
                           @"status":isDraft?POST_DRAFT:POST_PUBLISH,
                           [NSString stringWithFormat:@"title[%@]",self.recommendationModel.postMainLanguage]:ObjectOrNull(tempModel.postMainTitle),
                           [NSString stringWithFormat:@"message[%@]",self.recommendationModel.postMainLanguage]:ObjectOrNull(tempModel.postMainDescription),
                           @"category":categoriesSelected.count==0?@[@0]:categoriesSelected,
                           @"device_type":@2,
                           @"location":[Utils convertToJsonString:locationDict],
                           @"link":ObjectOrNull(tempModel.postURL)};
    

    NSDictionary* dictSecondDesc = @{[NSString stringWithFormat:@"title[%@]",self.recommendationModel.postSeconLanguage]:ObjectOrNull(tempModel.postSecondTitle),
                                 [NSString stringWithFormat:@"message[%@]",self.recommendationModel.postSeconLanguage]:ObjectOrNull(tempModel.postSecondDescription)};
    
    
    NSMutableDictionary* finalDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    if (isDualLanguge) {
        [finalDict addEntriesFromDictionary:dictSecondDesc];
    }
    
    for (int i = 0; i<tempModel.arrDeletedImages.count; i++) {
        
        NSDictionary* tempDict = @{[NSString stringWithFormat:@"delete_photos[%d]",i]:tempModel.arrDeletedImages[i]};
        [finalDict addEntriesFromDictionary:tempDict];

    }
    
    [LoadingManager showWithTitle:LocalisedString(@"Posting...")];

    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostSaveDraft param:finalDict appendString:tempModel.post_id meta:arrMeta  completeHandler:^(id object) {
        
        self.tempSavedRecommendationModel = self.recommendationModel;
        if (!isDraft) {
            
            [self performSelector:@selector(buttonDoneAction) withObject:nil afterDelay:2.0f];
        }
        else{ // This is draft
            [TSMessage showNotificationInViewController:self title:@"system" subtitle:LocalisedString(@"Data Successfully Saved to Draft") type:TSMessageNotificationTypeSuccess duration:2.0 canBeDismissedByUser:YES];
            
            RecommendationModel* model = [[RecommendationModel alloc]initWithDraftModel:[ConnectionManager dataManager].savedDraftModel];
            self.recommendationModel = model;
            
            if (isSaved) {
                [self dismissView];
            }
        }
    
    } errorBlock:^(id object) {

        
        [TSMessage showNotificationInViewController:self title:@"system" subtitle:object?object:LocalisedString(@"Uh-oh. Something went wrong. Tap to retry.") type:TSMessageNotificationTypeError duration:2.0 canBeDismissedByUser:YES];

    }];
    
}

//button done
-(void)buttonDoneAction
{
    
    SLog(@"buttonDoneAction");
    [self dismissViewControllerAnimated:YES completion:nil];

    if (_editPostDoneBlock) {
        self.editPostDoneBlock(nil);
    }
}

#pragma mark - Sava Data

-(void)saveData
{
    
    self.recommendationModel.postMainTitle = self.editPostView.txtTitle.text;
    self.recommendationModel.postMainDescription = self.editPostView.txtDescription.text;
    self.recommendationModel.postSecondTitle = self.editPostViewSecond.txtTitle.text;
    self.recommendationModel.postSecondDescription = self.editPostViewSecond.txtDescription.text;

}

-(void)requestServerForCategories:(IDBlock)sucessRequestBlock
{
    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetCategories param:nil appendString:nil  completeHandler:^(id object) {
        
        if (sucessRequestBlock) {
            sucessRequestBlock(nil);
        }
        [LoadingManager hide];

    } errorBlock:^(id object) {
        [LoadingManager hide];

    }];
}

-(void)requestServerForPostInfo:(NSString*)postID completionBLock:(VoidBlock)completionBlock
{
    SLog(@"requestServerForPostInfo");
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetPostInfo param:nil appendString:postID completeHandler:^(id object) {
        
        if (completionBlock) {
            completionBlock();
        }
    } errorBlock:^(id object) {
        
        
    }];
}
@end
