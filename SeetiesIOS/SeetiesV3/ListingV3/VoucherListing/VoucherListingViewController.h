//
//  VoucherListingViewController.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoucherCell.h"
#import "GeneralFilterViewController.h"
#import "DealDetailsViewController.h"
#import "WalletListingViewController.h"
#import "DealsModel.h"
#import "DealManager.h"
#import "PromoPopOutViewController.h"
#import "DealRedeemViewController.h"
#import "SearchLocationViewController.h"

@interface VoucherListingViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, VoucherCellDelegate, PromoPopOutDelegate>
-(void)initWithLocation:(HomeLocationModel*)locationModel;

/*for deal listing*/
-(void)initData:(DealCollectionModel*)model withLocation:(HomeLocationModel*)locationModel;

@end
