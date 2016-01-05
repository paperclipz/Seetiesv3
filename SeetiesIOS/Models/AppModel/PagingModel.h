//
//  PagingModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PagingModel : JSONModel

@property(nonatomic,strong)NSString* next;
@property(nonatomic,strong)NSString* previous;
@end
