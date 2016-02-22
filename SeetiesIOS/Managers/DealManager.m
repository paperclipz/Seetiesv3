//
//  DealManager.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 16/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealManager.h"

@interface DealManager()
@property (nonatomic) NSMutableDictionary *dealsDict;
@property (nonatomic) NSUserDefaults *userDefaults;
@end

@implementation DealManager

+(id)Instance{
    static DealManager *dealManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dealManager = [[self alloc] init];
    });
    return dealManager;
}

-(id)init{
    if (self = [super init]) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _dealsDict = [[self.userDefaults objectForKey:@"DealsDictionary"] mutableCopy];
        if (!_dealsDict) {
            _dealsDict = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

-(void)setCollectedDeal:(NSString*)dealId forDeal:(DealModel*)dealModel{
    [self.dealsDict setObject:[dealModel toJSONString] forKey:dealId];
    [self saveCollectedDealsToDb];
}

-(BOOL)checkIfDealIsCollected:(NSString*)dealId{
    return [self.dealsDict objectForKey:dealId] == nil? NO : YES;
}

-(DealModel*)getCollectedDeal:(NSString*)dealId{
    NSString *jsonString = [self.dealsDict objectForKey:dealId];
    return [[DealModel alloc] initWithString:jsonString error:nil];
}

-(void)removeAllCollectedDeals{
    [self.dealsDict removeAllObjects];
    [self saveCollectedDealsToDb];
}

-(void)removeCollectedDeal:(NSString*)dealId{
    [self.dealsDict removeObjectForKey:dealId];
    [self saveCollectedDealsToDb];
}

-(void)saveCollectedDealsToDb{
    [self.userDefaults setObject:self.dealsDict forKey:@"DealsDictionary"];
}

-(void)setAllCollectedDeals:(DealsModel*)dealsModel{
    for (DealModel *dealModel in dealsModel.deals) {
        if (![Utils isStringNull:dealModel.voucher_info.voucher_id]) {
            [self.dealsDict setObject:[dealModel toJSONString] forKey:dealModel.dID];
        }
    }
    [self saveCollectedDealsToDb];
}

@end
