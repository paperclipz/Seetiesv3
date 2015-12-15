//
//  SeetiesShopViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"

@interface SeetiesShopViewController : CommonViewController
-(void)initDataWithSeetiesID:(NSString*)seetiesID;
-(void)initDataPlaceID:(NSString*)placeID postID:(NSString*)postID;
-(void)initDataWithSeetiesID:(NSString*)seetiesID Latitude:(float)lat Longitude:(float)lng;
-(void)initDataPlaceID:(NSString*)placeID postID:(NSString*)postID Latitude:(float)lat Longitude:(float)lng;
@end
