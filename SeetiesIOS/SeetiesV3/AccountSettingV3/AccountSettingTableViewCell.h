//
//  AccountSettingTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 3/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UISwitch *ibSwitch;
-(void)initData:(int)type;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(int)type;

@property(nonatomic,copy)BoolBlock didChangeSettingBlock;
@end
