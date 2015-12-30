//
//  SeDealsTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/2/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeDealsTableViewCell : CommonTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
+(float)getHeight;

@end
