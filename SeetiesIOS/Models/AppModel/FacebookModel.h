//
//  FacebookModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/6/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookModel : JSONModel
@property(nonatomic,strong)NSString* uID;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* userProfileImageURL;
@property(nonatomic,strong)NSString* email;
@property(nonatomic,strong)NSString* gender;
@property(nonatomic,strong)NSString* dob;
@property(nonatomic,strong)NSString* userName;
@property(nonatomic,strong)NSString* userFullName;
@property(nonatomic,strong)NSString* fbToken;

@end

