//
//  UIButton+Extra.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "UIButton+Extra.h"

@implementation UIButton (SystemOverride)
- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString* fontName = self.titleLabel.font.fontName;
    if ([fontName containsString:BOLD]) {
        fontName = CustomFontNameBold;
    }
    else
    {
        fontName = CustomFontName;
        
    }
    
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}
@end
