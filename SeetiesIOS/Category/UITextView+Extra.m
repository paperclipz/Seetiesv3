//
//  UITextView+Extra.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "UITextView+Extra.h"

@implementation UITextView(SystemOverride)

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString* fontName = self.font.fontName;
    if ([fontName containsString:BOLD]) {
        fontName = CustomFontNameBold;
    }
    else
    {
        fontName = CustomFontName;
        
    }
    
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}
@end
