//
//  DraftModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/10/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"



@protocol PhotoModel

@end

@protocol Location

@end
@protocol DraftModel

@end

@interface Post : NSObject
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSString* message;

@end

@interface Location : NSObject
@property(nonatomic,strong)NSString* route;
@property(nonatomic,strong)NSString* lat;
@property(nonatomic,strong)NSString* lng;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* place_id;
@property(nonatomic,strong)NSString* opening_hours;
@property(nonatomic,strong)NSString* contact_no;
@property(nonatomic,strong)NSString* link;

@end

@interface PhotoModel : JSONModel

@property(nonatomic,strong)NSString* tags;
@property(nonatomic,strong)NSString* photo_id;
@property(nonatomic,strong)NSString* caption;
@property(nonatomic,assign)int position;
@property(nonatomic,strong)NSString* imageURL;
@property(nonatomic,strong)UIImage* image;

@end

@interface DraftModel : Model

@property(nonatomic,strong)NSArray* arrPost;
@property(nonatomic,strong)NSString* place_name;
@property(nonatomic,strong)NSString* formatted_address;
@property(nonatomic,strong)NSArray<PhotoModel>* arrPhotos;
@property(nonatomic,strong)NSString* link;
@property(nonatomic,strong)NSString* post_id;




//@property(nonatomic,strong)Location* location;

@end

@interface DraftsModel : Model

@property(nonatomic,strong)NSArray<DraftModel>* posts;
-(void)process;

@end


