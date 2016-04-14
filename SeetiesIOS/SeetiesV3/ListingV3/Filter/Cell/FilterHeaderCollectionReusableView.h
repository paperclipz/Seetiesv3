//
//  FilterHeaderCollectionReusableView.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 12/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCategoryModel.h"

@interface FilterHeaderCollectionReusableView : UICollectionReusableView
-(void)initHeaderData:(FilterCategoryModel*)filterCategory;
@end
