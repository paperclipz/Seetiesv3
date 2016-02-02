//
//  AreaModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/2/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AreaModel : JSONModel
@property(nonatomic,assign)NSArray<PlacesModel>*result;

@end
