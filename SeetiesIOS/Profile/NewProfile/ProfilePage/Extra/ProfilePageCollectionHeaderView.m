//
//  ProfilePageCollectionHeaderView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfilePageCollectionHeaderView.h"
@interface ProfilePageCollectionHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageIcon;
@end
@implementation ProfilePageCollectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnTitleClicked:(id)sender {
    
    if (_btnSeeAllClickedBlock) {
        self.btnSeeAllClickedBlock();
    }
}
-(void)initSelfView
{
  

}
+(int)getHeight
{
    return 71.0f;
}

-(void)adjustRoundedEdge:(CGRect)frame
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, self.frame.size.height);

    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self.ibBackgroundView setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10.0f];
    
}
//type 1 collection type 2 post type 3 likes
-(void)setHeaderViewWithCount:(int)count type:(int)type
{
    switch (type) {
        case 1:
            self.lblTitle.text = @"Collections";
            self.lblNumberOfCollection.text = [NSString stringWithFormat:@"%d collections",count];
            self.ibImageIcon.image = [UIImage imageNamed:@"NewCollectionsIcon.png"];
            break;
        case 2:
            self.lblTitle.text = @"Posts";

            self.lblNumberOfCollection.text = [NSString stringWithFormat:@"%d posts",count];
            self.ibImageIcon.image = [UIImage imageNamed:@"NewPostsIcon.png"];

            break;
            
        case 3:
            self.lblTitle.text = @"Likes";

            self.lblNumberOfCollection.text = [NSString stringWithFormat:@"%d likes",count];
            self.ibImageIcon.image = [UIImage imageNamed:@"NewLikesIcon.png"];

            break;
        default:
            break;
    }
   

}
@end
