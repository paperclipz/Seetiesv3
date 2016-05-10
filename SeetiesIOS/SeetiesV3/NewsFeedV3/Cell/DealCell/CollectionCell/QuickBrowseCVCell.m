//
//  QuickBrowseCVCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/20/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "QuickBrowseCVCell.h"
@interface QuickBrowseCVCell()
@property (weak, nonatomic) IBOutlet UIView *ibBorderView;

@end

@implementation QuickBrowseCVCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [Utils setRoundBorder:self.ibBorderView color:[UIColor clearColor] borderRadius:5.0f];

}

@end
