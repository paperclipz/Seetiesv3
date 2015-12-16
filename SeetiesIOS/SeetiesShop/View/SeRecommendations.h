//
//  SeRecommendations.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 01/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BtnPostsDetailBlock)(NSString * idn);
typedef void (^BtnPostsSeeAllBlock)(NSString * idn);

@interface SeRecommendations : CommonView
@property(nonatomic,copy)BoolBlock viewDidFinishLoadBlock;
@property(nonatomic,copy)BtnPostsDetailBlock btnPostsDetailClickedBlock;
@property(nonatomic,copy)BtnPostsSeeAllBlock btnPostsSeeAllClickedBlock;
-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID;
@end
