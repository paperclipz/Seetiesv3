//
//  NSString+Extension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/12/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString(Extra)

//- (NSSize) sizeWithWidth:(float)width andFont:(NSFont *)font {
//    
//    NSSize size = NSMakeSize(width, FLT_MAX);
//    
//    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:self] retain];
//    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:size] retain];
//    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] retain];
//    [layoutManager addTextContainer:textContainer];
//    [textStorage addLayoutManager:layoutManager];
//    [textStorage addAttribute:NSFontAttributeName value:font
//                        range:NSMakeRange(0, [textStorage length])];
//    [textContainer setLineFragmentPadding:0.0];
//    
//    [layoutManager glyphRangeForTextContainer:textContainer];
//    
//    size.height = [layoutManager usedRectForTextContainer:textContainer].size.height;
//    
//    [layoutManager release];
//    [textContainer release];
//    [textStorage release];
//    
//    return size;
//}

@end
