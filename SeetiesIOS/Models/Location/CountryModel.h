//
//  CountryModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/1/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "PlacesModel.h"

@protocol PlacesModel
@end

@interface CountryModel : PaginationModel

@property(nonatomic,strong)NSString* status;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,assign)int country_id;
@property(nonatomic,strong)NSMutableArray* arrArea;
@property(nonatomic,strong)NSMutableArray* arrCountryName;

@end
