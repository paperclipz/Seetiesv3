//
//  SeDealsFeaturedTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/28/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SeDealsFeaturedTblCell.h"
@interface SeDealsFeaturedTblCell()
{

    __weak IBOutlet NSLayoutConstraint *constLblDiscountLeading;
}
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblFeatured;
@property (nonatomic) DealModel* dealModel;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;

@end
@implementation SeDealsFeaturedTblCell

- (void)awakeFromNib {
    // Initialization code
    
    self.lblFeatured.text = LocalisedString(@"Value");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initSelfView
{
    [self.lblFeatured setSideCurveBorder];
    [self.ibImageView setStandardBorder];
}

-(void)initData:(DealModel*)model
{
    self.dealModel = model;

    if (self.dealModel.is_feature) {
        self.lblFeatured.hidden = NO;
        
        constLblDiscountLeading.constant = 106;
        
        if ([self.dealModel.deal_type isEqualToString:@"discount"]) {
            
            self.lblDiscount.text = [NSString stringWithFormat:@"%@ %% OFF",self.dealModel.discount_percentage];
        }
        else if([self.dealModel.deal_type isEqualToString:@"free"])
        {
            self.lblDiscount.text = LocalisedString(@"FREE");
            
        }
        else if([self.dealModel.deal_type isEqualToString:@"package"])
        {
            self.lblDiscount.text = [NSString stringWithFormat:@"%@ %% OFF",self.dealModel.discount_percentage];
            
        }
        
        else{
            self.lblDiscount.text = [NSString stringWithFormat:@"%@ %% OFF",self.dealModel.discount_percentage];
            
        }

    }
    else{
        self.lblFeatured.hidden = YES;
        constLblDiscountLeading.constant = 8;

        

    }
    
    @try {
        
        if (![Utils isStringNull:self.dealModel.cover_title]) {
            self.lblDescription.text = self.dealModel.cover_title;

        }
        else{
            self.lblDescription.text = self.dealModel.title;

        }

    }
    @catch (NSException *exception) {
        
    }

    
    if (self.dealModel.cover_photo) {
        
        [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:self.dealModel.cover_photo.imageURL] completed:nil];
    }
    else{
        
        @try {
            PhotoModel* pModel = self.dealModel.photos[0];
            [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];

        }
        @catch (NSException *exception) {
            
        }
       

    }
    
}
@end
