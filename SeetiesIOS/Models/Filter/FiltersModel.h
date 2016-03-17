//
//  FiltersModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 15/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterPriceModel.h"
#import "FilterCategoryModel.h"

@protocol FilterCategoryModel

@end

typedef enum{
    FilterViewTypeVoucher,
    FilterViewTypeShop,
    FilterViewTypeCollection
} FilterViewType;

@interface FiltersModel : NSObject
@property(nonatomic) NSMutableArray<FilterCategoryModel> *filterCategories;
@property(nonatomic) FilterViewType filterViewType;
@end
