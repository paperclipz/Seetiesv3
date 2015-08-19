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
//Must call this every time enter app to ensure right environment is retrieved
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
        [self processApiversion];
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        SLog(@"\n\nerror == %@", [error localizedDescription]);
        if (errorBlock) {
            errorBlock(error);

        }
       
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
        case ServerRequestTypeGetExplore:
            str = @"v1.3/explore";
            break;

        default:
            break;
    }
    
   // return [NSString stringWithFormat:@"%@%@",self.serverPath,self.subPath];
    
    return str;
}

#pragma mark - Service Request

//For append string with api without reqeust type . EXP: get location etc
- (MKNetworkOperation*)requestServerwithAppendString:(NSString*)url param:(NSDictionary*)dict  completionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{

    MKNetworkOperation *op = [self operationWithURLString:url params:dict];
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];

    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSString *jsonString = [completedOperation responseString];
        
        NSDictionary *responseDict = [jsonString objectFromJSONString];

    if(completionBlock)
    {
        completionBlock(responseDict);
    }

    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if(errorBlock)
        {
            errorBlock(error);
        }
    }];
    
    [self enqueueOperation:op];

    return op;

    
}

- (MKNetworkOperation*)requestServerwithAppendString:(NSDictionary*)dict requestType:(ServerRequestType)serverRequestType  completionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    
    NSString* fullURL = [NSString stringWithFormat:@"https://%@/%@",self.hostName,[self getFullURLwithType:serverRequestType]];
    
    SLog(@"\n\nRequest URL: %@\n",fullURL);
    
    // MKNetworkOperation *op = [self operationWithURLString:appendURLString];
    
    MKNetworkOperation *op = [self operationWithURLString:fullURL params:dict];
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeURL];
    
    
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *jsonString = [completedOperation responseString];
        SLog(@"\n\nRequest URL: %@\nResponse JSON:\n%@", fullURL, jsonString);
        NSDictionary *responseDict = [jsonString objectFromJSONString];
        
        [self storeServerData:responseDict requestType:serverRequestType];
        if (completionBlock) {
            completionBlock(responseDict);
        }
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        SLog(@"\n\nerror == %@", [error localizedDescription]);
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    [self enqueueOperation:op];
    return op;
    
}
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
        if (completionBlock) {
            completionBlock(responseDict);
        }
        
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
            
        case ServerRequestTypeGetExplore:
            self.dataManager.exploreCountryModels = [[ExploreCountryModels alloc]initWithDictionary:obj error:nil];
            break;
        default:
            break;
    }
}

@end
