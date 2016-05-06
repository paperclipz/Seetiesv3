//
//  VoucherCell.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealModel.h"
#import "DealCollectionModel.h"

@protocol VoucherCellDelegate <NSObject>

-(void)voucherCollectRedeemClicked:(DealModel*)dealModel;

@end

@interface VoucherCell : CommonTableViewCell
@property id<VoucherCellDelegate> voucherCellDelegate;
//For normal deal listing
-(void)initDealModel:(DealModel*)dealModel;
//For referral deal listing
-(void)initDealModel:(DealModel*)dealModel dealCollectionModel:(DealCollectionModel*)dealCollectionModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constUpperContentHeight;

@end
