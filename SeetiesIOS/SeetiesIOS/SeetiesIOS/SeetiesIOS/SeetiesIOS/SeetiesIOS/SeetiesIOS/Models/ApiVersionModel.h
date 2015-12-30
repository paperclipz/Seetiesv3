//
//  ApiVersionModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"

@interface ApiVersionModel : Model

@property (strong, nonatomic) NSString* version;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* message;
@property (assign, nonatomic) BOOL production;

@end
