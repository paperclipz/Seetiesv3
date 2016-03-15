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
#import "ActionSheetPicker.h"

typedef enum{
    PopOutViewTypeEnterPromo,
    PopOutViewTypeRedemptionSuccessful,
    PopOutViewTypeChooseShop,
    PopOutViewTypeChangeVerifiedPhone,
    PopOutViewTypeEnterPhone,
    PopOutViewTypeConfirmPhone,
    PopOutViewTypeEnterVerification,
    PopOutViewTypeVerified,
    PopOutViewTypeError,
    PopOutViewTypeQuit
} PopOutViewType;

typedef enum{
    PopOutConditionNormal,
    PopOutConditionChooseShopOnly,
    PopOutConditionVerifyPhoneNumber
}PopOutCondition;

@protocol PromoPopOutDelegate <NSObject>
@optional
-(void)chooseShopConfirmClicked:(DealModel*)dealModel forShop:(SeShopDetailModel*)shopModel;
-(void)viewDealDetailsClicked:(DealModel*)dealModel;
-(void)promoHasBeenRedeemed:(DealModel*)dealModel;
@end

@interface PromoPopOutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property(nonatomic,copy)VoidBlock updateFrame;
@property id<PromoPopOutDelegate> promoPopOutDelegate;

-(void)setViewType:(PopOutViewType)viewType;
-(void)setPopOutCondition:(PopOutCondition)popOutCondition;
-(void)setShopArray:(NSArray<SeShopDetailModel>*)shopArray;
-(void)setDealModel:(DealModel *)dealModel;
-(void)setSelectedCountryCode:(NSString *)selectedCountryCode;
-(void)setEnteredPhoneNumber:(NSString *)enteredPhoneNumber;
-(void)setEnteredPromoCode:(NSString *)enteredPromoCode;
-(void)setSelectedShop:(SeShopDetailModel *)selectedShop;
@end
