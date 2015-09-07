//
//  EditHoursViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/27/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "EditHourModel.h"


@interface EditHoursViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray* arrOpeningTime;
@end
