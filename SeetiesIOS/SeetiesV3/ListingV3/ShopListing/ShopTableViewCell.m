//
//  ShopTableViewCell.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 07/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ShopTableViewCell.h"

@interface ShopTableViewCell()
@end
@implementation ShopTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(float)getHeightWithoutImage
{
    return 110;
}
@end
