//
//  SeShopFeatureTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewCell.h"

@interface SeShopFeatureTableViewCell : CommonTableViewCell
+(float)getHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end
