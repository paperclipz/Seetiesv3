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
-(void)prefix_addUpperBorder:(UIColor*)color;
-(void)prefix_addLowerBorder:(UIColor*)color;
-(void)prefix_addLeftBorder:(UIColor*)color;
-(void)prefix_addRightBorder:(UIColor*)color;
-(void)setSideCurveBorder;// left right round
-(void)setRoundedBorder; // full round
-(void)setStandardBorder;// 4 side border curve
-(void)setSquareBorder;

@end


@interface UIView (BackgroundColor)

-(void)setCustomBackgroundColorForIndexPath:(NSIndexPath*)indexPath;
@end