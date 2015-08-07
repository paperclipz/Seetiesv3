//
//  ConnectionManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager()
@property (strong, nonatomic) DataManager *dataManager;

@end
@implementation ConnectionManager
+ (id)Instance {
    static ConnectionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        
    });
    return instance;
}

+(DataManager*)dataManager
{
    return [[ConnectionManager Instance] dataManager];
}
-(id)init
{
    self = [super initWithHostName:SERVER_PATH_DEV];//set default dev
    self.dataManager = [DataManager Instance];

    return self;
}

-(void)requestForDEploymentTarget:(IDBlock)completeBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    self.hostName = SERVER_PATH_DEV;
    NSString *FullString = [self getFullURLwithType:ServerRequestTypeGetApiVersion];

    MKNetworkOperation *op = [self operationWithPath:FullString
                                              params:nil
                                          httpMethod:@"GET" ssl:YES];
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeURL];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *jsonString = [completedOperation responseString];
        NSDictionary *responseDict = [jsonString objectFromJSONString];
        
        [self storeServerData:responseDict requestType:ServerRequestTypeGetApiVersion];
        if(completeBlock)
        {
            completeBlock(responseDict);
        }
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        SLog(@"\n\nerror == %@", [error localizedDescription]);
        errorBlock(error);
       
    }];
    [self enqueueOperation:op];
}

-(void)processApiversion
{
    self.hostName = self.dataManager.apiVersionModel.production?SERVER_PATH_LIVE:SERVER_PATH_DEV;
}

-(NSString*)getFullURLwithType:(ServerRequestType)type
{
    NSString* str;
    switch (type) {
        case ServerRequestTypeLogin:
 
            break;
            
        case ServerRequestTypeGetLanguage:
            str =  @"v1.3/system/languages";
            break;
            
        case ServerRequestTypeGetApiVersion:
            str = @"v1.3/system/apiversion?device_type=2";
            break;
        default:
            break;
    }
    
   // return [NSString stringWithFormat:@"%@%@",self.serverPath,self.subPath];
    
    return str;
}

#pragma mark - Service Request

- (MKNetworkOperation*)requestServerWithPost:(BOOL)isPost requestType:(ServerRequestType)serverRequestType param:(NSDictionary*)dict completionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
 
    NSString *fullURL = [self getFullURLwithType:serverRequestType];
    NSString *httpMethod = (isPost) ? @"POST" : @"GET";
    SLog(@"\n\nRequest URL: %@\nRequest JSON:\n%@", fullURL, [dict JSONString]);

    
    MKNetworkOperation *op = [self operationWithPath:fullURL
                                              params:dict
                                          httpMethod:httpMethod ssl:YES];
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *jsonString = [completedOperation responseString];
        SLog(@"\n\nRequest URL: %@\nResponse JSON:\n%@", fullURL, jsonString);
        NSDictionary *responseDict = [jsonString objectFromJSONString];

        [self storeServerData:responseDict requestType:serverRequestType];
        [self processApiversion];
        if (completionBlock) {
            completionBlock(responseDict);
        }
        //[self loadJsonAndStoreInModel:responseDict ServerRequestType:serverRequestType];
        
//        if (completionBlock) {
//            [self invokeCompletionBlock:completionBlock forType:serverRequestType];
//        }
        
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        SLog(@"\n\nerror == %@", [error localizedDescription]);
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    [self enqueueOperation:op];
    return op;
}

-(void)storeServerData:(id)obj requestType:(ServerRequestType)type
{
    
    //make checking for status fail or success here
    switch (type) {
        case ServerRequestTypeLogin:
            break;
        case ServerRequestTypeGetApiVersion:
            self.dataManager.apiVersionModel = [[ApiVersionModel alloc]initWithDictionary:obj error:nil];
            
            SLog(@" %@",self.dataManager.apiVersionModel.title);
            break;
            
        case ServerRequestTypeGetLanguage:
            self.dataManager.languageModels = [[LanguageModels alloc]initWithDictionary:obj error:nil];            
            break;
        default:
            break;
    }
}

@end
