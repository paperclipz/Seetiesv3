//
//  DraftModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/10/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"
#import "OpeningPeriodModel.h"
#import "Location.h"

@class ProfileModel;

@protocol PhotoModel
@end

@protocol DraftModel
@end


@interface Post : NSObject
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSString* message;
@property(nonatomic,strong)NSString* language;

@end

@interface DraftModel : Model

@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)ProfileModel* user_info;
@property(nonatomic,strong)NSString* seetishop_id;

@property(nonatomic,assign)int collection_count;
@property(nonatomic,assign)int total_comments;
@property(nonatomic,strong)NSString* image;
@property(nonatomic,strong)NSString* postDescription;
@property(nonatomic,strong)NSDictionary* contents;
@property(nonatomic,strong)NSArray* arrCustomPost;//using content_languages to process
@property(nonatomic,strong)NSArray* arrPost;//using title key to process
@property(nonatomic,strong)NSArray<PhotoModel>* arrPhotos;
@property(nonatomic,strong)NSString* link;
@property(nonatomic,strong)NSString* post_id;
@property(nonatomic,strong)NSArray* category;
@property(nonatomic,strong)NSString* collection_note;
@property(nonatomic,strong)NSString* view_count;
@property(nonatomic,strong)NSArray* content_languages;
@property(nonatomic,assign)BOOL like;
@property(nonatomic,strong)NSString* collect;

/*Location*/
@property(nonatomic,strong)NSString* place_name;

@property(nonatomic,strong)Location* location;
@property(nonatomic,strong)NSString* distance;
@property(nonatomic,strong)NSString* place_formatted_address;
-(NSString*)getPostDescription;

-(void)process;
-(void)customProcess;

@end

@interface DraftsModel : Model

@property(nonatomic,strong)NSArray<DraftModel>* posts;
@property(nonatomic,assign)int list_size;
@property(nonatomic,assign)int total_posts;
@property(nonatomic,assign)int total_page;
@property(nonatomic,assign)int page;

@property(nonatomic,strong)NSString* next;
@property(nonatomic,strong)NSString* previous;
@property(nonatomic,assign)int offset;
@property(nonatomic,assign)int limit;

-(void)process;

@end


