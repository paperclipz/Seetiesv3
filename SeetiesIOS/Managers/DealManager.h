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

-(void)setCollectedDeal:(NSString*)dealId forDeal:(DealModel*)dealModel;

-(BOOL)checkIfDealIsCollected:(NSString*)dealId;

-(DealModel*)getCollectedDeal:(NSString*)dealId;

-(void)removeAllCollectedDeals;

-(void)removeCollectedDeal:(NSString*)dealId;

-(void)saveCollectedDealsToDb;

-(void)setAllCollectedDeals:(DealsModel*)dealsModel;
@end
