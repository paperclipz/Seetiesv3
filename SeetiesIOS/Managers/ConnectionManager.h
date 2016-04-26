//
//  ConnectionManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
//#import "AFHTTPRequestOperationManager.h"

/*Before deploy check :
 1. api version
 2. change bundle indetifier to live or dev accordingly
 3. change server path to live or dev
 */


typedef enum
{
    AFNETWORK_GET = 1,
    AFNETWORK_POST = 2,
    AFNETWORK_DELETE = 3,
    AFNETWORK_PUT = 4,
    AFNETWORK_CUSTOM_GET = 5,
    AFNETWORK_CUSTOM_POST = 6,

}AFNETWORK_TYPE;

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
-(void)storeServerData:(id)obj requestType:(ServerRequestType)type;

-(void)requestServerWith:(AFNETWORK_TYPE)networkType serverRequestType:(ServerRequestType)serverType parameter:(NSDictionary*)parameter appendString:(NSString*)appendString success:(IDBlock)success failure:(IErrorBlock)failure;


//-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString meta:(NSArray*)arrMeta completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock;



/*for app specific info request only*/
-(void)requestServerForAppInfo:(IDBlock)completionBlock FailBlock:(IErrorBlock)errorBlock;

@end
