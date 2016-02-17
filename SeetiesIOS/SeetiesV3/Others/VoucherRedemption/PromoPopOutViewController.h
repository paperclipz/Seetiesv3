//
//  PromoCodeViewController.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 26/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "STPopup.h"
#import "PromoOutletCell.h"

typedef enum{
    EnterPromoViewType,
    RedemptionSuccessfulViewType,
    ChooseShopViewType,
    EnterPhoneViewType,
    EnterVerificationViewType,
    VerifiedViewType,
    ErrorViewType,
    QuitViewType
} PopOutViewType;

typedef enum{
    NormalPopOutCondition,
    ChooseShopOnlyPopOutCondition
}PopOutCondition;

@protocol PromoPopOutDelegate <NSObject>
@optional
-(void)chooseShopConfirmClicked:(DealModel*)dealModel forShop:(SeShopDetailModel*)shopModel;
@end

@interface PromoPopOutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,copy)VoidBlock updateFrame;
@property id<PromoPopOutDelegate> promoPopOutDelegate;

-(void)setViewType:(PopOutViewType)viewType;
-(void)setPopOutCondition:(PopOutCondition)popOutCondition;
-(void)setShopArray:(NSArray*)shopArray;
-(void)setDealModel:(DealModel *)dealModel;
@end
