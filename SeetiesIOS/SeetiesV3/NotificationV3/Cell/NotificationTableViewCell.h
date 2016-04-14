//
//  NotificationTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/17/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : CommonTableViewCell
-(void)initData:(NotificationModel*)model Type:(int)type;
@property(nonatomic,copy)RowPickedBlock didSelectPostAtIndexBlock;
@property(nonatomic,copy)NotificationModelBlock didSelectProfileBlock;


@end
