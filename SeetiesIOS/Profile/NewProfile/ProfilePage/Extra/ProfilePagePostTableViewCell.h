//
//  ProfilePagePostTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface ProfilePagePostTableViewCell : CommonTableViewCell
+(int)getHeight;
-(void)initData:(NSArray*)array;
@property(nonatomic,copy)IndexPathBlock didSelectAtIndexPathBlock;
@end
