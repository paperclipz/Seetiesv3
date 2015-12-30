//
//  PhotoListViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/3/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"

@interface PhotoListViewController : CommonViewController
-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID;

@end
