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

@interface PromoPopOutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,copy)VoidBlock updateFrame;

-(void)setViewType:(PopOutViewType)viewType;

@end
