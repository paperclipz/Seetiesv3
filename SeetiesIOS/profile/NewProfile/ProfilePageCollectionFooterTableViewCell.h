//
//  ProfilePageCollectionFooterTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface ProfilePageCollectionFooterTableViewCell : CommonTableViewCell
+(int)getHeight;
-(void)adjustRoundedEdge:(CGRect)frame;
@end
