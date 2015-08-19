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
            self.location = location;
            *stopUpdating = YES;
            [LoadingManager hide];
            successBlock(location);

        }
    }];
    
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

//This is not working due to have to search for string location from coordinate first
-(void)getSuggestedLocationFromGoogle:(CLLocation*)tempCurrentLocation completionBlock:(IDBlock)completionBlock
{

    //Search without coordinate for nearby
  //  NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?location=%@,%@&input=%@&radius=50000&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM&type=address",GetLatPoint,GetLongPoint,replaced];

    NSDictionary* param = @{@"radius":@"5000",@"key":GOOGLE_API_KEY,@"type":@"address"};
   
   
    [[ConnectionManager Instance] requestServerwithAppendString:GOOGLE_PLACE_AUTOCOMPLETE_API param:param completionHandler:^(id object) {
        if(completionBlock)
        {
            completionBlock(object);
        }
    
    } errorHandler:^(NSError *error) {
    }];
}


-(void)getSearchLocationFromGoogle:(CLLocation*)tempCurrentLocation input:(NSString*)textInput completionBlock:(IDBlock)completionBlock
{
    
    NSDictionary* param = @{@"input":textInput,@"radius":@"5000",@"key":GOOGLE_API_KEY,@"type":@"address"};
    
    
    [[ConnectionManager Instance] requestServerwithAppendString:GOOGLE_PLACE_AUTOCOMPLETE_API param:param completionHandler:^(id object) {

        if(completionBlock)
        {
            completionBlock(object);
        }
    } errorHandler:^(NSError *error) {
    }];
}


@end
