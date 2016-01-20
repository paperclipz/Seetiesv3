//
//  FeedType_SuggestionFetureTblCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedType_SuggestionFetureTblCell : CommonTableViewCell
-(void)initData:(NSArray<ProfileModel*>*)array;

@property(nonatomic,copy)ProfileBlock didSelectprofileBlock;
@end
