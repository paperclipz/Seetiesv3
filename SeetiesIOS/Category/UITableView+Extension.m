//
//  UITableView+Extension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView(Extra)

- (void) reloadSectionDU:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSRange range = NSMakeRange(section, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [self reloadSections:sectionToReload withRowAnimation:rowAnimation];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
