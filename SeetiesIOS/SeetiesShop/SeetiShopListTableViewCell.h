//
//  SeetiShopListTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/10/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewCell.h"

@interface SeetiShopListTableViewCell : CommonTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

-(void)setIsOpen:(BOOL)isOpen;

@end
