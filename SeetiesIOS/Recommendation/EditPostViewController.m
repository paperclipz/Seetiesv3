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
@property (weak, nonatomic) IBOutlet UIButton *btnPublish;

// =============== model ===============//

@property(nonatomic,strong)DraftModel* postModel;
@property(nonatomic,strong)DraftModel* storedModel;

//@property(nonatomic,strong)DraftModel* postModelDuplicate;

@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfPhotos;

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

 //   self.postModelDuplicate = self.postModel;
    
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:self.editPhotoViewController];;
    
    [navigationController setNavigationBarHidden:YES animated:NO];

    [self.editPhotoViewController initData:self.postModel];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
    __weak typeof (self)weakSelf = self;
    self.editPhotoViewController.doneBlock = ^(NSArray* arrayImages,NSArray* arrDeleteImages)
    {
        
        weakSelf.postModel.arrPhotos = nil;
        weakSelf.postModel.arrPhotos = [[NSMutableArray<PhotoModel> alloc]initWithArray:arrayImages];
        
        [weakSelf.postModel.arrDeletePosts addObjectsFromArray:arrDeleteImages];
        
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
    if (![Utils isArrayNull:self.postModel.category] && self.editPostType == EditPostTypePostEdit) {
        [self.categorySelectionViewController setPreSelectedCategories:self.postModel.category];
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
    
    
    [self saveData];
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
//-(void)initData:(RecommendationModel*)model
//{
//    
//    self.editPostType = EditPostTypeDraftNew;
//    self.recommendationModel = model;
//    self.tempSavedRecommendationModel = self.recommendationModel;
//
//}

-(void)initDataDraft:(DraftModel*)model
{
    self.postModel = model;
    self.storedModel = [model copy];
 //   self.postModelDuplicate = model;

    self.editPostType = EditPostTypeDraft;
   // self.recommendationModel = [[RecommendationModel alloc]initWithDraftModel:model];
  //  self.tempSavedRecommendationModel = self.recommendationModel;

}

-(void)initDataPostEdit:(DraftModel*)model
{

    self.editPostType = EditPostTypePostEdit;
    
    self.postModel = model;
    self.storedModel = [model copy];
   // self.recommendationModel = [[RecommendationModel alloc]initWithDraftModel:model];
  //  self.tempSavedRecommendationModel = self.recommendationModel;

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
        
        [self.editPostView initData:self.postModel];
        [self reloadImage];

    } completion:nil];
   
}

