//
//  OfflineManager.m
//  Seeties
//
//  Created by Evan Beh on 05/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "OfflineManager.h"
#import "DealExpiryDateModel.h"

#define REDEEM_KEY @"DEAL_TO_REDEEM"
#define NEWS_FEED_KEY @"NEWS_FEED_KEY"

@interface OfflineManager()
{
    NSMutableArray<DealModel>* _arrDealToRedeem;
}
@property(nonatomic) BOOL isLoading;
@property (nonatomic) NSUserDefaults *userDefaults;

@end
@implementation OfflineManager


//================ Offline Deal listing ================//

+(id)Instance{
    static OfflineManager *dealManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dealManager = [[self alloc] init];
    });
    return dealManager;
}

-(id)init{
    if (self = [super init]) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
    }
    return self;
}


-(void)uploadDealToRedeem
{
    
    // [self deleteDealsToRedeem];
    [self requestServerToRedeemVouchers:self.arrDealToRedeem];
}

-(void)addDealToRedeem:(DealModel*)dealModel
{
    
    NSMutableArray<DealModel>* array = [NSMutableArray<DealModel> new];
    
    [array addObject:dealModel];
    [self saveArrDealToRedeem:array];
}

-(void)deleteDealsToRedeem//delete when online and clear all local data
{
    [self.userDefaults setObject:nil forKey:REDEEM_KEY];
    
}

-(NSMutableArray<DealModel>*)arrDealToRedeem
{
    if (!_arrDealToRedeem) {
        
        
        NSData * data = [self.userDefaults objectForKey:REDEEM_KEY];
        
        NSMutableArray<DealModel>* arrayDealIDs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([Utils isArrayNull:arrayDealIDs])
        {
            return [NSMutableArray<DealModel> new];
        }
        else{
            return arrayDealIDs;
        }
    }
    
    return self.arrDealToRedeem;
}

-(void)saveArrDealToRedeem:(NSMutableArray<DealModel>*)arrDealToRedeem
{
    NSData * data = [self.userDefaults objectForKey:REDEEM_KEY];
    NSMutableArray<DealModel>* arrayDealIDs = [[NSKeyedUnarchiver unarchiveObjectWithData:data]mutableCopy];
    
    
    if ([Utils isArrayNull:arrayDealIDs]) {
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrDealToRedeem];
        [self.userDefaults setObject:encodedObject forKey:REDEEM_KEY];
        [self.userDefaults synchronize];
        
    }
    else{
        
        
        NSMutableArray<DealModel>* arrTemp = arrayDealIDs;
        
        [arrTemp addObjectsFromArray:arrDealToRedeem];
        
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrTemp];
        NSArray *arrayWithoutDuplicates = [orderedSet array];
        
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrayWithoutDuplicates];
        [self.userDefaults setObject:encodedObject forKey:REDEEM_KEY];
        [self.userDefaults synchronize];
        
        
        
        
        
    }
    
}

#pragma mark - Request Server

-(void)requestServerToRedeemVouchers:(NSArray<DealModel>*)array{
    
    if (self.isLoading) {
        return;
    }
    
    NSDictionary *dict = @{
                           @"token": [Utils getAppToken]
                           };
    
    //    user location     //
    CLLocation *userLocation = [[SearchManager Instance] getAppLocation];
    //    user location     //
    
    NSMutableArray* dictDeals = [NSMutableArray new];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    for (int i = 0; i < array.count; i++) {
        
        DealModel* model = array[i];
        NSDictionary *voucherDict = @{@"deal_id": model.dID?model.dID:@"",
                                      @"voucher_id": model.voucher_info.voucher_id?model.voucher_info.voucher_id:@"",
                                      @"datetime": [formatter stringFromDate:[[NSDate alloc] init]],
                                      @"lat": @(userLocation.coordinate.latitude),
                                      @"lng": @(userLocation.coordinate.longitude)
                                      };
        
        [dictDeals addObject:voucherDict];
        
    }
    
    
    NSMutableDictionary* finalDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    
    for (int i = 0; i<dictDeals.count; i++) {
        
        NSDictionary* tempDict = dictDeals[i];
        
        NSDictionary* appendDict = @{[NSString stringWithFormat:@"voucher_info[%d]",i] : tempDict};
        
        [finalDict addEntriesFromDictionary:appendDict];
        
    }
    
    self.isLoading = YES;
    
    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_PUT serverRequestType:ServerRequestTypePutRedeemVoucher parameter:finalDict appendString:nil success:^(id object) {
        
        [self.userDefaults setObject:nil forKey:REDEEM_KEY];
        [self.userDefaults synchronize];
        
        self.isLoading = NO;
        [LoadingManager hide];
        
    } failure:^(id object) {
        self.isLoading = NO;
        [LoadingManager hide];
    }];
}

// =============================================================  News Feed  =========================================================== //


+(void)saveNewsfeed:(NSMutableArray<CTFeedTypeModel>* )array
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:NEWS_FEED_KEY];
    
    if (![Utils isArrayNull:array]) {
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:array];
        [defaults setObject:encodedObject forKey:NEWS_FEED_KEY];
        [defaults synchronize];
        
        
    }
    else{
        
        SLog(@"%@",array);
    }
    
}

+(NSArray<CTFeedTypeModel>*)getNewsFeed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData * data = [defaults objectForKey:NEWS_FEED_KEY];
    
    NSArray<CTFeedTypeModel>* array;
    
    array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return array;
}
// =============================================================  News Feed  =========================================================== //

@end
