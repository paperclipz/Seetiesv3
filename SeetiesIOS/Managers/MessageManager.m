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

@implementation MessageManager

+(void)showMessage:(NSString*)title SubTitle:(NSString*)subtitle Type:(TSMessageNotificationType)type
{

    UIViewController* controller = [UIWindow topMostController];
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
@end