-(void)setViewWithNumberOfLanguage
{
    [self setHasDualLanguage:NO];
//    switch (self.editPostType) {
//        case EditPostTypeDraft:
//        {
//            [self.postSegmentedControl setTitle:[Utils getLanguageName:self.recommendationModel.postMainLanguage] forSegmentAtIndex:0];
//            
//            if (!self.recommendationModel.postSecondTitle) {
//                [self setHasDualLanguage:NO];
//                
//            }
//            else{
//                [self.postSegmentedControl setTitle:[Utils getLanguageName:self.recommendationModel.postSeconLanguage] forSegmentAtIndex:1];
//                [self setHasDualLanguage:YES];
//
//            }
//        }
//            break;
//            
//        default:
//        {
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            NSString* langOne = [defaults objectForKey:KEY_LANGUAGE_ONE];
//            NSString* langTwo = [defaults objectForKey:KEY_LANGUAGE_TWO];
//            
//            self.recommendationModel.postMainLanguage = langOne;
//            [self.postSegmentedControl setTitle:[Utils getLanguageName:langOne] forSegmentAtIndex:0];
//            
//            if ([Utils isStringNull:langTwo]) {
//                [self setHasDualLanguage:NO];
//            }
//            
//            else{
//                [self.postSegmentedControl setTitle:[Utils getLanguageName:langTwo] forSegmentAtIndex:1];
//                self.recommendationModel.postSeconLanguage = langTwo;
//                [self setHasDualLanguage:YES];
//
//            }
//            
//        }
//            break;
//    }
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
    int photoCount = (int)self.postModel.arrPhotos.count;
    self.lblNumberOfPhotos.text = [NSString stringWithFormat:@"%d %@",photoCount,LOCALIZATION(@"Photos")];
        if (![Utils isArrayNull:self.postModel.arrPhotos]) {
            
            PhotoModel* edifotoModel = self.postModel.arrPhotos[0];
            
            if (edifotoModel.image) {
                
                self.ibImageView.image = [edifotoModel.image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];

            }
            else if(edifotoModel.imageURL)
            {
                
                [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:edifotoModel.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    self.ibImageView.image = [image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
                    
                }];

            }
            
            
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
            
            [self.addNewPlaceViewController initData:self.postModel];

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
                
                weakSelf.postModel.link = [[alertView textFieldAtIndex:0] text];

            } else if (buttonIndex == alertView.cancelButtonIndex) {
                NSLog(@"Cancelled.");
            }
        };

    }
    
    _urlAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [_urlAlertView textFieldAtIndex:0];
    if (self.postModel.link) {
        textField.text = self.postModel.link;
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
        
        __weak typeof (self)weakSelf = self;
        _editPhotoViewController.editPhotoBackClickedBlock = ^(id block)
        {
    //        weakSelf.postModel = weakSelf.postModelDuplicate;
            
        };
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
        
        
        _addNewPlaceViewController.btnPressDoneBlock = ^(DraftModel* model)
        {
            
            weakSelf.postModel = model;

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

//-(RecommendationModel*)recommendationModel
//{
//    if(!_recommendationModel)
//    {
//        _recommendationModel  = [RecommendationModel new];
//        _recommendationModel.postMainDescription = @"main title Desc";
//        _recommendationModel.postMainTitle = @"main title";
//        _recommendationModel.postSecondDescription = @"second title Desc";
//        _recommendationModel.postSecondTitle = @"second title";
//
//    }
//    return _recommendationModel;
//}

//button done
-(void)buttonDoneAction
{
    
    SLog(@"buttonDoneAction");
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_editPostDoneBlock) {
        self.editPostDoneBlock(self);
    }
}

#pragma mark - Sava Data

-(void)saveData
{
    
    self.postModel.post.title = self.editPostView.txtTitle.text;
    self.postModel.post.message = self.editPostView.txtDescription.text;
}

#pragma mark - Server Request

static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}

-(NSString*)stringOrBlank:(NSString*)str
{
    if (!str) {
        return @"";
    }
    else{
        return str;
    }
}

-(id)dictOrBlank:(NSDictionary*)dict
{
    if (!dict) {
        return @"";
    }
    else{
        return dict;
    }
}


#define POST_DRAFT @"0"
#define POST_PUBLISH @"1"


