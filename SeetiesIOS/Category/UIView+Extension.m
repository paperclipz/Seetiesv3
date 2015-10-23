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

@end
