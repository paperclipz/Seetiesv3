//
//  ConnectionManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"
#import "DataManager.h"

typedef void (^IDBlock)(id object);
typedef void (^IErrorBlock)(id object);
@interface ConnectionManager :MKNetworkEngine
@property(nonatomic,strong)NSString* serverPath;
@property(nonatomic,strong)NSString* subPath;

+(id)Instance;


- (MKNetworkOperation*)requestServerWithPost:(BOOL)isPost requestType:(ServerRequestType)serverRequestType param:(NSDictionary*)dict completionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;
-(void)requestForDEploymentTarget:(IDBlock)completeBlock errorHandler:(MKNKErrorBlock)errorBlock;
+(DataManager*)dataManager;
- (MKNetworkOperation*)requestServerwithAppendString:(NSDictionary*)dict requestType:(ServerRequestType)serverRequestType  completionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;
- (MKNetworkOperation*)requestServerwithAppendString:(NSString*)url param:(NSDictionary*)dict  completionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;
-(void)storeServerData:(id)obj requestType:(ServerRequestType)type;

- (MKNetworkOperation*)requestServerwithAppendString:(NSString*)url requestType:(ServerRequestType)serverRequestType param:(NSDictionary*)dict  completionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;

@end
