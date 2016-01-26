//
//  DraftAndRecommendationDelegate.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/22/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DraftAndRecommendationDelegate.h"
#import "DoImagePickerController.h"
#import "AssetHelper.h"
#import "STSearchViewController.h"
#import "EditPostViewController.h"
#import "AddNewPlaceViewController.h"
#import "DraftViewController.h"
@interface DraftAndRecommendationDelegate()<DoImagePickerControllerDelegate>
@property(nonatomic)RecommendationModel* recommendModel;
@property(nonatomic)DoImagePickerController* imagePickerViewController;

@property(nonatomic,strong)STSearchViewController* stSearchViewController;
@property(nonatomic,strong)EditPostViewController* editPostViewController;
@property(nonatomic,strong)AddNewPlaceViewController* addNewPlaceViewController;
@property(nonatomic,strong)DraftViewController* draftViewController;

@property(nonatomic)UIViewController* senderController;

@end
@implementation DraftAndRecommendationDelegate

-(void)showRecommendationView:(id)sender
{
    _recommendModel = nil;
    self.senderController = sender;
    _imagePickerViewController = nil;
    [self.senderController.navigationController pushViewController:self.imagePickerViewController animated:YES];
}

-(void)showDraftView:(id)sender
{
    _recommendModel = nil;
    self.senderController = sender;
    _draftViewController = nil;
    [self.senderController.navigationController pushViewController:self.draftViewController animated:YES onCompletion:^{
        
        [self.draftViewController initData];
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
           
            [_draftViewController.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _draftViewController;
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
            
            [weakSelf.senderController.navigationController popToViewController:weakSelf.senderController animated:YES onCompletion:^{
                [weakSelf showEditPostView];

            }];
            
        };
        _addNewPlaceViewController.btnBackBlock = ^(id object)
        {
            [((UIViewController*)object).navigationController popViewControllerAnimated:YES];
            _addNewPlaceViewController = nil;
            
        };
    }
    
    return _addNewPlaceViewController;
}
-(STSearchViewController*)stSearchViewController{
    
    if(!_stSearchViewController)
    {
        _stSearchViewController = [STSearchViewController new];
        [_stSearchViewController setViewNew];
        __block typeof (self)weakSelf = self;
        _stSearchViewController.didSelectOnLocationBlock = ^(RecommendationVenueModel* model)
        {
            
            weakSelf.recommendModel.reccomendVenueModel = model;
            [weakSelf.senderController.navigationController popToViewController:weakSelf.senderController animated:YES onCompletion:^{
                [weakSelf showEditPostView];

            }];
            
        };
        
        _stSearchViewController.btnAddNewPlaceBlock = ^(id object)
        {
            [weakSelf.senderController.navigationController pushViewController:weakSelf.addNewPlaceViewController animated:YES];
            //  wealSelf.addNewPlaceViewController.title
            weakSelf.addNewPlaceViewController.title = @"Add New Place";
        };
    }
    return _stSearchViewController;
}


-(EditPostViewController*)editPostViewController
{
    if(!_editPostViewController)
    {
        _editPostViewController = [EditPostViewController new];
        
        //_editPostViewController.editPostDoneBlock = self.donePostBlock;
        
    }
    return _editPostViewController;
}

-(RecommendationModel*)recommendModel
{
    if (!_recommendModel) {
        _recommendModel = [RecommendationModel new];
    }
    return _recommendModel;
}

-(DoImagePickerController*)imagePickerViewController
{
    
    if(!_imagePickerViewController)
    {
        _imagePickerViewController = [DoImagePickerController new];
        _imagePickerViewController.delegate = self;
        _imagePickerViewController.nMaxCount = 10;     // larger than 1
        _imagePickerViewController.nColumnCount = 3;  // 2, 3, or 4
        
        _imagePickerViewController.nResultType = DO_PICKER_RESULT_UIIMAGE; // get UIImage object array : common case
        // if you want to get lots photos, you had better use DO_PICKER_RESULT_ASSET.
        _imagePickerViewController.nResultType = 1;
    }
    
    return _imagePickerViewController;
}

-(void)showSearchView:(CLLocation*)location
{
    _stSearchViewController = nil;
    [_stSearchViewController setViewNew];
    [self.senderController.navigationController pushViewController:self.stSearchViewController animated:YES];
  //  [self.stSearchViewController initWithLocation:location];
}

-(void)showEditPostView
{
    _editPostViewController = nil;
    [self.editPostViewController initData:self.recommendModel];
    [self.senderController.navigationController pushViewController:self.editPostViewController animated:YES];
    
}

#pragma mark - DOImage Delegate
- (void)didCancelDoImagePickerController
{
    SLog(@"didCancelDoImagePickerController");
    
    if (self.senderController.navigationController) {
        [self.senderController.navigationController popViewControllerAnimated:YES];
        //[self dismissView];
    }
    else{
        [self.imagePickerViewController dismissViewControllerAnimated:YES completion:nil];

    }
    
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    if (aSelected.count == 0) {
        
        [TSMessage showNotificationInViewController:self.imagePickerViewController
                                              title:LocalisedString(@"error")
                                           subtitle:LocalisedString(@"No Image Selected")
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:2.0
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
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
    
    self.recommendModel.arrPostImagesList = nil;
    self.recommendModel.arrPostImagesList  = [NSMutableArray new];
    for (int i = 0; i<arrAssets.count; i++) {
        
        PhotoModel* model = [PhotoModel new];
        model.image = [ASSETHELPER getImageFromAsset:arrAssets[i] type:ASSET_PHOTO_SCREEN_SIZE];
        
        [self.recommendModel.arrPostImagesList addObject:model];
    }
}


@end
