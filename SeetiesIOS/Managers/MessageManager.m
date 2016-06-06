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
#import "AMPopTip.h"

@implementation MessageManager

+(void)showMessage:(NSString *)message Type:(STAlertType)type{
    [self showMessage:message Type:type displayType:STAlertDisplayTypeOverlayNavBar];
}

+(void)showMessage:(NSString*)message Type:(STAlertType)type displayType:(STAlertDisplayType)displayType{
    [STAlertController presentSTAlertType:type stAlertDisplayType:displayType message:message];
}

+(void)popoverErrorMessage:(NSString *)message target:(id)target popFrom:(id)popFrom{
//    [STAlertController popoverErroMessage:message target:target popFrom:popFrom];
    
    AMPopTip *popTip = [AMPopTip popTip];
    popTip.shouldDismissOnTap = YES;
    popTip.popoverColor = [UIColor colorWithRed:226.0/255.0 green:60.0/255.0 blue:78.0/255.0 alpha:1.0];
    
    [popTip showText:message direction:AMPopTipDirectionUp maxWidth:[popFrom frame].size.width inView:[target view] fromFrame:[self getViewRect:popFrom target:target] duration:2.0f];
}

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
