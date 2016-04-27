//
//  CustomEmptyView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 07/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLImageView.h"
@interface CustomEmptyView : UITableView

-(void)showLoading;
-(void)showEmptyState;
-(void)hideAll;
-(void)setupCustomEmptyView;

@end
