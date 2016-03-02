//
//  ProfilePageCollectionTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface ProfilePageCollectionTableViewCell : CommonTableViewCell
+(int)getHeight;
-(void)initData:(CollectionModel*)model;

@property(nonatomic,copy)VoidBlock btnEditClickedBlock;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfCollection;
-(void)setFollowButtonSelected:(BOOL)selected button:(UIButton*)button;

@property(nonatomic,copy)VoidBlock btnFollowBlock;
@property(nonatomic,copy)VoidBlock btnShareClicked;

@end
