//
//  ShopTableViewCell.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 07/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewCell.h"

@interface ShopTableViewCell : CommonTableViewCell
@property (weak, nonatomic) IBOutlet UIView *ibDealView;

+(float)getHeightWithoutImage;

@end
