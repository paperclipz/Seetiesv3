//
//  FeedType_CollectionSuggestedTblCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/11/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"

typedef void(^CollectionBlock) (CollectionModel* model);

@interface FeedType_CollectionSuggestedTblCell : CommonTableViewCell
-(void)initData:(NSArray<CollectionModel>*)array;

@property(nonatomic,copy)VoidBlock btnSeeAllSuggestedCollectionClickBlock;
@property(nonatomic,copy)CollectionBlock didSelectCollectionBlock;

@end
