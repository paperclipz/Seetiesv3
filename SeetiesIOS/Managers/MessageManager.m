//
//  MessageManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/27/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "MessageManager.h"
#import "AppDelegate.h"
#import "UIWindow+Extra.h"
#import "CT3_LoadingViewController.h"

@interface CT3_LoadingViewController ()

@property(nonatomic)CT3_LoadingViewController* loadingViewController;
@end
@implementation MessageManager

+(void)showMessage:(NSString*)title SubTitle:(NSString*)subtitle Type:(TSMessageNotificationType)type
{

    UIViewController* controller = [UIWindow topMostController];
    
  //  CT3_LoadingViewController* loading = [CT3_LoadingViewController new];
  //  [[[[UIApplication sharedApplication] delegate] window] addSubview:loading.view];
    [TSMessage showNotificationInViewController:controller title:title subtitle:subtitle type:type];

}

+(void)showMessageWithCallBack:(NSString*)title SubTitle:(NSString*)subtitle Type:(TSMessageNotificationType)type ButtonOnClick:(void (^)())callBack
{
    UIViewController* controller = [UIWindow topMostController];
    [TSMessage showNotificationInViewController:controller title:title subtitle:subtitle image:nil type:type duration:1.0 callback:^{
        
        if (callBack) {
            callBack();
        }
        
    } buttonTitle:nil buttonCallback:^{
     
        
    } atPosition:TSMessageNotificationPositionTop canBeDismissedByUser:YES];
}

+(void)showMessageInPopOut:(NSString*)title subtitle:(NSString*)subtitle{
    [UIAlertView showWithTitle:title message:subtitle cancelButtonTitle:LocalisedString(@"Okay!") otherButtonTitles:nil tapBlock:nil];
}

@end
