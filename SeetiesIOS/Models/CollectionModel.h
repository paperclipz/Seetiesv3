//
//  CollectionModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"


@protocol CollectionModel

@end

@interface CollectionModel : JSONModel

@property(nonatomic,strong)NSString* imageURL;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* distance;


@property(nonatomic,strong)NSArray* category;
@property(nonatomic,strong)Location* location;
@property(nonatomic,strong)NSArray<PhotoModel>* photos;
@property(nonatomic,strong)NSString* collection_note;



@end

@interface CollectionModels : Model

@property(nonatomic,strong)NSArray<CollectionModel>* arrayPost;


@end

