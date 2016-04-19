//
//  UITabBar+Extension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/21/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "UITabBar+Extension.h"

@implementation UITabBar(Extra)
-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height = TAB_BAR_HEIGHT;
    
    return sizeThatFits;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
