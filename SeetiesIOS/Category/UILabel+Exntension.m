//
//  UILabel+Exntension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/18/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "UILabel+Exntension.h"

@implementation UILabel(Extra)


-(void)setStandardText:(NSString*)text
{
    NSString* tempText = @"";
    if (text) {
        tempText = text;
    }
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.minimumLineHeight = 21.0f;
    paragraph.maximumLineHeight = 21.0f;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:tempText attributes:@{NSParagraphStyleAttributeName: paragraph}];
    self.attributedText = attributedString;
    self.backgroundColor = [UIColor clearColor];
    self.numberOfLines = 3;
    self.textAlignment = NSTextAlignmentLeft;
    self.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    self.font = [UIFont fontWithName:CustomFontName size:17];
    
}
@end
