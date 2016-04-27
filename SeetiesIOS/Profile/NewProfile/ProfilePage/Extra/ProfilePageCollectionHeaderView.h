//
//  ProfilePageCollectionHeaderView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfilePageCollectionHeaderView : CommonView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (copy, nonatomic) VoidBlock btnSeeAllClickedBlock;
@property (weak, nonatomic) IBOutlet UIImageView *ibBackgroundView;

+(int)getHeight;
//-(void)adjustRoundedEdge:(CGRect)frame;
-(void)setHeaderViewWithCount:(int)count type:(int)type;

@end
