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
#import "SearchManager.h"
#import "YLGIFImage.h"
#import "YLImageView.h"

typedef void (^HomeModelBlock)(HomeLocationModel* model);

@interface VoucherListingViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, VoucherCellDelegate, PromoPopOutDelegate, FilterViewControllerDelegate, DealRedeemDelegate>
@property(nonatomic,copy)HomeModelBlock didSelectHomeLocationBlock;

//Init for Featured Deals
-(void)initWithLocation:(HomeLocationModel*)locationModel;

//Init for Relevant Deals
-(void)initWithDealId:(NSString*)dealId;

//Init for Deal Collection or Deal Collection from Notification (without HomeLocationModel)
-(void)initData:(DealCollectionModel*)model withLocation:(HomeLocationModel*)locationModel;

//Init for Shop Deals
-(void)initDataWithShopID:(NSString*)shopID;

//Init for Promo code Deals
-(void)initWithDealsModel:(DealsModel*)dealsModel;

//Init for Referral code Deals (To be changed)
-(void)initWithDealCollectionModel:(DealCollectionModel*)model ReferralID:(NSString*)refID;
@end
