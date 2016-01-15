//
//  FeedType_FollowingPostTblCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"
//typedef void (^PostIDBlock)(NSString *image);

@interface FeedType_FollowingPostTblCell : CommonTableViewCell
-(void)initData:(CTFeedTypeModel*)model;

@property(nonatomic,strong)VoidBlock btnCollectionDidClickedBlock;
@property(nonatomic,strong)VoidBlock btnCollectionQuickClickedBlock;
@property(nonatomic,strong)VoidBlock btnPostShareClickedBlock;

@end
