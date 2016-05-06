//
//  NSString+Extra.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Extra)
- (CGFloat)heightForWidth:(CGFloat)width usingFont:(UIFont *)font;
-(NSNumber*)toNSNumber;

@property (nonatomic, copy) NSArray* tags;
-(NSArray*)getTagWithFormat;
- (NSArray *)rangesInSubstring:(NSString *)substring;


// ===== NSDATE ===== //
-(NSDate*)toDate;
// ===== NSDATE ===== //

@end
