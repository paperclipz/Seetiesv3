//
//  UILabel+Exntension.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/18/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(Extra)
-(void)setStandardText:(NSString*)text;
- (void) boldSubstring: (NSString*) substring;
- (void) boldRange: (NSRange) range;
@end
