//
//  UploadManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/5/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "UploadManager.h"

@interface UploadManager()

@property(nonatomic,assign)CGPoint center;

@end

@implementation UploadManager


+ (id)Instance {
    
    static UploadManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}


-(FloatingIndicatorView*)floatView
{
    if (!_floatView) {
        _floatView = [FloatingIndicatorView initializeCustomView];
        
        self.center = [[[UIApplication sharedApplication] keyWindow] center];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_floatView];
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:_floatView];
        
        CGRect frame = [Utils getDeviceScreenSize];
        
        _floatView.frame = CGRectMake(0, 0, frame.size.width, _floatView.frame.size.height);
    }
    
    return _floatView;
}
@end
