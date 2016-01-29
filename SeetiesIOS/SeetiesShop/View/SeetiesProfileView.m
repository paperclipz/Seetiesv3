//
//  SeetiesProfileView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/28/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SeetiesProfileView.h"

@interface SeetiesProfileView()

@property(nonatomic,strong)SeShopDetailModel* seShopDetailModel;

@property (weak, nonatomic) IBOutlet UIView *ibBorderView;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

@property (weak, nonatomic) IBOutlet UILabel *lblShopCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageVerified;
@property (weak, nonatomic) IBOutlet UILabel *lblOpenNow;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfile;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfileBackground;
@end

@implementation SeetiesProfileView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)initSelfView
{
    [Utils setRoundBorder:self.ibBorderView color:OUTLINE_COLOR borderRadius:0 borderWidth:1.0f];
    [self.ibImgProfile setRoundedBorder];
}

-(void)initData:(SeShopDetailModel*)model
{
    self.seShopDetailModel = model;
}

@end
