//
//  ConnectionManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
typedef void (^IDBlock)(id object);
typedef void (^IErrorBlock)(id object);
@interface ConnectionManager :NSObject
@property(nonatomic,strong)NSString* serverPath;
@property(nonatomic,strong)NSString* subPath;

+(id)Instance;
@end
