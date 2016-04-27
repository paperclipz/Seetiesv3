//
//  ShopTableViewCell.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 07/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewCell.h"

typedef void (^DealBlock)(DealModel* model);


@interface ShopTableViewCell : CommonTableViewCell
@property (weak, nonatomic) IBOutlet UIView *ibDealView;
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constBottomHeight;
@property (copy, nonatomic) DealBlock didSelectDealBlock;

-(void)initData:(SeShopDetailModel*)model;

@end
