//
//  FilterCurrencyModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 16/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FilterCurrencyModel : JSONModel
@property(nonatomic,strong) NSString *currency;
@property(nonatomic,strong) NSString *currency_symbol;
@property(nonatomic,assign) int min;
@property(nonatomic,assign) int max;
@property(nonatomic,assign) int interval;
@end
