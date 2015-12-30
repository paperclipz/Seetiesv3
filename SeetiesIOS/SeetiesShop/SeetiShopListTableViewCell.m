//
//  SeetiShopListTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/10/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeetiShopListTableViewCell.h"
@interface SeetiShopListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibImgIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *ibImageVerified;
@end
@implementation SeetiShopListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [Utils setRoundBorder:self.ibImgIndicator color:[UIColor clearColor] borderRadius:self.ibImgIndicator.frame.size.width/2];
    [self.ibImageView setRoundedCorners:UIRectCornerAllCorners radius:self.ibImageView.frame.size.width/2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsOpen:(BOOL)isOpen
{
    self.ibImgIndicator.hidden = !isOpen;
    
}
@end
