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
#import "AFHTTPRequestOperationManager.h"

typedef void (^IDBlock)(id object);
typedef void (^IErrorBlock)(id object);
@interface ConnectionManager :NSObject
@property(nonatomic,strong)NSString* serverPath;
@property(nonatomic,strong)NSString* subPath;

+(id)Instance;
+(DataManager*)dataManager;
@property(strong,nonatomic)AFHTTPRequestOperationManager* manager;
-(void)storeServerData:(id)obj requestType:(ServerRequestType)type;


-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;

-(void)requestServerWithPost:(bool)isPost customURL:(NSString*)url requestType:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;
-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString meta:(NSArray*)arrMeta completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock;

-(void)requestServerWithGet:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;
-(void)requestServerWithDelete:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;

-(void)requestServerWithPut:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;

@end
