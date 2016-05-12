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
