//
//  UIFont+SystemFontOverride.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/20/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "UIFont+SystemFontOverride.h"

@implementation UIFont (SystemFontOverride)


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:CustomFontName size:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:CustomFontName size:fontSize];
}

+ (UIFont *)italicFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:CustomFontName size:fontSize];
}

#pragma clang diagnostic pop

@end
