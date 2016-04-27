//
//  CustomItemSource.h
//  SeetiesIOS
//
//  Created by Lai on 11/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomItemSource : NSObject <UIActivityItemSource>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *shareID;
@property (nonatomic, strong) NSString* postImageURL;
@property (nonatomic, assign) ShareType shareType;
@property (nonatomic, strong) NSString *postID;

@property (nonatomic, strong) FBSDKShareLinkContent *fbShareContent;

//- (id)initWithData:(NSDictionary *)data;

@end
