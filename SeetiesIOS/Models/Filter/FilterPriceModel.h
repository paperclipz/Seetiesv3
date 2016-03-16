//
//  FilterPriceModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 15/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterPriceModel : NSObject
@property(nonatomic) NSString *currency;
@property(nonatomic) int min;
@property(nonatomic) int max;
@property(nonatomic) int interval;
@property(nonatomic) int selectedMin;
@property(nonatomic) int selectedMax;
@end
