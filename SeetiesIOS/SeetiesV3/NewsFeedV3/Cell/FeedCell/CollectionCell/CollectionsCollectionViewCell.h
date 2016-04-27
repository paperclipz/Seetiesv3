//
//  CollectionsCollectionViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/11/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionsCollectionViewCell : CommonCollectionViewCell

-(void)initData:(CollectionModel*)model;

@property(nonatomic,copy)VoidBlock btnEditClickedBlock;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property(nonatomic,copy)VoidBlock btnFollowBlock;
@property(nonatomic,copy)VoidBlock btnShareClicked;

@end
