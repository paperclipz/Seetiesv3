//
//  TagLabel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 22/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "TagLabel.h"

@implementation TagLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawTextInRect:(CGRect)rect{
    UIEdgeInsets insets = {0, 10, 0, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
