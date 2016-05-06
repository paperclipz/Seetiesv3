//
//  DealDetailsViewController.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 29/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "DealDetailsAvailabilityCell.h"
#import "PromoOutletCell.h"
#import "SeDealsFeaturedTblCell.h"
#import "NearbyShopsCell.h"
#import "RedemptionTypeView.h"
#import "DealManager.h"
#import "PromoPopOutViewController.h"
#import "DealRedeemViewController.h"
#import "SeetiesShopViewController.h"
#import "SeetiShopListingViewController.h"
#import "VoucherListingViewController.h"
#import "TermsViewController.h"
#import "PromoPopOutViewController.h"
#import "ReportProblemViewController.h"

@protocol NSDictionary

@end

@interface DealDetailsViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, PromoPopOutDelegate, DealRedeemDelegate>

-(void)initDealModel:(DealModel *)dealModel;// set before push
-(void)initDealModel:(DealModel *)dealModel withReferral:(NSString*)referralId;
-(void)setupView;// on completion setup view
@end
