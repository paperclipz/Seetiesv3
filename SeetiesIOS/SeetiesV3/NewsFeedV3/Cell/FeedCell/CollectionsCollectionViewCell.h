//
//  CollectionsCollectionViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/11/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionsCollectionViewCell : CommonCollectionViewCell
+(int)getHeight;
-(void)initData:(CollectionModel*)model profileType:(ProfileViewType)type;

@property(nonatomic,copy)VoidBlock btnEditClickedBlock;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfCollection;
-(void)setFollowButtonSelected:(BOOL)selected button:(UIButton*)button;

@property(nonatomic,copy)VoidBlock btnFollowBlock;
@property(nonatomic,copy)VoidBlock btnShareClicked;

@end
