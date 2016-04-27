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
#import "HomeLocationModel.h"

typedef void (^LocationBlock)(CLLocation* location);
typedef void (^HomeLocationBlock)(HomeLocationModel* model);

typedef void(^SearchManagerSuccessBlock)(CLLocation *currentLocation);
typedef void(^SearchManagerFailBlock)(NSString *status);

@interface SearchManager : NSObject<CLLocationManagerDelegate>
+ (id)Instance;
@property(nonatomic,strong)CLLocation* location;
@property(nonatomic,strong)CLLocation* wifiLocation;
@property(nonatomic,strong)CLLocation* GPSLocation;//new feature

+(BOOL)isDeviceGPSTurnedOn;

-(CLLocation*)getAppLocation;
-(void)startSearchGPSLocation;
-(void)startGetWifiLocation;
-(void)startSearchGPSLocation:(LocationBlock)CompletionBlock;

-(void)getSuggestedLocationFromFoursquare:(CLLocation*)tempCurrentLocation input:(NSString*)input completionBlock:(IDBlock)completionBlock;

-(void)getCoordinate:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)errorBlock;
-(void)getCoordinateFromWifi:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)errorBlock;

//-(void)getSuggestedLocationFromGoogle:(CLLocation*)tempCurrentLocation completionBlock:(IDBlock)completionBlock;
-(void)getSearchLocationFromGoogle:(CLLocation*)tempCurrentLocation input:(NSString*)textInput completionBlock:(IDBlock)completionBlock;
-(void)getSearchLocationFromGoogle:(CLLocation*)tempCurrentLocation Country:(NSString*)country input:(NSString*)textInput completionBlock:(IDBlock)completionBlock;

-(void)getCoordinateFromGPSThenWifi:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)errorBlock;
-(void)getGoogleGeoCode:(CLLocation*)tempCurrentLocation completionBlock:(IDBlock)completionBlock;
-(void)getGoogleGeoCode:(CLLocation*)tempCurrentLocation Country:(NSString*)country completionBlock:(IDBlock)completionBlock;//for geocode with country filter

@end
