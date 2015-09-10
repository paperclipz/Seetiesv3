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


//-(void)requestServer:(ServerRequestType)type completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error GetMethodAttachString:(NSString*)str;

-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;
-(void)requestServerWithGet:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;
-(void)requestServerWithGet:(ServerRequestType)type withAppendString:(NSString*)appendString param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;

-(void)requestServerWithPost:(bool)isPost customURL:(NSString*)url requestType:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;
-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict images:(NSArray*)images completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;

@end
