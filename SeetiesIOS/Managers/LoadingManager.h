//
//  LoadingManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/18/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVNProgress.h"

@interface LoadingManager : NSObject
+ (id)Instance;
@property(nonatomic,assign)BOOL isFullScreen;
+ (void)show;
+(void)hide;
+ (void)showWithTitle:(NSString*)title;

@end
