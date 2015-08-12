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

- (void)viewDidLoad {
    [super viewDidLoad];

    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nMaxCount = 10;     // larger than 1
    cont.nColumnCount = 3;  // 2, 3, or 4
    
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE; // get UIImage object array : common case
    // if you want to get lots photos, you had better use DO_PICKER_RESULT_ASSET.
    cont.nResultType = 1;
    [self presentViewController:cont animated:YES completion:nil];
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
//    SLog(@"didSelectPhotosFromDoImagePickerController");
//    ALAsset* asset = aSelected[0];
//    CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
//    SLog(@"lat :%@",location.coordinate.latitude);
//    
//    
//    NSDictionary *metadata = asset.defaultRepresentation.metadata;
//    NSLog(@"Image Meta Data: %@",metadata);
//    
//    NSDictionary *gpsdata = [metadata objectForKey:@"{GPS}"];
    
//    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(3.13900303, 101.6868550101)
//                                                  service:kLMGeocoderGoogleService
//                                        completionHandler:^(NSArray *results, NSError *error) {
//                                            if (results.count && !error) {
//                                                LMAddress *address = [results firstObject];
//                                                NSLog(@"Address: %@", address.formattedAddress);
//                                            }
//                                        }];
//    
//    [Foursquare2 venueExploreRecommendedNearByLatitude:@(dlatitude) longitude:@(dlongitude) near:nil accuracyLL:nil altitude:nil accuracyAlt:nil query:nil limit:nil offset:nil radius:@(1000) section:nil novelty:nil sortByDistance:nil openNow:nil venuePhotos:nil price:nil callback:^(BOOL success, id result){
//        
//    }];
}


- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
@end
