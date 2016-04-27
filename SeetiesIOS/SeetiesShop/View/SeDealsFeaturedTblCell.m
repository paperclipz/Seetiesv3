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
    [self.lblFeatured setSideCurveBorder];
    [self.lblDiscount setSideCurveBorder];
    
    [self.ibImageView setStandardBorder];
    
    self.lblFeatured.text = LocalisedString(@"FEATURED");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedBackgroundView = nil;
    // Configure the view for the selected state
}

-(void)initSelfView
{
    
}

-(void)initData:(DealModel*)model
{
    self.dealModel = model;

    if (self.dealModel.is_feature) {
        self.lblFeatured.hidden = NO;
        
        constLblDiscountLeading.constant = 90;
        
        if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_DISCOUNT] || [self.dealModel.deal_type isEqualToString:DEAL_TYPE_PACKAGE]) {
            
            self.lblDiscount.text = [LanguageManager stringForKey:@"{!number}% off" withPlaceHolder:@{@"{!number}": self.dealModel.discount_percentage}];
            self.lblDiscount.backgroundColor = SELECTED_GREEN;
        }
        else if([self.dealModel.deal_type isEqualToString:DEAL_TYPE_FREE])
        {
            self.lblDiscount.text = LocalisedString(@"FREE");
            
            self.lblDiscount.backgroundColor = DEVICE_COLOR;
 
        }
        else{
            self.lblDiscount.hidden = YES;
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
