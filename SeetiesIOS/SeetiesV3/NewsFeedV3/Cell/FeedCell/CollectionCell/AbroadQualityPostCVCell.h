//
//  AbroadQualityPostCVCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbroadQualityPostCVCell : CommonCollectionViewCell
-(void)initData:(DraftModel*)model;
@property(nonatomic,strong)ProfileBlock btnProfileClickedBlock;

@end
