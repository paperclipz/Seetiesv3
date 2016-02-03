//
//  PlacesModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/1/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "Model.h"
#import "PlaceModel.h"

@protocol PlaceModel
@end

@interface PlacesModel : Model
@property(nonatomic,strong)NSMutableArray<PlaceModel>* places;

@property(nonatomic,strong)NSString* area_name;

@end
