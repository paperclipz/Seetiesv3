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
@property(nonatomic,strong)NSString* place_id;
@property(nonatomic,strong)NSString* reference;
@property(nonatomic,strong)NSString<Optional>* latitude;
@property(nonatomic,strong)NSString<Optional>* longitude;

@end
