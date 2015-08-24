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
    
    [self presentViewController:self.self.editPostViewController animated:YES completion:nil];
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
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self pushViewController:self.stSearchViewController animated:YES];
        [self.stSearchViewController initWithLocation:location];

    }];

    
}


//
//- (NSString *)getIPAddress {
//    
//    NSString *address = @"error";
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    int success = 0;
//    // retrieve the current interfaces - returns 0 on success
//    success = getifaddrs(&interfaces);
//    if (success == 0) {
//        // Loop through linked list of interfaces
//        temp_addr = interfaces;
//        while(temp_addr != NULL) {
//            if(temp_addr->ifa_addr->sa_family == AF_INET) {
//                // Check if interface is en0 which is the wifi connection on the iPhone
//                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
//                    // Get NSString from C String
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                    
//                }
//                
//            }
//            
//            temp_addr = temp_addr->ifa_next;
//        }
//    }
//    // Free memory
//    freeifaddrs(interfaces);
//    return address;
//    
//}

#pragma mark - Declaration
-(STSearchViewController*)stSearchViewController{

    if(!_stSearchViewController)
    {
        _stSearchViewController = [STSearchViewController new];
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
@end
