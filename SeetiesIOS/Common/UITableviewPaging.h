//
//  UITableviewPaging.h
//  SeetiesIOS
//
//  Created by Evan Beh on 11/27/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableviewPaging : UITableView<UIScrollViewDelegate>
-(void)nextPage:(int)totalpage;
@property(nonatomic,copy)VoidBlock scollViewReachBottomTriggerBlock;
-(void)setupPagination:(int)currentpage totalPage:(int)totalPage isFirstLoad:(BOOL)isFirstLoad;
-(int)getTheCurrentPage;

@property(nonatomic,readonly)BOOL isFirstLoad;
@end
