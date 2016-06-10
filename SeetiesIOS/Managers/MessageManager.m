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
#import "UIView+Toast.h"
#import "Utils.h"

@implementation MessageManager

//only use STAlertSuccess, STAlertError
+(void)showMessage:(NSString *)message Type:(STAlertType)type{
    [self showMessage:message Type:type displayType:STAlertDisplayTypeOverlayNavBar];
}

+(void)showMessage:(NSString*)message Type:(STAlertType)type displayType:(STAlertDisplayType)displayType{
    [STAlertController presentSTAlertType:type stAlertDisplayType:displayType message:message];
}

//popover
+(void)popoverErrorMessage:(NSString *)message target:(id)target popFrom:(UIView *)popFrom{
    [self popoverErrorMessage:message target:target popFrom:popFrom direction:AMPopTipDirectionUp duration:2.0f];
}

+(void)popoverErrorMessage:(NSString *)message target:(id)target popFrom:(UIView *)popFrom direction:(AMPopTipDirection)direction{
    [self popoverErrorMessage:message target:target popFrom:popFrom direction:direction duration:2.0f];
}

+(void)popoverErrorMessage:(NSString *)message target:(id)target popFrom:(UIView *)popFrom duration:(NSTimeInterval)duration{
    [self popoverErrorMessage:message target:target popFrom:popFrom direction:AMPopTipDirectionUp duration:duration];
}

+(void)popoverErrorMessage:(NSString *)message target:(id)target popFrom:(UIView *)popFrom direction:(AMPopTipDirection)direction duration:(NSTimeInterval)duration{
    AMPopTip *popTip = [AMPopTip popTip];
    popTip.shouldDismissOnTap = YES;
    popTip.popoverColor = [UIColor colorWithRed:247.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1.0];
    
    [popTip showText:message direction:direction maxWidth:[popFrom frame].size.width inView:[target view] fromFrame:[self getViewRect:popFrom target:target] duration:duration];
}

//get view actual location
+(CGRect)getViewRect:(UIView *)view target:(id)target{
    CGPoint viewPoint = [view convertPoint:view.bounds.origin toView:[target view]];
    return CGRectMake(viewPoint.x, viewPoint.y, view.frame.size.width, view.frame.size.height);
    
}

//+(void)showMessage:(NSString*)title SubTitle:(NSString*)subtitle Type:(TSMessageNotificationType)type
//{
//
//    UIViewController* controller = [UIWindow topMostController];
//    
////    if (controller.navigationController) {
////        controller = controller.navigationController;
////    }
//    
//    [TSMessage showNotificationInViewController:controller title:title subtitle:subtitle image:nil type:type duration:TSMessageNotificationDurationAutomatic callback:nil buttonTitle:nil buttonCallback:nil atPosition:[controller.parentViewController isKindOfClass:[UINavigationController class]] ?  TSMessageNotificationPositionNavBarOverlay : TSMessageNotificationPositionTop canBeDismissedByUser:YES];
//   
//
//}

// no used
//disable by zack
//+(void)showMessageWithCallBack:(NSString*)title SubTitle:(NSString*)subtitle Type:(TSMessageNotificationType)type ButtonOnClick:(void (^)())callBack
//{
//    UIViewController* controller = [UIWindow topMostController];
//    [TSMessage showNotificationInViewController:controller title:title subtitle:subtitle image:nil type:type duration:1.0 callback:^{
//
//        if (callBack) {
//            callBack();
//        }
//
//    } buttonTitle:nil buttonCallback:^{
//
//
//    } atPosition:TSMessageNotificationPositionTop canBeDismissedByUser:YES];
//}

+(void)showMessageInPopOut:(NSString*)title subtitle:(NSString*)subtitle{
    [UIAlertView showWithTitle:title message:subtitle cancelButtonTitle:LocalisedString(@"Okay!") otherButtonTitles:nil tapBlock:nil];
}


+(void)showToastMessage:(NSString*)title InView:(UIView*)view
{
    
    if ([Utils isStringNull:title]) {
        return;
    }
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    
    // this is just one of many style options
    style.messageColor = [UIColor whiteColor];
    
    style.messageFont = [UIFont fontWithName:CustomFontNameBold size:10];
    style.cornerRadius = 12;
    
    // present the toast with the new style
    [view makeToast:LocalisedString(title)
                duration:3.0
                position:CSToastPositionBottom
                   style:style];

}
@end
