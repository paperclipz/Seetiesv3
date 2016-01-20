//
//  UIView+Extension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/19/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "UIView+Extension.h"


@implementation UIView(Extra)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)adjustToScreenWidth
{
    CGRect frame = [Utils getDeviceScreenSize];
    SLog(@"Screen Size : %f",frame.size.width);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, self.frame.size.height);
}

-(void)setHeight:(float)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

-(void)setWidth:(float)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

-(void)setX:(float)X
{
    self.frame = CGRectMake(X, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

-(void)setY:(float)Y
{
    self.frame = CGRectMake(self.frame.origin.x, Y, self.frame.size.width, self.frame.size.height);
}

-(void)refreshConstraint
{
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}

- (void)prefix_addUpperBorder
{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor greenColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1.0f);
    [self.layer addSublayer:upperBorder];
}

-(void)setSideCurveBorder
{
    [Utils setRoundBorder:self color:[UIColor clearColor] borderRadius:self.frame.size.height/2];
}
@end
