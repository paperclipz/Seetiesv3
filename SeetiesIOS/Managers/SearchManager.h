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
typedef void(^SearchManagerSuccessBlock)(CLLocation *currentLocation);
typedef void(^SearchManagerFailBlock)(NSString *status);

@interface SearchManager : NSObject<CLLocationManagerDelegate>
+ (id)Instance;
@property(strong,nonatomic)CLLocation* location;


-(void)getSuggestedLocationFromFoursquare:(CLLocation*)tempCurrentLocation completionBlock:(IDBlock)completionBlock;

-(void)getCoordinate:(SearchManagerSuccessBlock)successBlock errorBlock:(SearchManagerFailBlock)error;
-(void)getSuggestedLocationFromGoogle:(CLLocation*)tempCurrentLocation completionBlock:(IDBlock)completionBlock;
-(void)getSearchLocationFromGoogle:(CLLocation*)tempCurrentLocation input:(NSString*)textInput completionBlock:(IDBlock)completionBlock;

@end
