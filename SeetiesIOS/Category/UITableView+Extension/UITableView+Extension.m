//
//  UITableView+Extension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "UITableView+Extension.h"

static const NSString *FOOTER_KEY = @"footer_key";
static const NSString *INDICATOR_KEY = @"indicator_key";

@implementation UITableView(Extra)

-(void)setupFooterView
{
    if (self.ibCustomFooterView) {
        if (self.ibCustomActivityIndicator) {
           // self.ibCustomActivityIndicator.tag = 10;
            self.ibCustomActivityIndicator.hidesWhenStopped = YES;

        }
        self.tableFooterView = self.ibCustomFooterView;
    }
}

-(void)startFooterLoadingView
{
    
    @try {
        self.tableFooterView = self.ibCustomFooterView;

        [self.ibCustomActivityIndicator startAnimating];

    }
    @catch (NSException *exception) {
    }
    
}
-(void)stopFooterLoadingView
{
    @try {
        [self.ibCustomActivityIndicator stopAnimating];
        self.tableFooterView = nil;
    }
    @catch (NSException *exception) {
    }
}


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

@dynamic ibCustomActivityIndicator;
- (UIActivityIndicatorView *)ibCustomActivityIndicator;
{
    return objc_getAssociatedObject(self, &INDICATOR_KEY);
}

- (void)setIbCustomActivityIndicator:(UIActivityIndicatorView *)ibCustomActivityIndicator
{
    if (self.ibCustomActivityIndicator.superview) {
        [self.ibCustomActivityIndicator removeFromSuperview];
    }
    objc_setAssociatedObject(self, &INDICATOR_KEY, ibCustomActivityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@dynamic ibCustomFooterView;
- (UIView *)ibCustomFooterView;
{
    return objc_getAssociatedObject(self, &FOOTER_KEY);
}

- (void)setIbCustomFooterView:(UIView *)ibCustomFooterView
{
    if (self.ibCustomFooterView.superview) {
        [self.ibCustomFooterView removeFromSuperview];
    }
    objc_setAssociatedObject(self, &FOOTER_KEY, ibCustomFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
@end
