//
//  MapManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/23/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapManager : NSObject
+ (id)Instance;
-(void)showMapOptions:(UIView*)view LocationLat:(NSString*)lat LocationLong:(NSString*)longt;

@end
