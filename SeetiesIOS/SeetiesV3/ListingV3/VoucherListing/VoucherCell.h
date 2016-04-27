//
//  VoucherCell.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealModel.h"

@protocol VoucherCellDelegate <NSObject>

-(void)voucherCollectRedeemClicked:(DealModel*)dealModel;

@end

@interface VoucherCell : CommonTableViewCell
@property id<VoucherCellDelegate> voucherCellDelegate;
-(void)setDealModel:(DealModel*)dealModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constUpperContentHeight;

@end
