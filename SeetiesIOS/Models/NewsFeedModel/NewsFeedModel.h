//
//  NewsFeedModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PaginationModel.h"

@protocol NewsFeedModel
@end

@interface NewsFeedModel : JSONModel

@property(nonatomic,strong)Location* location;
@property(nonatomic,strong)NSString* place_name;
@property(nonatomic,strong)NSString* place_formatted_address;
@property(nonatomic,strong)NSString* seetishop_id;
@property(nonatomic,assign)int collection_count;
@property(nonatomic,assign)int total_comments;
@property(nonatomic,assign)BOOL like;
@property(nonatomic,strong)ProfileModel* user_info;

@property(nonatomic,assign)FeedType feedType;//non json attributes

@end


@interface NewsFeedModels : PaginationModel

@property(nonatomic,strong)NSArray<NewsFeedModel>* items;

@end
