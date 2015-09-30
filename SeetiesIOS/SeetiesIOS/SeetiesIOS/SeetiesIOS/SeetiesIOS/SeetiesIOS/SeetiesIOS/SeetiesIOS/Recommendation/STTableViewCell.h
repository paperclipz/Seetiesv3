//
//  STTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STTableViewCell : CommonTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

@end
