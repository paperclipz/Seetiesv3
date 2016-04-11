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

-(void)initWithLocation:(HomeLocationModel*)locationModel  quickBrowseModel:(QuickBrowseModel*)quickBrowseModel;
-(void)initWithDealId:(NSString*)dealId;
-(void)initData:(DealCollectionModel*)model withLocation:(HomeLocationModel*)locationModel quickBrowseModel:(QuickBrowseModel*)quickBrowseModel;
-(void)initDataWithShopID:(NSString*)shopID;
-(void)initWithDealsModel:(DealsModel*)dealsModel;
@end
