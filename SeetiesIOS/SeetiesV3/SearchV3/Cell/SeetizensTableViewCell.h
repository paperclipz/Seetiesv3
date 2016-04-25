//
//  SeetizensTableViewCell.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeetizensTableViewCell : CommonTableViewCell
-(void)initData:(UserModel*)model;
-(void)setFollowButtonSelected:(BOOL)selected button:(UIButton*)button;

@property(nonatomic,copy)VoidBlock btnFollowBlock;
@end
