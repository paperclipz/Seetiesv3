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

-(void)setCustomIndexPath:(NSIndexPath *)indexPath
{
    int counter = indexPath.row%3;
    
    UIColor* color;
    switch (counter) {
        default:
            
        case 0:
            color = [UIColor colorWithRed:237.0f/255.0f green:116.0f/255.0f blue:170.0f/255.0f alpha:1];
            
            break;
            
        case 1:
            color = [UIColor colorWithRed:233.0f/255.0f green:204.0f/255.0f blue:68.0f/255.0f alpha:1];
            
            break;
            
            
        case 2:
            color = [UIColor colorWithRed:87.0f/255.0f green:215.0f/255.0f blue:224.0f/255.0f alpha:1];
            
            break;
    }
    
    self.ibImageView.backgroundColor = color;
}

@end
