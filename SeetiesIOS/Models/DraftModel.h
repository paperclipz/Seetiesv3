//
//  DraftModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/10/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"
#import "OpeningPeriodModel.h"




@protocol PhotoModel
@end
@protocol Location
@end
@protocol DraftModel
@end

@interface Post : NSObject
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSString* message;
@property(nonatomic,strong)NSString* language;

@end

@interface Location : JSONModel
@property(nonatomic,strong)NSString* lat;
@property(nonatomic,strong)NSString* lng;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* place_id;
@property(nonatomic,strong)OpeningPeriodModels* opening_hours;
@property(nonatomic,strong)NSString* contact_no;
@property(nonatomic,strong)NSString* link;
@property(nonatomic,strong)NSString* distance;
@property(nonatomic,strong)NSString* reference;
@property(nonatomic,strong)NSString* formatted_address;
@property(nonatomic,strong)NSDictionary* expense;

//below here is all inside address_components
@property(nonatomic,strong)NSString* administrative_area_level_1;
@property(nonatomic,strong)NSString* country;
@property(nonatomic,strong)NSString* locality;
@property(nonatomic,strong)NSString* political;
@property(nonatomic,strong)NSString* postal_code;
@property(nonatomic,strong)NSString* route;
@property(nonatomic,strong)NSString* sublocality;

@end

@interface PhotoModel : JSONModel

@property(nonatomic,strong)NSString* tags;
@property(nonatomic,strong)NSString* photo_id;
@property(nonatomic,strong)NSString* caption;
@property(nonatomic,assign)int position;
@property(nonatomic,strong)NSString* imageURL;
@property(nonatomic,strong)UIImage* image;
-(id) copyWithZone: (NSZone *) zone;

@end


@interface DraftModel : Model

@property(nonatomic,strong)NSArray* arrPost;
@property(nonatomic,strong)NSString* place_name;

@property(nonatomic,strong)NSArray<PhotoModel>* arrPhotos;
@property(nonatomic,strong)NSString* link;
@property(nonatomic,strong)NSString* post_id;
@property(nonatomic,strong)Location* location;
@property(nonatomic,strong)NSArray* category;

@property(nonatomic,strong)NSString* imageURL;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* distance;
@property(nonatomic,strong)NSString* collection_note;

-(void)process;
@end

@interface DraftsModel : Model

@property(nonatomic,strong)NSArray<DraftModel>* posts;
@property(nonatomic,assign)int list_size;
@property(nonatomic,assign)int total_posts;

-(void)process;

@end


