//
//  InstagramModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/27/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface InstagramModel : JSONModel

@property(nonatomic,strong)NSString* access_token;
@property(nonatomic,strong)NSString* username;
@property(nonatomic,strong)NSString* profile_picture;
@property(nonatomic,strong)NSString* full_name;

@property(nonatomic,strong)NSString* userID;

@end
