//
//  EditHourTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/27/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditHourTableViewCell.h"


@interface EditHourTableViewCell()
{
    BOOL isToTimeEdited;
    BOOL isFromTimeEdited;

}
@end
#define MINUTE_INTERVAL  5
@implementation EditHourTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initSelfView
{
    
    
    self.fromTime = [NSDate date];
    self.toTime = [NSDate date];

    [Utils setButtonWithBorder:self.btnFromTime];
    [Utils setButtonWithBorder:self.btnToTime];
    
    [self.btnToTime setTitleColor:DEVICE_COLOR forState:UIControlStateNormal];
    [self.btnToTime setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  
    [self.btnFromTime setTitleColor:DEVICE_COLOR forState:UIControlStateNormal];
    [self.btnFromTime setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

}

-(void)initData
{
    
    isToTimeEdited = false;
    isFromTimeEdited = false;
    
    NSString* openTime =  [self formatTime:[@(self.model.open.time)stringValue]];
    NSString* closeTime =  [self formatTime:[@(self.model.close.time)stringValue]];

    [self.btnFromTime setTitle:openTime forState:UIControlStateNormal];
    [self.btnToTime setTitle: closeTime forState:UIControlStateNormal];
    self.lblDay.text = [Utils getWeekName:self.model.open.day];
    self.ibSwitch.on = self.model.isOpen;
    
    [self setOn:self.model.isOpen];

}

-(NSInteger)roundTime
{
    //clamp date
    NSInteger referenceTimeInterval = (NSInteger) [ self.fromTime timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceTimeInterval % (MINUTE_INTERVAL * 60);
    NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if (remainingSeconds > ((MINUTE_INTERVAL * 60) / 2)) {/// round up
        timeRoundedTo5Minutes = referenceTimeInterval + ((MINUTE_INTERVAL * 60) - remainingSeconds);
    }
    
    return timeRoundedTo5Minutes;
}
- (IBAction)ibSwitchClicked:(id)sender {
    UISwitch* button = (UISwitch*)sender;
   
    [self setOn:button.on];

}

-(void)setOn:(BOOL)isOn
{
    self.btnFromTime.enabled = isOn;
    self.btnToTime.enabled = isOn;
}
- (IBAction)btnToTimeClicked:(id)sender {
    
    self.toTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval) [self roundTime]];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:self.lblDay.text datePickerMode:UIDatePickerModeTime selectedDate:self.toTime target:self action:@selector(toTimeWasSelected:element:) origin:sender];
    datePicker.minuteInterval = MINUTE_INTERVAL;
    [datePicker addCustomButtonWithTitle:@"Now" value:[NSDate date]];
    
    [datePicker showActionSheetPicker];

}
- (IBAction)btnFromTimeClicked:(id)sender {

    

    self.fromTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval) [self roundTime]];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:self.lblDay.text datePickerMode:UIDatePickerModeTime selectedDate:self.fromTime target:self action:@selector(fromTimeWasSelected:element:) origin:sender];
    datePicker.minuteInterval = MINUTE_INTERVAL;
    [datePicker addCustomButtonWithTitle:@"Now" value:[NSDate date]];
   
    [datePicker showActionSheetPicker];
}

- (void)toTimeWasSelected:(NSDate *)selectedTime element:(id)element {
    
    isToTimeEdited = YES;

    self.toTime = selectedTime;

    UIButton* sender = (UIButton*)element;
    [sender setTitle:[self dateGetString:selectedTime] forState:UIControlStateNormal];
    
    
    SLog(@"To date : %@",[self dateGetString:self.toTime]);
    
}

- (void)fromTimeWasSelected:(NSDate *)selectedTime element:(id)element {

    isFromTimeEdited = YES;

    self.fromTime = selectedTime;

    UIButton* sender = (UIButton*)element;
     [sender setTitle:[self dateGetString:selectedTime] forState:UIControlStateNormal];
    
    
    SLog(@"from date : %@",[self dateGetString:self.fromTime]);

}

-(NSString*)dateGetString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    
    return [dateFormatter stringFromDate:date];
    


}

#pragma mark - Save Data
-(OperatingHoursModel*)saveData
{
    
    if (isFromTimeEdited) {
        self.model.open.time = [[self simplifyTime:self.fromTime] intValue];

    }
    if (isToTimeEdited) {
        self.model.close.time = [[self simplifyTime:self.toTime] intValue];
        
    }

    self.model.isOpen = self.ibSwitch.on;
    return self.model;
}
#define TIME_ZONE 1200
#define AM @"AM"
#define PM @"PM"

-(NSString*)formatTime:(NSString*)dateTime
{
    NSString* dayFormat = AM;
    double integerTime = [dateTime intValue];
    
    
    if (integerTime  >  TIME_ZONE) {
        dayFormat = PM;
        
        if(integerTime>= 1300)
        integerTime = integerTime - TIME_ZONE;
    }
    
    return [NSString stringWithFormat:@"%.2f%@",integerTime/100,dayFormat];
}

-(NSString*)simplifyTime:(NSDate*)dateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"Hmm"];
    
    
    return [dateFormatter stringFromDate:dateTime];
}


@end
