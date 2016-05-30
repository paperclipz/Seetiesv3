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
@property (nonatomic,readonly) NSMutableArray<DealModel>* arrDealToRedeem;

-(void)uploadDealToRedeem:(VoidBlock)completionBlock;
-(void)addDealToRedeem:(DealModel*)dealModel;
-(void)deleteDealsToRedeem;


//+(NSArray<CTFeedTypeModel>*)getNewsFeed;
//+(void)saveNewsfeed:(NSMutableArray<CTFeedTypeModel>* )array;

@end
