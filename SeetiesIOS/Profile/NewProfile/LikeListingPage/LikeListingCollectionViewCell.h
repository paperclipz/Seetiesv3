//
//  LikeListingCollectionViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonCollectionViewCell.h"

@interface LikeListingCollectionViewCell : CommonCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
-(void)initData:(PhotoModel*)model;
-(void)setNoRoundBorder;

@end
