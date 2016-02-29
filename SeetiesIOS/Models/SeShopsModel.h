//
//  SeShopsModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 29/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PaginationModel.h"

@protocol SeShopDetailModel

@end

@interface SeShopsModel : PaginationModel

@property(nonatomic,strong)NSArray<SeShopDetailModel>* shops;
@property(nonatomic,assign)int total_shops;
@property(nonatomic,assign)int page;

@end
