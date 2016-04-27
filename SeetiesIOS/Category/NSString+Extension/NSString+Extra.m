//
//  NSString+Extra.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NSString+Extra.h"

NSString * const TagKey = @"tagKey";

@implementation NSString(Extra)

- (void)setTags:(NSArray *)tags
{
    objc_setAssociatedObject(self, (__bridge const void *)(TagKey), tags, OBJC_ASSOCIATION_COPY);
}

- (NSArray*)tags
{
    NSMutableArray* tempArray = [NSMutableArray new];

    if (self.length>0) {
        NSString* pattern = @"\\B#\\w+";
        NSRegularExpression* hashTagRegExp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        
        [hashTagRegExp enumerateMatchesInString:self options:0 range:NSMakeRange(0,self.length)
                                     usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
         {
             // For each "#xxx" hashtag found, add a custom link:
             NSString* tag = [[self substringWithRange:match.range] substringFromIndex:1]; // get the tag without the "#"
             [tempArray addObject:tag];
             
         }];

    }
       return tempArray;
    //return objc_getAssociatedObject(self, (__bridge const void *)(TagKey));
}

-(NSArray*)getTagWithFormat
{
    NSMutableArray* tempArray = [NSMutableArray new];
    
    if (self.length>0) {
        NSString* pattern = @"\\B#\\w+";
        NSRegularExpression* hashTagRegExp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        
        [hashTagRegExp enumerateMatchesInString:self options:0 range:NSMakeRange(0,self.length)
                                     usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
         {
             // For each "#xxx" hashtag found, add a custom link:
             NSString* tag = [[self substringWithRange:match.range] substringFromIndex:1]; // get the tag without the "#"
             NSString* linkURLString = [NSString stringWithFormat:@"#[tag:%@]", tag]; // build a "tag:xxx" link
             [tempArray addObject:linkURLString];
             
         }];
        
    }
    return tempArray;

}

- (CGFloat)heightForWidth:(CGFloat)width usingFont:(UIFont *)font
{
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize labelSize = (CGSize){width, FLT_MAX};
    CGRect r = [self boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
    return r.size.height;
}

-(NSNumber*)toNSNumber
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:self];
    
    return myNumber;
}

- (NSArray *)rangesInSubstring:(NSString *)substring
{
    NSError *error = NULL;
    
    NSString *regex = [NSString stringWithFormat:@"\\b%@", substring];
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSMutableArray *ranges = [NSMutableArray array];
    
    NSArray *matches = [regExpression matchesInString:self options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
    
    for (NSTextCheckingResult *match in matches) {
        [ranges addObject:[NSValue valueWithRange:match.range]];
    }
    
    return ranges;
}


@end
