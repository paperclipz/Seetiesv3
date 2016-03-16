//
//  HomeModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/3/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FilterCurrencyModel.h"

#import "GreetingModel.h"


@protocol AnnouncementModel@end

@protocol QuickBrowseModel@end


@protocol DealCollectionModel@end

@protocol FilterCurrencyModel
@end

@interface HomeModel : JSONModel

@property(nonatomic,assign)int wallet_count;
@property(nonatomic,strong)NSArray<DealModel>* superdeals;
@property(nonatomic,strong)NSArray<AnnouncementModel>* announcements;
@property(nonatomic,strong)NSArray<QuickBrowseModel>* quick_browse;
@property(nonatomic,strong)NSArray<DealCollectionModel>* deal_collections;
@property(nonatomic,strong)GreetingModel* greeting;


@property(nonatomic,strong)FilterCurrencyModel *filter_currency;

@end
