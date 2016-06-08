//
//  UILabel+Exntension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/18/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "UILabel+Exntension.h"
#import "NSString+ChangeAsciiString.h"

@implementation UILabel(Extra)


-(void)setStandardText:(NSString*)text
{
    NSString* tempText = @"";
    if (text) {
        tempText = text;
    }
    
    tempText = [tempText stringByDecodingXMLEntities];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.minimumLineHeight = 21.0f;
    paragraph.maximumLineHeight = 21.0f;

    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSParagraphStyleAttributeName: paragraph
                              };

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:tempText attributes:options];
    self.attributedText = attributedString;
    self.backgroundColor = [UIColor clearColor];
    self.numberOfLines = 3;
    self.textAlignment = NSTextAlignmentLeft;
    self.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    self.font = [UIFont fontWithName:CustomFontName size:17];
 
    SLog(@"%@",self.attributedText);
}

-(void)setStandardText:(NSString*)text numberOfLine:(int)numOfLine
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
    self.numberOfLines = numOfLine;
    self.textAlignment = NSTextAlignmentLeft;
    self.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.font = [UIFont fontWithName:CustomFontName size:15];
    
}

- (void) boldRange: (NSRange) range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
    
    self.attributedText = attributedText;
}

- (void) boldSubstring: (NSString*) substring {
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}
@end
