//
//  Model.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "JSONModel.h"


@interface Model : JSONModel

@property (strong, nonatomic) NSString* status;
@property (strong, nonatomic) NSString* error;
@property (strong, nonatomic) NSString* message;


@end
