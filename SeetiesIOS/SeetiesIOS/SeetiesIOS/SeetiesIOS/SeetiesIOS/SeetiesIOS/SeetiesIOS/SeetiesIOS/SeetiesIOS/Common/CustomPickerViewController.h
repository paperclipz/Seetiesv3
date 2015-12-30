//
//  CustomPickerViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomPickerViewController : CommonViewController
-(void)show;
-(void)hideWithAnimation:(BOOL)isAnimate;
+(id)initializeWithBlock:(IDBlock)buttonOne buttonTwo:(IDBlock)buttonTwo cancelBlock:(IDBlock)cancelBlock;
@property (copy, nonatomic) IDBlock cancelBlock;

@end
