//
//  SearchManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CLLocationManager+blocks.h"
#import "FSVenue.h"
#import "FSConverter.h"

typedef void(^SearchManagerSuccessBlock)(CLLocation *currentLocation);
typedef void(^SearchManagerFailBlock)(NSString *status);

@interface SearchManager : NSObject<CLLocationManagerDelegate>
+ (id)Instance;
@property(nonatomic)CLLocation* location;
@property(nonatomic)CLLocation* wifiLocation;
@property(nonatomic)CLLocation* GPSLocation;//new feature

-(CLLocation*)getAppLocation;
-(void)startSearchGPSLocation;
-(void)startGetWifiLocation;

-(void)getSuggestedLocationFromFoursquare:(CLLocation*)tempCurrentLocation input:(NSString*)input completionBlock:(IDBlock)completionBlock;

-(void)getCoordinate:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)errorBlock;
-(void)getCoordinateFromWifi:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)errorBlock;

//-(void)getSuggestedLocationFromGoogle:(CLLocation*)tempCurrentLocation completionBlock:(IDBlock)completionBlock;
-(void)getSearchLocationFromGoogle:(CLLocation*)tempCurrentLocation input:(NSString*)textInput completionBlock:(IDBlock)completionBlock;
-(void)getCoordinateFromGPSThenWifi:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)errorBlock;

@end
