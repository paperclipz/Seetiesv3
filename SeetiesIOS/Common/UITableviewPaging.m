//
//  UITableviewPaging.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/27/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "UITableviewPaging.h"
@interface UITableviewPaging()
{
    BOOL isMiddleOfCallingServer;
}
@property(nonatomic,assign)BOOL isFirstLoad;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,assign)int totalPage;


@end
@implementation UITableviewPaging


-(void)awakeFromNib
{
    SLog(@"awakeFromNib");

}
-(void)setupPagination:(int)currentpage totalPage:(int)totalPage isFirstLoad:(BOOL)isFirstLoad
{
    self.isFirstLoad = isFirstLoad;
    self.currentPage = currentpage;
    self.totalPage = totalPage;
}

-(void)nextPage:(int)totalpage
{
    self.totalPage = totalpage;

    self.currentPage += 1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 10;
    if(y >= h - reload_distance) {
        
        if (!isMiddleOfCallingServer) {
            
            
            if (self.totalPage >= self.currentPage) {
                
                if (self.scollViewReachBottomTriggerBlock) {
                    self.isFirstLoad = false;
                    self.scollViewReachBottomTriggerBlock();
                }
            }
            
            
        }
        
        
        
    }
}

-(int)getTheCurrentPage
{
    if (self.isFirstLoad) {
        self.currentPage = 1;
    }
    
    return self.currentPage;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
