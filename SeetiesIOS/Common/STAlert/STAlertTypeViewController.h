//
//  STAlertTypeViewController.h
//  TEST
//
//  Created by ZackTvZ on 6/2/16.
//  Copyright © 2016 ZackTvZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STAlertController.h"

@interface STAlertTypeViewController : UIViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
         stAlertType:(STAlertType)stAlertType
  stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType
             message:(NSString *)message
            duration:(NSTimeInterval)duration
        showDuration:(NSTimeInterval)showDuration
             topView:(UIViewController *)topView
            tapClose:(TapClose)tapClose
 onlyCurrentViewShow:(BOOL)onlyCurrentViewShow;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
         stAlertType:(STAlertType)stAlertType
             message:(NSString *)message;

@property(assign, nonatomic)int oriHeight;
@property(assign, nonatomic)STAlertType stAlertType;
@property(assign, nonatomic)STAlertDisplayType stAlertDisplayType;
@property(assign, nonatomic)NSTimeInterval duration;
@property(assign, nonatomic)NSTimeInterval showDuration;
@property(strong, nonatomic)UIViewController *topView;
@property(assign, nonatomic)BOOL onlyCurrentViewShow;
@property(strong, nonatomic)NSString *message;

@property(nonatomic,copy)TapClose didTapCloseBlock;
@end
