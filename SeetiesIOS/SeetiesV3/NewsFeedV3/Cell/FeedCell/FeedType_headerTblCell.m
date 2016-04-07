//
//  FeedType_headerTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/16/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_headerTblCell.h"

@interface FeedType_headerTblCell()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

@end
@implementation FeedType_headerTblCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initSelfView
{
    [self changeLanguage];

}

-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Recommended by Users");
    self.lblDesc.text = LocalisedString(@"See what is happening around you");

}
@end
