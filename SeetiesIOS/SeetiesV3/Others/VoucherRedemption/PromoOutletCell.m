//
//  PromoOutletCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 28/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PromoOutletCell.h"

@interface PromoOutletCell()
@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibOutletImg;
@property (weak, nonatomic) IBOutlet UILabel *ibOutletTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibOutletAddress;
@property (weak, nonatomic) IBOutlet UIImageView *ibIsSelectedImg;
@property (weak, nonatomic) IBOutlet UIImageView *ibArrowImg;
@property (weak, nonatomic) IBOutlet UIImageView *ibIsSeetishopIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibShopStatusLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibRightViewWidthConstraint;

@property(nonatomic, assign) PromoOutletCellType cellType;
@property(nonatomic) SeShopDetailModel *shopModel;
@end

@implementation PromoOutletCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectedBackgroundView = nil;
    // Configure the view for the selected state
    if (self.cellType == PromoOutletCellTypeSelection) {
        self.ibIsSelectedImg.hidden = !selected;
    }
    
}

-(void)setCellType:(PromoOutletCellType)cellType{
    _cellType = cellType;
    
    if (self.cellType == PromoOutletCellTypeSelection) {
        self.ibArrowImg.hidden = YES;
        self.ibShopStatusLbl.hidden = YES;
        self.ibRightViewWidthConstraint.constant = 40;
    }
    else if(self.cellType == PromoOutletCellTypeNonSelection){
        self.ibArrowImg.hidden = NO;
        self.ibShopStatusLbl.hidden = YES;
        self.ibRightViewWidthConstraint.constant = 40;
    }
    else if (self.cellType == PromoOutletCellTypeStatus){
        self.ibArrowImg.hidden = YES;
        self.ibShopStatusLbl.hidden = NO;
        self.ibRightViewWidthConstraint.constant = 70;
        
        [self.ibShopStatusLbl setSideCurveBorder];
    }
}

-(void)setShopModel:(SeShopDetailModel *)shopModel{
    _shopModel = shopModel;
    
    self.ibOutletTitle.text = self.shopModel.name;
    self.ibOutletAddress.text = self.shopModel.location.formatted_address;
    self.ibIsSeetishopIcon.hidden = !self.shopModel.is_collaborate;
    
    @try {
        NSString* imageURL = shopModel.profile_photo[@"picture"];
        if (![Utils isStringNull:imageURL]) {
            [self.ibOutletImg sd_setImageCroppedWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image) {
            }];
        }
        else{
            [self.ibOutletImg setImage:[UIImage imageNamed:@"SsDefaultDisplayPhoto.png"]];
        }
        
        [Utils setRoundBorder:self.ibOutletImg color:[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1] borderRadius:5.0f];
        
        if (self.cellType == PromoOutletCellTypeStatus) {
            if (self.shopModel.location.opening_hours.open_now) {
                self.ibShopStatusLbl.text = LocalisedString(@"OPEN");
                self.ibShopStatusLbl.backgroundColor = [UIColor colorWithRed:122/255.0f green:210/255.0f blue:26/255.0f alpha:1];
            }
            else{
                self.ibShopStatusLbl.text = LocalisedString(@"CLOSED");
                self.ibShopStatusLbl.backgroundColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
            }
        }
    }
    @catch (NSException *exception) {
        SLog(@"assign image url fail");
    }
   
}

-(void)drawBorders{
    [self.ibInnerContentView prefix_addUpperBorder:OUTLINE_COLOR];
    [self.ibInnerContentView prefix_addLowerBorder:OUTLINE_COLOR];
}

@end
