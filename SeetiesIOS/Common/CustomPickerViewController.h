//
//  CustomPickerViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickerViewController : UIViewController
-(void)show;
-(void)hideWithAnimation:(BOOL)isAnimate;
+(id)initializeWithAddURLBlock:(IDBlock)addurl AddLangBlock:(IDBlock)addLang;

@end
