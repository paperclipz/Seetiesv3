//
//  PlaceModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/1/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "Model.h"

@interface PlaceModel : Model

@property(nonatomic,strong)NSString* longtitude;
@property(nonatomic,strong)NSString* featured_area_id;
@property(nonatomic,strong)NSString* latitude;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* place_id;
@property(nonatomic,assign)BOOL has_featured_deals;

@end
