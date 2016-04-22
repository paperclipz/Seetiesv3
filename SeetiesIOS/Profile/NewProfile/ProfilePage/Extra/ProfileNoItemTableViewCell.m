//
//  ProfileNoItemTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileNoItemTableViewCell.h"

@interface ProfileNoItemTableViewCell()
// 0 collection || 1 post || 2 likes
@property (nonatomic,assign)int cellType;
@property (weak, nonatomic) IBOutlet UIImageView *ibImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@end
@implementation ProfileNoItemTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(int)getHeight
{
    return 120.0f;
}

-(void)initSelfView
{
        self.lblTitle.text = LocalisedString(@"There's nothing 'ere, yet.");
}

-(void)adjustRoundedEdge:(CGRect)frame
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, self.frame.size.height);
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:10.0f];
    
}

-(void)setViewType:(int)type{

    self.cellType = type;
    
    switch (self.cellType) {
            
        default:
        case 0:
            self.ibImage.image = [UIImage imageNamed:@"EmptyStateImg.png"];
            self.lblDesc.text = LocalisedString(@"No Collections");


            break;
            
        case 1:
            self.ibImage.image = [UIImage imageNamed:@"EmptyStateImg.png"];
            self.lblDesc.text = LocalisedString(@"Would you like to start a post?(:");

            break;
            
        case 2:
            self.ibImage.image = [UIImage imageNamed:@"EmptyStateImg.png"];
            self.lblDesc.text = LocalisedString(@"Check back soon!");


            break;
    }
    
    
    
}

@end
