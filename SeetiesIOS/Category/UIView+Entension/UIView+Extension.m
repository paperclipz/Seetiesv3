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

- (void)prefix_addUpperBorder:(UIColor*)color
{
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [color CGColor];
    upperBorder.frame = CGRectMake(0, 0, self.frame.size.width, 1.0f);
    [self.layer addSublayer:upperBorder];
}

-(void)prefix_addLowerBorder:(UIColor*)color{
    CALayer *lowerBorder = [CALayer layer];
    lowerBorder.backgroundColor = [color CGColor];
    lowerBorder.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1.0f);
    [self.layer addSublayer:lowerBorder];
}

-(void)prefix_addLeftBorder:(UIColor*)color{
    CALayer *leftBorder = [CALayer layer];
    leftBorder.backgroundColor = [color CGColor];
    leftBorder.frame = CGRectMake(0, 0, 1.0f, self.frame.size.height);
    [self.layer addSublayer:leftBorder];
}

-(void)prefix_addRightBorder:(UIColor*)color{
    CALayer *rightBorder = [CALayer layer];
    rightBorder.backgroundColor = [color CGColor];
    rightBorder.frame = CGRectMake(self.frame.size.width-1, 0, 1.0f, self.frame.size.height);
    [self.layer addSublayer:rightBorder];
}

-(void)setSideCurveBorder
{
    [Utils setRoundBorder:self color:[UIColor clearColor] borderRadius:self.frame.size.height/2];
}


-(void)setRoundedBorder
{
    [Utils setRoundBorder:self color:[UIColor clearColor] borderRadius:self.frame.size.width/2];
}

-(void)setStandardBorder
{
    [Utils setRoundBorder:self color:LINE_COLOR borderRadius:5.0f];
    
}

-(void)setSquareBorder
{
    [Utils setRoundBorder:self color:OUTLINE_COLOR borderRadius:0];
    
}

-(void)resizeToFitSubviews
{
    float w = 0;
    float h = 0;
    
    for (UIView *v in [self subviews]) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];
}

-(void)resizeToFitSubviewsHeight
{
    float h = 0;
    
    for (UIView *v in [self subviews]) {
        float fh = v.frame.origin.y + v.frame.size.height;
        h = MAX(fh, h);
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, h)];
}


@end

@implementation UIView(BackgroundColor)
-(void)setCustomBackgroundColorForIndexPath:(NSIndexPath*)indexPath
{
    
    int counter = indexPath.row%4;

    UIColor* color;
    switch (counter) {
        default:
            
        case 0:
            color = DEVICE_COLOR;
            
            break;
            
        case 1:
            color = SELECTED_RED;
            
            break;
            
            
        case 2:
            color = SELECTED_GREEN;
            
            break;
            
        case 3:
            color = SELECTED_YELLOW;
            
            break;
            
            
    }
    
    self.backgroundColor = color;
}

@end

