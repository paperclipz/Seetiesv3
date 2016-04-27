//
//  SearchManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "SearchManager.h"
typedef void (^HomeLocationBlock)(HomeLocationModel* model);

@interface SearchManager()
@property(nonatomic,strong)CLLocationManager* manager;
@property(nonatomic,strong)DataManager* dataManager;
@property(nonatomic,strong)ConnectionManager* connManager;
@property(nonatomic,copy)SearchManagerFailBlock searchManagerFailBlock;

@property(nonatomic,copy)LocationBlock didFinishSearchGPSLocationBlock;

@end
@implementation SearchManager


+(BOOL)isDeviceGPSTurnedOn
{
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {

        return YES;
    } else {
        return NO;
    }
}

-(CLLocationManager*)manager
{
    if (!_manager) {
        _manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionAlways];
        _manager.delegate = self;
        [_manager requestWhenInUseAuthorization];
    }
    return _manager;
}
-(void)startGetWifiLocation
{
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetGeoIP param:nil appendString:nil completeHandler:^(id object) {
       
        self.wifiLocation = [self convertToCLLocation:object[@"latitude"] longt:object[@"longitude"]];
        
    } errorBlock:^(id object) {
    
    }];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
   
    self.GPSLocation = locations[0];
    
    if (self.didFinishSearchGPSLocationBlock) {
        self.didFinishSearchGPSLocationBlock(self.GPSLocation);
        self.didFinishSearchGPSLocationBlock = nil;
    }
    [self.manager stopUpdatingLocation];
}
-(void)startSearchGPSLocation:(LocationBlock)CompletionBlock
{
    [self.manager startUpdatingLocation];
    
    self.didFinishSearchGPSLocationBlock = CompletionBlock;
}

-(void)startSearchGPSLocation
{
    [self.manager startUpdatingLocation];
}

#pragma mark - CLLocation Delegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking granting location access!");
            [self.manager startUpdatingLocation]; // this will access location automatically if user granted access manually. and will not show apple's request alert twice. (Tested)
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User denied location access request!!");
            NSLog(@"To re-enable, please go to Settings and turn on Location Service for this app.");
            [self.manager stopUpdatingLocation];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            // clear text
            NSLog(@"Got Location");
            [self.manager startUpdatingLocation]; //Will update location immediately
        } break;
            
        default:
            break;
    }
}
-(CLLocation*)getAppLocation
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
   
        [self getCoordinateFromWifi:^(CLLocation *currentLocation) {
            
            [Foursquare2 venueExploreRecommendedNearByLatitude:@(currentLocation.coordinate.latitude) longitude:@(currentLocation.coordinate.longitude) near:nil accuracyLL:nil altitude:nil accuracyAlt:nil query:input limit:nil offset:nil radius:@(10000) section:nil novelty:nil sortByDistance:nil openNow:nil venuePhotos:nil price:nil callback:^(BOOL success, id result){
                
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


/*get search location from google is a list from google in brief only. later on will need to click on the list and hit google details*/
-(void)getSearchLocationFromGoogle:(CLLocation*)tempCurrentLocation Country:(NSString*)country input:(NSString*)textInput completionBlock:(IDBlock)completionBlock
{
    
    if (!country) {
        country = @"";
    }
    NSDictionary* param = @{@"input":textInput?textInput:@"",
                            @"radius":@"10000",
                            @"key":GOOGLE_API_KEY,
                            @"location":[NSString stringWithFormat:@"%f,%f",tempCurrentLocation.coordinate.latitude,tempCurrentLocation.coordinate.longitude],
                            @"components" : [NSString stringWithFormat:@"country:%@",country],
                            };
    
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

-(void)getSearchLocationFromGoogle:(CLLocation*)tempCurrentLocation input:(NSString*)textInput completionBlock:(IDBlock)completionBlock
{
    
   // NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?location=%f,%f&input=%@&radius=50000&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM&type=address",tempCurrentLocation.coordinate.latitude,tempCurrentLocation.coordinate.longitude,textInput];

    //SLog(@"%@",FullString);
    
   // [LoadingManager showWithTitle:@"GOOGLE"];
    NSDictionary* param = @{@"input":textInput?textInput:@"",@"radius":@"10000",@"key":GOOGLE_API_KEY,@"location":[NSString stringWithFormat:@"%f,%f",tempCurrentLocation.coordinate.latitude,tempCurrentLocation.coordinate.longitude]};

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

-(void)getGoogleGeoCode:(CLLocation*)tempCurrentLocation Country:(NSString*)country completionBlock:(IDBlock)completionBlock
{
    
    NSString* googleAPI = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?sensor=true&latlng=%.4f,%.4f&key=%@&components=country:%@",tempCurrentLocation.coordinate.latitude,tempCurrentLocation.coordinate.longitude,GOOGLE_API_KEY,country];
   
    
    [[ConnectionManager Instance]requestServerWithPost:YES customURL:googleAPI requestType:ServerRequestTypeGoogleSearch param:nil completeHandler:^(id object) {
        if(completionBlock)
        {
            completionBlock(object);
        }
        
        [LoadingManager hide];
        
    } errorBlock:^(id object) {
        [LoadingManager hide];
        
    } ];
}

-(void)getGoogleGeoCode:(CLLocation*)tempCurrentLocation completionBlock:(IDBlock)completionBlock
{

   // NSString* googleAPI = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?sensor=true&latlng=%@,%@&key=%@",,@"101.7000",GOOGLE_API_KEY];
    
      NSString* googleAPI = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?sensor=true&latlng=%.4f,%.4f&key=%@",tempCurrentLocation.coordinate.latitude,tempCurrentLocation.coordinate.longitude,GOOGLE_API_KEY];
    
 //   NSDictionary* dict = @{@"latlng" :@"40.714,-73.9614",
  //                         @"key" : GOOGLE_API_KEY};
    
    
    [[ConnectionManager Instance]requestServerWithPost:YES customURL:googleAPI requestType:ServerRequestTypeGoogleSearch param:nil completeHandler:^(id object) {
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
