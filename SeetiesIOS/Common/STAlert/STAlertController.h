//
//  STAlertController.h
//  TEST
//
//  Created by ZackTvZ on 6/2/16.
//  Copyright © 2016 ZackTvZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class STAlertTypeViewController;

typedef NS_ENUM(NSInteger, STAlertType) {
    STAlertSuccess,
    STAlertError,
};
typedef NS_ENUM(NSInteger, STAlertDisplayType) {
    
    STAlertDisplayTypeTop = 0,
    STAlertDisplayTypeOverlayNavBar = 1,
    STAlertDisplayTypeBottom =2,
    STAlertDisplayTypeOverlayTabBar =3
};

typedef void (^TapClose)();


@interface STAlertController : NSObject

+ (STAlertController *)instance;

/////
+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message;
+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message tapClose:(TapClose)tapClose;
+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message tapClose:(TapClose)tapClose duration:(NSTimeInterval)duration;
+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message tapClose:(TapClose)tapClose duration:(NSTimeInterval)duration showDuration:(NSTimeInterval)showDuration;

/////
+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message onlyCurrentViewShow:(BOOL)onlyCurrentViewShow;
+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message onlyCurrentViewShow:(BOOL)onlyCurrentViewShow tapClose:(TapClose)tapClose;
+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message onlyCurrentViewShow:(BOOL)onlyCurrentViewShow tapClose:(TapClose)tapClose duration:(NSTimeInterval)duration;


+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message onlyCurrentViewShow:(BOOL)onlyCurrentViewShow tapClose:(TapClose)tapClose duration:(NSTimeInterval)duration showDuration:(NSTimeInterval)showDuration;


- (void)fadeOutNotification:(STAlertTypeViewController *)currentView;
@end
