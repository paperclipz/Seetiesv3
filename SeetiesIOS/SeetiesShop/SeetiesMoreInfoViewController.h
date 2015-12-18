//
//  SeetiesMoreInfoViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "MapViewController.h"

@interface SeetiesMoreInfoViewController : CommonViewController
@property(nonatomic,strong)SeShopDetailModel* seShopModel;

@property(nonatomic,strong)MapViewController* mapViewController;
-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID;
@end
