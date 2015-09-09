//
//  RecommendationViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/11/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "RecommendationViewController.h"
@interface RecommendationViewController ()

@property(nonatomic,strong)RecommendationModel* recommendModel;
@property(nonatomic,strong)UIViewController* sender;

@end

@implementation RecommendationViewController
- (IBAction)btnEditPhotoClicked:(id)sender {
    
    [self showEditPostView];   
}
- (IBAction)btnPickImageClicked:(id)sender {
    
    [self presentViewController:self.navRecommendationViewController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)initData:(int)type sender:(id)sender
{
    self.sender =sender;
    switch (type) {
        case 1:
        {
            [self.draftViewController initData];
            self.navRecommendationViewController = [[UINavigationController alloc]initWithRootViewController:self.draftViewController];
            [self.navRecommendationViewController setNavigationBarHidden:YES];


        }
            break;
            
        default:
             self.navRecommendationViewController = [[UINavigationController alloc]initWithRootViewController:self.doImagePickerController];
            
            break;
    }
    
    [self.navRecommendationViewController setNavigationBarHidden:YES];
    [sender presentViewController:self.navRecommendationViewController animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didCancelDoImagePickerController
{
    SLog(@"didCancelDoImagePickerController");
    
    if (self.doImagePickerController) {
        [self.doImagePickerController dismissViewControllerAnimated:YES completion:nil];
        [self dismissView];
    }

}

-(void)dismissView
{
    if (self.backBlock) {
        self.backBlock(self);
    }
}
- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    if (aSelected.count == 0) {
        
        [TSMessage showNotificationInViewController:self.doImagePickerController
                                              title:LocalisedString(@"Error")
                                           subtitle:LocalisedString(@"No Image Selected")
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:2.0
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionBottom
                               canBeDismissedByUser:YES];
    }
    else{
        CLLocation* tempCurrentLocation;
        
        ALAsset* asset = aSelected[0];
        tempCurrentLocation = [asset valueForProperty:ALAssetPropertyLocation];
        [self showSearchView:tempCurrentLocation];
        [self processModelData:aSelected];
    }
   
    //Remark* check image has tag location, if not get device location. if device dont hace location route to search page with no suggestion
}

-(void)processModelData:(NSArray*)arrAssets
{
    for (int i = 0; i<arrAssets.count; i++) {
        
        EditPhotoModel* model = [EditPhotoModel new];
        model.image = [ASSETHELPER getImageFromAsset:arrAssets[i] type:ASSET_PHOTO_SCREEN_SIZE];
        model.photoDescription = [NSString stringWithFormat:@"photo : %d",i];
        [self.recommendModel.arrPostImagesList addObject:model];
    }
}

-(void)showSearchView:(CLLocation*)location
{
    
    [self.doImagePickerController.navigationController pushViewController:self.stSearchViewController animated:YES];
    [self.stSearchViewController initWithLocation:location];
}

-(void)showEditPostView
{
    [self.editPostViewController initData:self.recommendModel];
    [self.sender presentViewController:self.navEditPostViewController animated:YES completion:^{
        [self resetView];
    }];
}


#pragma mark - Declaration

-(DraftViewController*)draftViewController
{
    if (!_draftViewController) {
        _draftViewController = [DraftViewController new];
        
        __weak typeof (self)weakSelf = self;
        _draftViewController.backBlock = ^(id object)
        {
            [object dismissViewControllerAnimated:YES completion:^{
                [weakSelf dismissView];
            }];
            
        };
    }
    return _draftViewController;
}
-(STSearchViewController*)stSearchViewController{

    if(!_stSearchViewController)
    {
        _stSearchViewController = [STSearchViewController new];
        
        __block typeof (self)wealSelf = self;
        _stSearchViewController.didSelectRowAtIndexPathBlock = ^(NSIndexPath* indexPath, SearchType type)
        {
            
            switch (type) {
                default:
                case SearchTypeGoogle:
                {
                    DataManager* manager = [DataManager Instance];
                    SearchLocationModel* model = manager.googleSearchModel.predictions[indexPath.row];
                    [wealSelf.addNewPlaceViewController initDataFromGogle:model.place_id];
                }
                    break;
                case SearchTypeFourSquare:
                {
                    DataManager* manager = [DataManager Instance];
                    VenueModel* model = manager.fourSquareVenueModel.items[indexPath.row];
                    [wealSelf.addNewPlaceViewController initDataFrom4Square:model];
                }
                    break;
            }
            
            [wealSelf.navRecommendationViewController pushViewController:wealSelf.addNewPlaceViewController animated:YES];
            wealSelf.addNewPlaceViewController.title = @"Edit Place Info";

        };
        
        _stSearchViewController.btnAddNewPlaceBlock = ^(id object)
        {
            
            [wealSelf.navRecommendationViewController pushViewController:wealSelf.addNewPlaceViewController animated:YES];
          //  wealSelf.addNewPlaceViewController.title
            wealSelf.addNewPlaceViewController.title = @"New Place Info";
        };
    }
    return _stSearchViewController;
}

-(DoImagePickerController*)doImagePickerController
{
    
    if(!_doImagePickerController)
    {
        _doImagePickerController = [DoImagePickerController new];
        _doImagePickerController.delegate = self;
        _doImagePickerController.nMaxCount = 10;     // larger than 1
        _doImagePickerController.nColumnCount = 3;  // 2, 3, or 4
        
        _doImagePickerController.nResultType = DO_PICKER_RESULT_UIIMAGE; // get UIImage object array : common case
        // if you want to get lots photos, you had better use DO_PICKER_RESULT_ASSET.
        _doImagePickerController.nResultType = 1;
    }
    
    return _doImagePickerController;
}

-(EditPostViewController*)editPostViewController
{
    if(!_editPostViewController)
    {
        _editPostViewController = [EditPostViewController new];
    }
    return _editPostViewController;
}

-(UINavigationController*)navEditPostViewController
{
    if(!_navEditPostViewController)
    {
        _navEditPostViewController = [[UINavigationController alloc]initWithRootViewController:self.editPostViewController];
        [_navEditPostViewController setNavigationBarHidden:YES];
    }
    
    return _navEditPostViewController;
}

-(AddNewPlaceViewController*)addNewPlaceViewController
{
    if(!_addNewPlaceViewController)
    {
        
        __weak typeof (self)weakSelf = self;
        _addNewPlaceViewController = [AddNewPlaceViewController new];
        _addNewPlaceViewController.btnPressDoneBlock = ^(id object)
        {
            RecommendationVenueModel* temp = (RecommendationVenueModel*)object;
            
            weakSelf.recommendModel.reccomendVenueModel = temp;

            [weakSelf.navRecommendationViewController dismissViewControllerAnimated:YES completion:^{
                [weakSelf showEditPostView];

            }];
        };
        _addNewPlaceViewController.btnBackBlock = ^(id object)
        {
            [((UIViewController*)object).navigationController popViewControllerAnimated:YES];
            
        };
    }
    
    return _addNewPlaceViewController;
}

-(void)resetView
{
    //Reset view after going into edit post. all remaining data is no longer needed inside

    _doImagePickerController = nil;
    _addNewPlaceViewController = nil;
    _stSearchViewController = nil;
}

-(RecommendationModel*)recommendModel
{
    if (!_recommendModel) {
        _recommendModel = [RecommendationModel new];
    }
    
    return _recommendModel;
}

@end
