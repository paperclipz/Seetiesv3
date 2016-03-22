//
//  WalletListingViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "WalletVoucherCell.h"
#import "PromoPopOutViewController.h"
#import "STPopupController.h"
#import "RedemptionHistoryViewController.h"
#import "DealDetailsViewController.h"
#import "DealRedeemViewController.h"
#import "VoucherListingViewController.h"
#import "DealExpiryDateModel.h"
#import "SVPullToRefresh.h"

@interface WalletListingViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, WalletVoucherDelegate, DealRedeemDelegate, UIScrollViewDelegate, PromoPopOutDelegate>


@end
