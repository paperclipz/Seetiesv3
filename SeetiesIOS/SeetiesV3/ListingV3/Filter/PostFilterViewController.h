//
//  PostFilterViewController.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 14/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostFilterSortCell.h"
#import "PostFilterCategoryCell.h"
#import "FiltersModel.h"

@protocol PostFilterViewDelegate <NSObject>

-(void)postApplyFilterClicked:(FiltersModel*)filtersModel;

@end

@interface PostFilterViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
@property id<PostFilterViewDelegate> delegate;

-(void)initWithFilter:(FiltersModel*)filtersModel;
@end
