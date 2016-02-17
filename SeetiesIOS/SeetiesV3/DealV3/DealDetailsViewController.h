//
//  DealDetailsViewController.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 29/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "TagCell.h"
#import "DealDetailsAvailabilityCell.h"
#import "PromoOutletCell.h"
#import "SeDealsFeaturedTblCell.h"
#import "NearbyShopsCell.h"

typedef enum{
    UncollectedDealDetailsView,
    CollectedDealDetailsView,
    RedeemedDealDetailsView,
    ExpiredDealDetailsView
} DealDetailsViewType;

@interface DealDetailsViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

-(void)setDealDetailsViewType:(DealDetailsViewType)viewType;
-(void)setDealModel:(DealModel *)dealModel;

@end
