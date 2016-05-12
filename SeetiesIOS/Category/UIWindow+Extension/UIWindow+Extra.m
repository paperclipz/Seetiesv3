//
//  UIWindow+Extra.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/26/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "UIWindow+Extra.h"
#import "UIViewController+Extension.h"
#import "NewLandingViewController.h"

@implementation UIWindow(Extra)

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    return [topController topVisibleViewController];
}

@end
