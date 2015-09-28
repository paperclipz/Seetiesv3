//
//  STAddNewTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/15/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "STAddNewTableViewCell.h"

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
    self.lblTitle.text = LOCALIZATION(@"Add New Places");
}
@end
