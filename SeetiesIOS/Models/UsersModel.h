//
//  UsersModel.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 21/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "JSONModel.h"

@protocol UserModel
@end


@interface UserModel : JSONModel

@property (nonatomic,strong)NSString* userUID;
@property (nonatomic,strong)NSString* username;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* location;
@property (nonatomic,strong)NSString* userDesc;
@property (nonatomic,strong)NSString* profile_photo;
@property (nonatomic,assign)BOOL following;

@end

@interface UsersModel : Model

@property(nonatomic,strong)NSArray<UserModel >* follower;
@property(nonatomic,strong)NSArray<UserModel >* following;
@end
