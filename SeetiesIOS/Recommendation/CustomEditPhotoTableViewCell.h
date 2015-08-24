//
//  CustomEditPhotoTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "BMXSwipableCell.h"



@interface CustomEditPhotoTableViewCell : BMXSwipableCell

-(void)initData:(UIImage*)image description:(NSString*)desc;
- (void)configureCellForItem:(EditPhotoModel*)item;
@property(nonatomic,copy)IDBlock deleteBlock;
@property(nonatomic,copy)IDBlock moreBlock;

@end