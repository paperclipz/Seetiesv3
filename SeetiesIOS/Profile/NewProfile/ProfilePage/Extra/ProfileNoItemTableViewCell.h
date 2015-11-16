//
//  ProfileNoItemTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface ProfileNoItemTableViewCell : CommonTableViewCell
+(int)getHeight;
-(void)adjustRoundedEdge:(CGRect)frame;
-(void)setViewType:(int)type;

@end
