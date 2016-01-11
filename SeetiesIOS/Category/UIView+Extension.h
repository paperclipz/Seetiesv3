//
//  UIView+Extension.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/19/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extra)

-(void)adjustToScreenWidth;
-(void)setHeight:(float)height;
-(void)setWidth:(float)width;
-(void)setX:(float)X;
-(void)setY:(float)Y;
-(void)refreshConstraint;
-(void)prefix_addUpperBorder;
@end
