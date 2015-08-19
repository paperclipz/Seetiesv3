//
//  SearchManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "SearchManager.h"

@interface SearchManager()
@property(nonatomic,strong)CLLocationManager* manager;

@end
@implementation SearchManager


+ (id)Instance {
    
    static SearchManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

-(void)getCoordinate:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)error
{
    
    if (self.location) {
        successBlock(self.location);
        return;
    }
    [LoadingManager show];
    
    
    self.manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionAlways];
    [self.manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
        NSLog(@"Our new location: %@", location);
        
        if(location)
        {
            *stopUpdating = YES;
            [LoadingManager hide];
            successBlock(location);

        }
    }];
//    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
//    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
//                                       timeout:10.0
//                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
//                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
//                                             if (status == INTULocationStatusSuccess) {
//                                                 // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
//                                                 // currentLocation contains the device's current location.
//                                                 successBlock(currentLocation);
//                                                 [LoadingManager hide];
//
//                                             }
//                                             else if (status == INTULocationStatusTimedOut) {
//                                                 error(@"SESSION TIMEOUT");
//                                                 [LoadingManager hide];
//
//                                             }
//                                             else {
//                                                 error(@"SESSION FAIL");
//                                                 [LoadingManager hide];
//
//                                                 // An error occurred, more info is available by looking at the specific status returned.
//                                             }
//                                         }];
    
}

-(void)getSuggestedLocationFromFoursquare:(CLLocation*)tempCurrentLocation completionBlock:(IDBlock)completionBlock
{
    [Foursquare2 venueExploreRecommendedNearByLatitude:@(tempCurrentLocation.coordinate.latitude) longitude:@(tempCurrentLocation.coordinate.longitude) near:nil accuracyLL:nil altitude:nil accuracyAlt:nil query:nil limit:nil offset:nil radius:@(1000) section:nil novelty:nil sortByDistance:nil openNow:nil venuePhotos:nil price:nil callback:^(BOOL success, id result){
        
        if (completionBlock) {
            completionBlock(result);
        }
        
    }];
    
    
}

-(NSString*)coordinateToString:(CLLocation*)location
{
    return [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
}

-(void)getSuggestedLocationFromGoogle:(CLLocation*)tempCurrentLocation completionBlock:(IDBlock)completionBlock
{
    
  //  NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?location=%@,%@&input=%@&radius=50000&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM&type=address",GetLatPoint,GetLongPoint,replaced];

    NSDictionary* param = @{@"location":[self coordinateToString:self.location],@"input":@"sea pa",@"radius":@"5000",@"key":GOOGLE_API_KEY,@"type":@"address"};
   
   
    [[ConnectionManager Instance] requestServerwithAppendString:GOOGLE_PLACE_AUTOCOMPLETE_API param:param completionHandler:^(id object) {
        SLog(@"google place response : %@",object);
    } errorHandler:^(NSError *error) {
        SLog(@"error from gogole response");
    }];
}
@end
