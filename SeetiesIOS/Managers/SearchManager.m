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
@property(nonatomic,copy)SearchManagerFailBlock searchManagerFailBlock;


@end
@implementation SearchManager


-(void)startGetWifiLocation
{
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetGeoIP param:nil appendString:nil completeHandler:^(id object) {
       
        self.wifiLocation = [self convertToCLLocation:object[@"latitude"] longt:object[@"longitude"]];
        
    } errorBlock:^(id object) {
    
    }];

}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations {
   
    self.location = locations[0];
    [self.manager stopUpdatingLocation];
}

-(void)startSearchGPSLocation
{
    self.manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionAlways];
    self.manager.delegate = self;
    [self.manager requestWhenInUseAuthorization];
    [self.manager startUpdatingLocation];

}

-(CLLocation*)getLocation
{
    if (self.GPSLocation) {
        return self.GPSLocation;
    }
    else if(self.location)
    {
        return self.location;
    }
    else{
        return self.wifiLocation;

    }
}

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

-(void)getCoordinate:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)errorBlock
{
    
    if (self.location) {
        successBlock(self.location);
        return;
    }
    if ([CLLocationManager isLocationUpdatesAvailable]) {
        
        self.manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionAlways];
        [self performSelector:@selector(stopLocationSearch) withObject:@"TimedOut" afterDelay:3];
        self.searchManagerFailBlock = errorBlock;
        [self.manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
            NSLog(@"Our new location from GPS: %@", location);
            
            if (error && !location) {
                SLog(@"error : %@",error.description);
                //[LoadingManager hide];
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
    else{
        
        if (errorBlock) {
            errorBlock(@"no new location from gps");
        }
        SLog(@"location not available");
    }
}

-(void)stopLocationSearch
{
    SLog(@"stopLocationSearch");
    [self.manager stopUpdatingLocation];
    [LoadingManager hide];
    
    if (self.searchManagerFailBlock) {
        self.searchManagerFailBlock(@"No GPS FROM DEVICE");
    }

}

-(void)getSuggestedLocationFromFoursquare:(CLLocation*)tempCurrentLocation input:(NSString*)input completionBlock:(IDBlock)completionBlock
{
   // [LoadingManager showWithTitle:[NSString stringWithFormat:@"%@ foursquare",LocalisedString(@"Searching...")]];

    SLog(@"long : %f  || lat: %f",tempCurrentLocation.coordinate.longitude,tempCurrentLocation.coordinate.latitude);

    if (tempCurrentLocation) {
        
        [Foursquare2 venueExploreRecommendedNearByLatitude:@(tempCurrentLocation.coordinate.latitude) longitude:@(tempCurrentLocation.coordinate.longitude) near:nil accuracyLL:nil altitude:nil accuracyAlt:nil query:input limit:nil offset:nil radius:@(10000) section:nil novelty:nil sortByDistance:nil openNow:nil venuePhotos:nil price:nil callback:^(BOOL success, id result){
            
            if(success)
            {
                [self.connManager storeServerData:result requestType:ServerRequestType4SquareSearch];
                
                if (completionBlock) {
                    completionBlock(result);
                }
            }
            else{
                
                SLog(@"NO Result FOUND");
            }
            SLog(@"fourSquare response : %@",result);
            
            [LoadingManager hide];
            
        }];

    }
    else{
   
        [self getCoordinateFromGPSThenWifi:^(CLLocation *currentLocation) {
        
        [Foursquare2 venueExploreRecommendedNearByLatitude:@(tempCurrentLocation.coordinate.latitude) longitude:@(tempCurrentLocation.coordinate.longitude) near:nil accuracyLL:nil altitude:nil accuracyAlt:nil query:input limit:nil offset:nil radius:@(10000) section:nil novelty:nil sortByDistance:nil openNow:nil venuePhotos:nil price:nil callback:^(BOOL success, id result){
            
            if(success)
            {
                [self.connManager storeServerData:result requestType:ServerRequestType4SquareSearch];
                
                if (completionBlock) {
                    completionBlock(result);
                }
                
            }
            else{
                
                SLog(@"NO Result FOUND");
            }
            SLog(@"fourSquare response : %@",result);
            //       [LoadingManager hide];
            [LoadingManager hide];

        }];
        
        
    } errorBlock:^(NSString *status) {
        [LoadingManager hide];

        SLog(@"ERROR");
    }];
    }
    
   
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

/*tempCurrentLocation is an optional field*/
-(void)getSearchLocationFromGoogle:(CLLocation*)tempCurrentLocation input:(NSString*)textInput completionBlock:(IDBlock)completionBlock
{
    
   // NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?location=%f,%f&input=%@&radius=50000&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM&type=address",tempCurrentLocation.coordinate.latitude,tempCurrentLocation.coordinate.longitude,textInput];

    //SLog(@"%@",FullString);
    
   // [LoadingManager showWithTitle:@"GOOGLE"];
    NSDictionary* param = @{@"input":textInput?textInput:@"",@"radius":@"5000",@"key":GOOGLE_API_KEY,@"type":@"address",@"location":[NSString stringWithFormat:@"%f,%f",tempCurrentLocation.coordinate.latitude,tempCurrentLocation.coordinate.longitude]};

    [[ConnectionManager Instance]requestServerWithPost:NO customURL:GOOGLE_PLACE_AUTOCOMPLETE_API requestType:ServerRequestTypeGoogleSearch param:param completeHandler:^(id object) {
        if(completionBlock)
        {
            completionBlock(object);
        }
        
        [LoadingManager hide];

    } errorBlock:^(id object) {
        [LoadingManager hide];

    } ];
}


-(void)getCoordinateFromWifi:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)errorBlock
{
    if(self.wifiLocation)
    {
        if (successBlock) {
            successBlock(self.wifiLocation);
        }
        
    }
    else
    {
        [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetGeoIP param:nil appendString:nil completeHandler:^(id object) {
            
            if (successBlock) {
                successBlock([self convertToCLLocation:object[@"latitude"] longt:object[@"longitude"]]);
            }
            self.wifiLocation = [self convertToCLLocation:object[@"latitude"] longt:object[@"longitude"]];
            
        } errorBlock:^(id object) {
            
            if (errorBlock) {
                errorBlock(nil);
            }
            
        }];
    }
   

}

-(void)getCoordinateFromGPSThenWifi:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)errorBlock
{
    [self getCoordinate:^(CLLocation *currentLocation) {
        if (currentLocation) {
            if (successBlock) {
                successBlock(currentLocation);
            }
        }
    } errorBlock:^(NSString *status) {
        
        SLog(@"NO GPS LOCATION ");

        [self getCoordinateFromWifi:^(CLLocation *currentLocation) {
            
            if (successBlock) {
                successBlock(currentLocation);
            }
        } errorBlock:^(NSString *status) {
            if (errorBlock) {
                errorBlock(status);
            }
            SLog(@"NO WIFI LOCATION ");
        }];

        
    }];

}

-(CLLocation*)convertToCLLocation:(NSString*)lat longt:(NSString*)lng
{
    return [[CLLocation alloc]initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
}
@end
