//
//  OfflineManager.h
//  Seeties
//
//  Created by Evan Beh on 05/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OfflineManager : NSObject

+(id)Instance;

// ========== Deal model ========== //
@property (nonatomic,readonly) NSMutableArray<DealModel>* arrDealToRedeem;

-(void)uploadDealToRedeem;

-(void)addDealToRedeem:(DealModel*)dealModel;

-(void)deleteDealsToRedeem;
// ========== Deal model ========== //


@end
