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
@property(nonatomic,strong)DataManager* dataManager;
@property(nonatomic,strong)ConnectionManager* connManager;

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
        
        self.dataManager = [DataManager Instance];
        self.connManager = [ConnectionManager Instance];
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
        
        if (error && !location) {
            SLog(@"error : %@",error.description);
            [LoadingManager hide];

        }
        else
        {
            self.location = location;
            *stopUpdating = YES;
            [LoadingManager hide];
            successBlock(location);

        }
    }];
    
}

-(void)getSuggestedLocationFromFoursquare:(CLLocation*)tempCurrentLocation input:(NSString*)input completionBlock:(IDBlock)completionBlock
{
    
    [Foursquare2 venueExploreRecommendedNearByLatitude:@(tempCurrentLocation.coordinate.latitude) longitude:@(tempCurrentLocation.coordinate.longitude) near:nil accuracyLL:nil altitude:nil accuracyAlt:nil query:nil limit:nil offset:nil radius:@(1000) section:nil novelty:nil sortByDistance:nil openNow:nil venuePhotos:nil price:nil callback:^(BOOL success, id result){
        
    
        [self.connManager storeServerData:result requestType:ServerRequestType4SquareSearch];

        if (completionBlock) {
            completionBlock(result);
        }
    }];
 //   tempCurrentLocation.coordinate.latitude = [NSNumber numberWithDouble:3.1333] ;
 //   tempCurrentLocation.coordinate.longitude = [NSNumber numberWithFloat:101.7000];
    
//    [Foursquare2 venueSearchNearByLatitude:@(tempCurrentLocation.coordinate.latitude)
//                                 longitude:@(tempCurrentLocation.coordinate.longitude)
//                                     query:input
//                                     limit:nil
//                                    intent:intentCheckin
//                                    radius:@(5000)
//                                categoryId:nil
//                                  callback:^(BOOL success, id result){
//                                      if (success) {
//                                          
//                                          [self.connManager storeServerData:result requestType:ServerRequestType4SquareSearch];
//
//                                          if (completionBlock) {
//                                              
//                                              completionBlock(result);
//                                              
//                                          }
//
////                                          NSDictionary *dic = result;
////                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
////                                          NSLog(@"venues is %@",venues);
////                                          FSConverter *converter = [[FSConverter alloc]init];
////                                          self.nearbyVenues = [converter convertToObjects:venues];
////                                          [tblview reloadData];
////                                          // [self proccessAnnotations];
////                                          [ShowNearByActivity stopAnimating];
////                                          GetLocationArray = nil;
////                                          GetreferralIdArray = nil;
////                                          AddressArray = nil;
////                                          CityArray = nil;
////                                          CountryArray = nil;
////                                          latArray = nil;
////                                          lngArray = nil;
////                                          StateArray = nil;
////                                          formattedAddressArray = nil;
////                                          postalCodeArray = nil;
////                                          GetLocationArray = [[NSMutableArray alloc] initWithCapacity:[venues count]];
////                                          GetreferralIdArray = [[NSMutableArray alloc] initWithCapacity:[venues count]];
////                                          //                                          NSDictionary *Alldata = [dic valueForKey:@"categories"];
////                                          //                                          NSLog(@"Alldata is %@",Alldata);
////                                          //                                          NSDictionary *Getlocationdata = [venues valueForKey:@"location"];
////                                          //                                          NSLog(@"Getlocationdata is %@",Getlocationdata);
////
//                                      }
//                                      
//                                      }];
}

-(NSString*)coordinateToString:(CLLocation*)location
{
    return [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
}

////This is not working due to have to search for string location from coordinate first
//-(void)getSuggestedLocationFromGoogle:(CLLocation*)tempCurrentLocation completionBlock:(IDBlock)completionBlock
//{
//
//    //Search without coordinate for nearby
//  //  NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?location=%@,%@&input=%@&radius=50000&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM&type=address",GetLatPoint,GetLongPoint,replaced];
//
//    NSDictionary* param = @{@"radius":@"5000",@"key":GOOGLE_API_KEY,@"type":@"address"};
//   
//   
//    [[ConnectionManager Instance] requestServerwithAppendString:GOOGLE_PLACE_AUTOCOMPLETE_API param:param completionHandler:^(id object) {
//        
//        [self.connManager storeServerData:object requestType:ServerRequestTypeGoogleSearch];
//
//        if(completionBlock)
//        {
//            completionBlock(object);
//        }
//    
//    } errorHandler:^(NSError *error) {
//    }];
//}


-(void)getSearchLocationFromGoogle:(CLLocation*)tempCurrentLocation input:(NSString*)textInput completionBlock:(IDBlock)completionBlock
{
    
    NSDictionary* param = @{@"input":textInput,@"radius":@"5000",@"key":GOOGLE_API_KEY,@"type":@"address"};
    
    [[ConnectionManager Instance] requestServerwithAppendString:GOOGLE_PLACE_AUTOCOMPLETE_API param:param completionHandler:^(id object) {

        [self.connManager storeServerData:object requestType:ServerRequestTypeGoogleSearch];

        if(completionBlock)
        {
            completionBlock(object);
        }
    } errorHandler:^(NSError *error) {
    }];
}



@end
