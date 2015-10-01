//
//  LoadingManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/18/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "LoadingManager.h"

@implementation LoadingManager

+ (id)Instance {
    
    static LoadingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        [self setupBaseKVNProgressUI];
    }
    return self;
}
- (void)setupBaseKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor darkGrayColor];
    [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.9f alpha:0.9f];
    [KVNProgress appearance].backgroundTintColor = [UIColor whiteColor];
    [KVNProgress appearance].successColor = [UIColor darkGrayColor];
    [KVNProgress appearance].errorColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleSize = 50.0f;
    [KVNProgress appearance].lineWidth = 1.0f;
}

+ (void)show
{
    [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: @"Loading...",
                                      KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
                                      KVNProgressViewParameterFullScreen: @([[LoadingManager Instance] isFullScreen])}];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [KVNProgress dismiss];
//    });
}

+ (void)showWithTitle:(NSString*)title
{
    [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: [NSString stringWithFormat:@"Searching %@",title],
                                      KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
                                      KVNProgressViewParameterFullScreen: @([[LoadingManager Instance] isFullScreen])}];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [KVNProgress dismiss];
    //    });
}
- (void)showWithSolidBackground
{
    [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: @"Loading...",
                                      KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
                                      KVNProgressViewParameterFullScreen: @([self isFullScreen])}];
    
  
}

- (void)showWithStatus
{
    if ([self isFullScreen]) {
        [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: @"Loading...",
                                          KVNProgressViewParameterFullScreen: @(YES)}];
    } else {
        [KVNProgress showWithStatus:@"Loading..."];
    }
    
   
}
+(void)hide
{
    [KVNProgress dismiss];

}

@end
