//
//  PhotoCVCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCVCell : CommonCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

-(void)initData:(DealModel*)model;

@end