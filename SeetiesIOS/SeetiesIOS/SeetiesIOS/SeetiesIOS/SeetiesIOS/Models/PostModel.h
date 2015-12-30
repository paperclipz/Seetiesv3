//
//  CollectionModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"


@protocol PostModel

@end

@interface PostModel : JSONModel

@property(nonatomic,strong)NSString* imageURL;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* distance;


@property(nonatomic,strong)NSArray* category;
@property(nonatomic,strong)Location* location;
@property(nonatomic,strong)NSArray<PhotoModel>* photos;
@property(nonatomic,strong)NSString* collection_note;
@property(nonatomic,strong)NSString* post_id;



@end

@interface CollectionModel : Model

@property(nonatomic,strong)NSArray<PostModel>* arrayPost;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* postDesc;
@property(nonatomic,assign)BOOL isPrivate;
@property(nonatomic,strong)NSString* collection_id;
@property(nonatomic,assign)BOOL is_default;





@end

