//
//  WalletVoucherCell.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 06/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealModel.h"

@protocol WalletVoucherDelegate <NSObject>

-(void)redeemVoucherClicked:(DealModel*)deal;

@end

@interface WalletVoucherCell : CommonTableViewCell

@property(nonatomic)id<WalletVoucherDelegate> delegate;
@end
