//
//  PaginationModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PagingModel.h"

@interface PaginationModel : JSONModel
@property(nonatomic,strong)PagingModel* paging;
@property(nonatomic,assign)int offset;
@property(nonatomic,assign)int limit;

@end
