//
//  SearchModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"

@protocol SearchModel


@end

@protocol SearchLocationModel


@end

@interface SearchModel : Model

@property(nonatomic,strong)NSArray<SearchLocationModel>* predictions;
@end


@interface SearchLocationModel : JSONModel
@property(nonatomic,strong)NSString* longDescription;
@property(nonatomic,strong)NSArray* terms;

@end
