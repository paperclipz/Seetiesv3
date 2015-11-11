//
//  CommonViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentingAnimationController.h"
#import "DismissingAnimationController.h"

@interface CommonViewController : GAITrackedViewController<UIViewControllerTransitioningDelegate>
-(void)applyTabBarContraint;
@property(nonatomic,copy)IDBlock btnBackBlock;
@end
