//
//  ConnectionManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "AFHTTPRequestOperationManager.h"

/*Before deploy check :
 1. api version
 2. change bundle indetifier to live or dev accordingly
 3. change server path to live or dev
 */

#define API_VERSION @"3.0"
#define API_VERION_URL @"v3.0"
#define IS_SIMULATOR NO
typedef void (^DraftModelBlock)(DraftModel* model);


typedef void (^IDBlock)(id object);
typedef void (^IntBlock)(int count);
typedef void (^IndexPathBlock)(NSIndexPath* indexPath);

typedef void (^IErrorBlock)(id object);
@interface ConnectionManager :NSObject
@property(nonatomic,strong)NSString* serverPath;
@property(nonatomic,strong)NSString* subPath;

+(NSString*)getServerPath;

+(id)Instance;
+(DataManager*)dataManager;
@property(strong,nonatomic)AFHTTPRequestOperationManager* manager;
-(void)storeServerData:(id)obj requestType:(ServerRequestType)type;


-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock;
-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock;

-(void)requestServerWithPost:(bool)isPost customURL:(NSString*)url requestType:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;
-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString meta:(NSArray*)arrMeta completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock;

-(void)requestServerWithGet:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock;
-(void)requestServerWithDelete:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;

-(void)requestServerWithPut:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error;


/*for app specific info request only*/
-(void)requestServerForAppInfo:(IDBlock)completionBlock FailBlock:(IErrorBlock)errorBlock;

@end
