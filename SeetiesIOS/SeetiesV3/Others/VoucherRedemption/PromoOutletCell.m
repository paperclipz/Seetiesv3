//
//  PromoOutletCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 28/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PromoOutletCell.h"

@interface PromoOutletCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibOutletImg;
@property (weak, nonatomic) IBOutlet UILabel *ibOutletTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibOutletAddress;
@property (weak, nonatomic) IBOutlet UIImageView *ibIsSelectedImg;

@end

@implementation PromoOutletCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOutletImage:(UIImage*)image{
    [_ibOutletImg setImage:image];
}

-(void)setOutletTitle:(NSString*)title{
    _ibOutletTitle.text = title;
}

-(void)setOutletAddress:(NSString*)address{
    _ibOutletAddress.text = address;
}

-(void)setOutletIsChecked:(BOOL)isChecked{
    _ibIsSelectedImg.hidden = !isChecked;
}

@end
