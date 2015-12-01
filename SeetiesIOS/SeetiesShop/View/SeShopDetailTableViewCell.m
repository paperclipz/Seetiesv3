//
//  SeShopDetailTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeShopDetailTableViewCell.h"

@implementation SeShopDetailTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(int)getHeight
{
    return 60;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];

    if (self) {
        [self setWidth:[Utils getDeviceScreenSize].size.width];
    }
    
    return self;
}
@end
