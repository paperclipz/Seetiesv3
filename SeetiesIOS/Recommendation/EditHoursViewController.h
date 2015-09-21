//
//  EditHoursViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/27/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "EditHourModel.h"


typedef void (^BackBlock)(NSArray* array);

@interface EditHoursViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray* arrOpeningTime;
@property(nonatomic,copy)BackBlock backBlock;
-(void)initData:(NSMutableArray*)arrayModel;

@end
