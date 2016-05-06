//
//  DealRedeemViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/29/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealManager.h"

@protocol DealRedeemDelegate <NSObject>

-(void)onDealRedeemed:(DealModel*)dealModel;

@end

@interface DealRedeemViewController : CommonViewController
@property id<DealRedeemDelegate> dealRedeemDelegate;
@property(nonatomic,assign)BOOL isOffline;
-(void)setDealModel:(DealModel *)dealModel;

@end
