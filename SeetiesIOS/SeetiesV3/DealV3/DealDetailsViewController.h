//
//  DealDetailsViewController.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 29/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

@protocol DealDetailsDelegate <NSObject>
-(void)dealUpdated:(DealModel*)dealModel;
@end

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
#import "HowToRedeemViewController.h"

@protocol NSDictionary

@end

@interface DealDetailsViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, PromoPopOutDelegate, DealRedeemDelegate>

@property id<DealDetailsDelegate> delegate;

-(void)initDealModel:(DealModel *)dealModel;// set before push
//For referral campaign
-(void)initDealModel:(DealModel *)dealModel withReferral:(NSString*)referralId withDealCollectionInfo:(DealCollectionModel*)dealCollectionModel;
-(void)setupView;// on completion setup view
-(void)setFromHistory:(BOOL)fromHistory;

@property(nonatomic,copy)DealModelBlock dealModelBlock;
@end
