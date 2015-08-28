//
//  RecommendationViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/11/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "RecommendationViewController.h"
@interface RecommendationViewController ()

@end

@implementation RecommendationViewController
- (IBAction)btnEditPhotoClicked:(id)sender {
    
    [self presentViewController:self.editPostViewController animated:YES completion:nil];
    [self.editPostViewController initData];
    
}
- (IBAction)btnPickImageClicked:(id)sender {
    
    [self presentViewController:self.doImagePickerController animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    //[self btnPickImageClicked:nil];
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
                   
    }
   
    //Remark* check image has tag location, if not get device location. if device dont hace location route to search page with no suggestion
}

-(void)showSearchView:(CLLocation*)location
{
    
    //[self dismissViewControllerAnimated:YES completion:^{
        [self.navDoImagePickerController pushViewController:self.stSearchViewController animated:YES];
        [self.stSearchViewController initWithLocation:location];

  //  }];

    
}



#pragma mark - Declaration
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
            
            [wealSelf.navDoImagePickerController pushViewController:wealSelf.addNewPlaceViewController animated:YES];
            
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

-(EditPhotoViewController*)editPhotoViewController
{
    if(!_editPhotoViewController)
    {
        _editPhotoViewController = [EditPhotoViewController new];
        
    }
    return _editPhotoViewController;
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

-(UINavigationController*)navDoImagePickerController
{
    if(!_navDoImagePickerController)
    {
        _navDoImagePickerController = [[UINavigationController alloc]initWithRootViewController:self.doImagePickerController];
        [_navDoImagePickerController setNavigationBarHidden:YES];
    }
    
    return _navDoImagePickerController;
}
-(AddNewPlaceViewController*)addNewPlaceViewController
{
    if(!_addNewPlaceViewController)
    {
        _addNewPlaceViewController = [AddNewPlaceViewController new];
    }
    
    return _addNewPlaceViewController;
    
}
//[self.navigationController pushViewController:self.addNewPlaceViewController animated:YES];

@end
