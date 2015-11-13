//
//  ProfileModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "Model.h"
#import "DraftModel.h"


@interface ProfileModel : Model

@property(nonatomic,assign)int following_count;
@property(nonatomic,strong)NSString* location;

@property(nonatomic,assign)int follower_count;
@property(nonatomic,strong)NSString* username;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* profileDescription;
@property(nonatomic,strong)NSString* personal_link;
@property(nonatomic,strong)NSString* country;
@property(nonatomic,strong)NSArray* personal_tags;
@property(nonatomic,strong)NSString* wallpaper;
@property(nonatomic,strong)NSString* dob;
@property(nonatomic,strong)NSString* profile_photo_images;
@property(nonatomic,strong)NSString* gender;
@property(nonatomic,assign)BOOL following;
@property(nonatomic,strong)NSString* uid;

@end

@interface ProfilePostModel : Model


@property(nonatomic,strong)DraftsModel* userPostData;

@end

