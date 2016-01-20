//
//  DealType_DealOTDTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/20/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealType_DealOTDTblCell.h"

@interface DealType_DealOTDTblCell()
@property (weak, nonatomic) IBOutlet UILabel *lblCollectNow;
@end
@implementation DealType_DealOTDTblCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initSelfView
{
    self.lblCollectNow.textColor = DEVICE_COLOR;
    [self.lblCollectNow setSideCurveBorder];
}
@end
