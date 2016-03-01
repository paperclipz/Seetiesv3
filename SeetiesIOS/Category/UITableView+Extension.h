//
//  UITableView+Extension.h
//  SeetiesIOS
//
//  Created by Evan Beh on 11/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(Extra)
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *ibCustomActivityIndicator;
@property (nonatomic, strong) IBOutlet UIView *ibCustomFooterView;

- (void) reloadSectionDU:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation;
-(void)setupFooterView;
-(void)startFooterLoadingView;
-(void)stopFooterLoadingView;

@end
