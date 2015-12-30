//
//  STAddNewTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/15/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "STAddNewTableViewCell.h"
@interface STAddNewTableViewCell()
@end
@implementation STAddNewTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initSelfView
{
    [self changeLanguage];
    [Utils setRoundBorder:self.lblTitle color:[UIColor clearColor] borderRadius:5.0f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

-(void)changeLanguage
{
    self.lblCreteMapTitle.text = LocalisedString(@"Drop a new pin!");
    self.lblTitle.text = LocalisedString(@"Add a new place");

}

@end
