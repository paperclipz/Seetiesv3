//
//  PostDetailModel.h
//  Seeties
//
//  Created by Lai on 30/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "UsersModel.h"

@protocol LikeDetailModel <NSObject>

@end

@protocol CommentDetailModel <NSObject>

@end

@interface PostDetailModel : JSONModel

@end

@interface PostDetailLikeModel : JSONModel

@property (assign, nonatomic) int like_count;
@property (assign, nonatomic) int list_size;
@property (assign, nonatomic) int total_page;
@property (strong, nonatomic) NSArray<LikeDetailModel> *like_list;

@end

@interface LikeDetailModel : JSONModel

@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *following;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *profile_photo;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *name;

//@property (strong, nonatomic) NSArray *profile_photo_images;

@end

@interface PostDetailCommentModel : JSONModel

@property (strong, nonatomic) NSString *total_comments;
@property (strong, nonatomic) NSArray<CommentDetailModel> *comments;

@end

@interface CommentDetailModel : JSONModel

@property (strong, nonatomic) NSString *comment_id;
@property (strong, nonatomic) NSString *post_id;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) UserModel *author_info;

@end
