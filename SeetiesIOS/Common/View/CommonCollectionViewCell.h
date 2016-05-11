//
//  CommonCollectionViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonCollectionViewCell : UICollectionViewCell
-(void)initSelfView;
- (id)initWithFrame:(CGRect)frame name:(NSString*)name;

-(void)setCustomIndexPath:(NSIndexPath*)indexPath;
@end
