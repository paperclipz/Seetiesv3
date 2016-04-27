//
//  SuggestedPlaceModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 3/18/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Location @end
@interface SuggestedPlaceModel : PaginationModel

@property(nonatomic,strong)NSArray<Location>* result;

@end
