//
//  FilterCategoryModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 15/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterModel.h"

@protocol FilterModel

@end

typedef enum{
    FilterTypeSort,
    FilterTypeCat,
    FilterTypePrice,
    FilterTypeIsOpen
}FilterType;

@interface FilterCategoryModel : NSObject
@property(nonatomic) NSString *categoryName;
@property(nonatomic) NSMutableArray<FilterModel> *filtersArray;
@property(nonatomic) FilterType filterCategoryType;

@end
