//
//  FilterModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 16/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterPriceModel.h"

typedef enum{
    SortTypeMostRecent = 1,
    SortTypeMostPopular = 2,
    SortTypeNearest = 3
} SortType;

@interface FilterModel : NSObject
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *filterId;
@property(nonatomic) BOOL isSelected;
@property(nonatomic) FilterPriceModel *filterPrice;
@property(nonatomic) SortType sortType;
@end
