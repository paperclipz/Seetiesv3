//
//  PostsTableViewCell.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsTableViewCell : CommonTableViewCell
-(void)initData:(DraftModel*)model;

@property(nonatomic,copy)VoidBlock btnFollowBlock;
@property(nonatomic,copy)VoidBlock btnCollectionBlock;
@property(nonatomic,copy)VoidBlock btnCollectionOpenViewBlock;
@property(nonatomic,copy)VoidBlock btnUserProfileBlock;
@end
