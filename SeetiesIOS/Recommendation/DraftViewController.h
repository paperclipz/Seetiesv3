//
//  DraftViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/3/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"

@interface DraftViewController : CommonViewController <UITableViewDataSource,UITableViewDelegate>
-(void)initData;
@property(nonatomic,copy)IDBlock backBlock;
@end
