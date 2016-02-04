//
//  DealsModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 03/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DealModel.h"
#import "PaginationModel.h"

@protocol DealModel

@end

@interface DealsModel : PaginationModel
@property(nonatomic, strong) NSArray<DealModel> *deals;
@end
