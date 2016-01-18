//
//  FeedType_FollowingCollectionTblCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedType_FollowingCollectionTblCell : CommonTableViewCell
-(void)initData:(CollectionModel*)model;

@property(nonatomic,copy)VoidBlock btnShareCollectionClickedBlock;
@end
