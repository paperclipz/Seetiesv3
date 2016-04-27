//
//  FriendSuggestionModel.h
//  SeetiesIOS
//
//  Created by Lai on 13/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol FriendSuggestionDetailModel

@end

@interface FriendSuggestionModel : JSONModel

@property(nonatomic, assign) int total_page;
@property(nonatomic, assign) int page;
@property(nonatomic, strong) NSArray<FriendSuggestionDetailModel>* result;

@end

@interface FriendSuggestionDetailModel : JSONModel

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *profile_photo;

@end