-(void)requestToSaveDraftOrPublish:(BOOL)isDraft
{
    [self saveData];
    
    NSMutableArray* arrMeta = [NSMutableArray new];

    
    for (int i =0; i<self.postModel.arrPhotos.count; i++) {
        
        PhotoModel* model = self.postModel.arrPhotos[i];
        [arrMeta addObject:model];
    }
    
    NSDictionary* addressDict = @{@"route":ObjectOrNull(self.postModel.location.route),
                                  @"locality":ObjectOrNull(self.postModel.location.locality),
                                  @"administrative_area_level_1":ObjectOrNull(self.postModel.location.administrative_area_level_1),
                                  @"postalCode":ObjectOrNull(self.postModel.location.postal_code),
                                  @"country":ObjectOrNull(self.postModel.location.country),
                                  @"political":@""};
    
    NSMutableArray* dictPeriods = [NSMutableArray new];

    for (int i = 0; i<self.postModel.location.opening_hours.periods.count; i++) {
        
        OperatingHoursModel* hourModel = self.postModel.location.opening_hours.periods[i];
        if (hourModel.isOpen)
            [dictPeriods addObject:[hourModel toDictionary]];
    }
    
    NSDictionary* openingHourDict = @{@"open_now":@"false",
                                      @"periods":[Utils isArrayNull:dictPeriods]?@"":dictPeriods
                                      };
   
    NSDictionary* expensesDict;
    
    if (self.postModel.location.price) {
        
        expensesDict = @{@"code":[self stringOrBlank:self.postModel.location.currency],
                         @"value":[self stringOrBlank:self.postModel.location.price]};
    }

    // ========================   location =============================
    NSDictionary* locationDict;
   
    locationDict  = @{@"address_components":ObjectOrNull(addressDict),
                      @"name":[self stringOrBlank:self.postModel.location.name],
                      @"formatted_address":[self stringOrBlank:self.postModel.location.formatted_address],
                      @"type":@(self.postModel.location.type),
                      @"rating":@"",
                      @"reference":[self stringOrBlank:self.postModel.location.reference],
                      @"contact_no":[self stringOrBlank:self.postModel.location
                                     .contact_no],
                      @"source":@"",
                      @"opening_hours":ObjectOrNull(openingHourDict),
                      @"link":[self stringOrBlank:self.postModel.location.link],
                      @"lat":[self stringOrBlank:self.postModel.location.lat],
                      @"expense":[self dictOrBlank:expensesDict],
                      @"lng":[self stringOrBlank:self.postModel.location.lng]
                      };
    
//    NSMutableDictionary* finalLocationDict = [[NSMutableDictionary alloc]initWithDictionary:locationDict];
//       [finalLocationDict addEntriesFromDictionary:expensesDict];

    // ========================   location =============================

    NSMutableArray* categoriesSelected = [NSMutableArray new];
    
    for (int i = 0; i < self.categoriesModel.categories.count; i++) {
    
        CategoryModel* model = self.categoriesModel.categories[i];
        if (model.isSelected) {
            [categoriesSelected addObject:@(model.category_id)];

        }
    }
    
    NSString* languageCode = [Utils getDeviceAppLanguageCode];
    
    if ([Utils isStringNull:languageCode]) {
        languageCode = [Utils getDeviceDefaultLanguageCode];
    }
    NSDictionary* dict = @{@"token":[Utils getAppToken],
                           @"status":isDraft?POST_DRAFT:POST_PUBLISH,
                           [NSString stringWithFormat:@"title[%@]",languageCode]:[self stringOrBlank:self.postModel.post.title],
                           [NSString stringWithFormat:@"message[%@]",languageCode]:[self stringOrBlank:self.postModel.post.message],
                           @"category":categoriesSelected.count==0?@[@0]:categoriesSelected,
                           @"device_type":@2,
                           @"location":[Utils convertToJsonString:locationDict],
                           @"link":[self stringOrBlank:self.postModel.location.link]};
    


//    NSDictionary* dictSecondDesc = @{[NSString stringWithFormat:@"title[%@]",self.recommendationModel.postSeconLanguage]:ObjectOrNull(tempModel.postSecondTitle),
//                                 [NSString stringWithFormat:@"message[%@]",self.recommendationModel.postSeconLanguage]:ObjectOrNull(tempModel.postSecondDescription)};
//    
    
    NSMutableDictionary* finalDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
//    if (isDualLanguge) {
//        [finalDict addEntriesFromDictionary:dictSecondDesc];
//    }
    
    for (int i = 0; i<self.postModel.arrDeletePosts.count; i++) {
        
        NSDictionary* tempDict = @{[NSString stringWithFormat:@"delete_photos[%d]",i]:self.postModel.arrDeletePosts[i]};
        [finalDict addEntriesFromDictionary:tempDict];

    }
    
    [LoadingManager showWithTitle:LocalisedString(@"Posting...")];

    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostSaveDraft param:finalDict appendString:self.postModel.post_id meta:arrMeta  completeHandler:^(id object) {
        
        if (!isDraft) {
            
            [self performSelector:@selector(buttonDoneAction) withObject:nil afterDelay:2.0f];
        }
        else{ // This is draft
            [TSMessage showNotificationInViewController:self title:@"system" subtitle:LocalisedString(@"Data Successfully Saved to Draft") type:TSMessageNotificationTypeSuccess duration:2.0 canBeDismissedByUser:YES];
            
         //   RecommendationModel* model = [[RecommendationModel alloc]initWithDraftModel:[ConnectionManager dataManager].savedDraftModel];
            self.postModel = [[ConnectionManager dataManager]savedDraftModel];
           // self.postModelDuplicate = [[ConnectionManager dataManager]savedDraftModel];
            self.storedModel = [self.postModel copy];

            if (isSaved) {
                [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.0f];
            }
        }
    
    } errorBlock:^(id object) {

        [TSMessage showNotificationInViewController:self title:@"system" subtitle:object?object:LocalisedString(@"Uh-oh. Something went wrong. Tap to retry.") type:TSMessageNotificationTypeError duration:2.0 canBeDismissedByUser:YES];

    }];
    
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
