//
//  SeShopDetailTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface SeShopDetailTableViewCell : CommonTableViewCell
+(int)getHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

@end
