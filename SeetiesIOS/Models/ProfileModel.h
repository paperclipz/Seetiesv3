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


@end

@interface ProfilePostModel : Model


@property(nonatomic,strong)DraftsModel* userPostData;

@end

