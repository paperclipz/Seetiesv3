//
//  DealManager.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 16/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealManager : NSObject
+(id)Instance;

-(void)setCollectedDeal:(NSString*)dealId withVoucherId:(NSString*)voucherId;

-(BOOL)checkIfDealIsCollected:(NSString*)dealId;

-(NSString*)getCollectedDealVoucherId:(NSString*)dealId;

-(void)removeAllCollectedDeals;

-(void)removeCollectedDeal:(NSString*)dealId;

-(void)saveCollectedDealsToDb;

-(void)setAllCollectedDeals:(DealsModel*)dealsModel;

-(int)getWalletCount;

-(void)setWalletCount:(int)count;


@end
