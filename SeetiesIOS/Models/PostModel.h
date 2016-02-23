//
//  CollectionModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"
#import "ProfileModel.h"

@class ProfileModel;
@protocol CollectionModel

@end



//@interface PostModel : JSONModel
//
//@property(nonatomic,strong)NSString* imageURL;
//@property(nonatomic,strong)NSString* name;
//@property(nonatomic,strong)NSString* distance;
//@property(nonatomic,strong)NSArray* category;
//@property(nonatomic,strong)Location* location;
//@property(nonatomic,strong)NSArray<PhotoModel>* photos;
//@property(nonatomic,strong)NSString* collection_note;
//@property(nonatomic,strong)NSString* post_id;
//
//
//@end

@interface CollectionModel : JSONModel
// in future change to draft model
@property(nonatomic,strong)NSArray<DraftModel>* arrayPost;
@property(nonatomic,strong)NSArray<DraftModel>* arrayFollowingCollectionPost;

@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* postDesc;
@property(nonatomic,assign)BOOL isPrivate;
@property(nonatomic,strong)NSString* collection_id;
@property(nonatomic,assign)BOOL is_default;
@property(nonatomic,strong)NSMutableArray* tagList;
@property(nonatomic,assign)int total_page;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int total_posts;
@property(nonatomic,strong)NSMutableArray* deleted_posts;
@property(nonatomic,assign)int collection_posts_count;
@property(nonatomic,assign)int new_collection_posts_count;
@property(nonatomic,assign)BOOL following;
@property(nonatomic,strong)ProfileModel* user_info;

@property(nonatomic,strong)NSString* author_uid;

-(void)process;
@end

@interface CollectionsModel : Model

@property(nonatomic,strong)NSArray<CollectionModel>* arrCollections;
@property(nonatomic,strong)NSArray<CollectionModel>* arrSuggestedCollection;
@property(nonatomic,assign)int total_page;
@property(nonatomic,assign)int total_result;
@property(nonatomic,assign)int page;

@property(nonatomic,strong)NSString* next;
@property(nonatomic,strong)NSString* previous;
@property(nonatomic,assign)int offset;
@property(nonatomic,assign)int total_collections;
@property(nonatomic,assign)int limit;



@end

