//
//  EditHourTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/27/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "OpeningPeriodModel.h"

@interface EditHourTableViewCell : CommonTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UIButton *btnFromTime;
@property (weak, nonatomic) IBOutlet UISwitch *ibSwitch;
@property (weak, nonatomic) IBOutlet UIButton *btnToTime;
@property (nonatomic, strong) NSDate *fromTime;
@property (nonatomic, strong) NSDate *toTime;

@property(nonatomic,strong)OperatingHoursModel* model;

-(void)initData;
-(OperatingHoursModel*)saveData;

@end
