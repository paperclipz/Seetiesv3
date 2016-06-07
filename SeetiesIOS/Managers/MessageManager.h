//
//  MessageManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/27/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STAlertController.h"
#import "AMPopTip.h"

@interface MessageManager : NSObject

//replace
//+(void)showMessage:(NSString*)title SubTitle:(NSString*)subtitle Type:(TSMessageNotificationType)type;
//replace to
+(void)showMessage:(NSString*)message Type:(STAlertType)type;
+(void)showMessage:(NSString*)message Type:(STAlertType)type displayType:(STAlertDisplayType)displayType;
+(void)popoverErrorMessage:(NSString*)message target:(id)target popFrom:(id)popFrom;
+(void)popoverErrorMessage:(NSString*)message target:(id)target popFrom:(id)popFrom direction:(AMPopTipDirection)direction ;
+(void)popoverErrorMessage:(NSString*)message target:(id)target popFrom:(id)popFrom duration:(NSTimeInterval)duration ;
+(void)popoverErrorMessage:(NSString*)message target:(id)target popFrom:(id)popFrom direction:(AMPopTipDirection)direction duration:(NSTimeInterval)duration;
// no used
//disable by zack
//+(void)showMessageWithCallBack:(NSString*)title SubTitle:(NSString*)subtitle Type:(TSMessageNotificationType)type ButtonOnClick:(void (^)())callBack;
+(void)showMessageInPopOut:(NSString*)title subtitle:(NSString*)subtitle;

+(void)showToastMessage:(NSString*)title InView:(UIView*)view;

@end
