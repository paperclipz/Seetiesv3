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
@property(strong,nonatomic)AFHTTPRequestOperationManager* manager;

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
    self = [super init];//set default dev
    self.serverPath = SERVER_PATH_DEV;
    self.dataManager = [DataManager Instance];

    return self;
}

-(AFHTTPRequestOperationManager*)manager
{
    if(!_manager)
    {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",nil];
        _manager.securityPolicy.allowInvalidCertificates = YES;

    }
    
    return _manager;
    
}

//-(void)requestServer:(ServerRequestType)type completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error GetMethodAttachString:(NSString*)str
//{
//    
//    NSString* fullPath =[NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:type],str];
//    NSLog(@"Request Server [%@]",fullPath);
//    
//    [self.manager POST:fullPath parameters:nil
//               success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         
//         
//         [self storeServerData:responseObject requestType:type];
//         
//         if (completeBlock) {
//             completeBlock(responseObject);
//             [self processApiversion];
//         }
//     }
//               failure:
//     ^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"Error: %@", error);
//     }];
//    
//    
//}

-(void)requestServerWithPost:(bool)isPost customURL:(NSString*)url requestType:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error
{
    
    NSLog(@"Request Server : %@ \n\n response Json : %@",url,dict);
    if(isPost)
    {
        [self.manager POST:url parameters:dict
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             [self storeServerData:responseObject requestType:type];
             
             SLog(@"response Json : %@",responseObject);
             
             if (completeBlock) {
                 completeBlock(responseObject);
                 [self processApiversion];
             }
             
         }
                   failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
        
    }
    else{
    
        [self.manager GET:url parameters:dict
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             [self storeServerData:responseObject requestType:type];
            
             NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);

             
             if (completeBlock) {
                 completeBlock(responseObject);
                 [self processApiversion];
             }
             
         }
                   failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

    }
   
}



-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error
{
    NSLog(@"Request Server : %@ \n\n response Json : %@",[self getFullURLwithType:type],dict);
    
    [self.manager POST:[self getFullURLwithType:type] parameters:dict
               success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self storeServerData:responseObject requestType:type];
         if (completeBlock) {
             completeBlock(responseObject);
             NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
             [self processApiversion];
         }
     }
               failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
    
    
}


-(void)requestServerWithGet:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error
{
    
    NSLog(@"Request Server : %@ \n\n response Json : %@",[self getFullURLwithType:type],dict);
    
    [self.manager GET:[self getFullURLwithType:type] parameters:dict
               success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self storeServerData:responseObject requestType:type];
         
         
         if (completeBlock) {
             completeBlock(responseObject);
             NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
             [self processApiversion];
         }
         
     }
               failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@ ***** %@", operation.responseString, error);
     }];
    
    
}

-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict images:(NSArray*)images completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error
{
    
    AFHTTPRequestOperation *op = [self.manager POST:[self getFullURLwithType:type] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //do not put image inside parameters dictionary BUT append it
        
        for (int i = 0; i<images.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(images[i],0.5);
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
        
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        }];
        [op start];
}
-(void)processApiversion
{
    self.serverPath = self.dataManager.apiVersionModel.production?SERVER_PATH_LIVE:SERVER_PATH_DEV;
}

-(NSString*)getFullURLwithType:(ServerRequestType)type
{
    NSString* str;
    switch (type) {
        case ServerRequestTypeLogin:
 
            break;
            
        case ServerRequestTypeGetLanguage:
            str =  @"/v1.3/system/languages";
            break;
            
        case ServerRequestTypeGetApiVersion:
            str = @"v1.3/system/apiversion?device_type=2";
            break;
        case ServerRequestTypeGetExplore:
            str = @"v2.0/explore";
            break;

        case ServerRequestTypePostCreatePost:
            str = @"v2.0/post";

            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"https://%@/%@",self.serverPath,str];
    
   // return str;
}

-(void)storeServerData:(id)obj requestType:(ServerRequestType)type
{
    
    //make checking for status fail or success here
    switch (type) {
        case ServerRequestTypeLogin:
            break;
        case ServerRequestTypeGetApiVersion:
            self.dataManager.apiVersionModel = [[ApiVersionModel alloc]initWithDictionary:obj error:nil];
            
            break;
            
        case ServerRequestTypeGetLanguage:
            self.dataManager.languageModels = [[LanguageModels alloc]initWithDictionary:obj error:nil];
            break;
            
        case ServerRequestTypeGetExplore:
            self.dataManager.exploreCountryModels = [[ExploreCountryModels alloc]initWithDictionary:obj error:nil];
            break;
            
        case ServerRequestType4SquareSearch:
        {
//            NSArray *venues = [obj valueForKeyPath:@"response.venues"];
//            FSConverter *converter = [[FSConverter alloc]init];
          //  self.dataManager.fourSquareVenueModel = [converter convertToObjects:venues];
            
           // NSArray *venues = [obj valueForKeyPath:@"response.groups.items.venue"];
            self.dataManager.fourSquareVenueModel = [[FourSquareModel alloc]initWithDictionary:obj error:nil];
            
        }
            break;
            
        case ServerRequestTypeGoogleSearch:
            self.dataManager.googleSearchModel = [[SearchModel alloc]initWithDictionary:obj error:nil];
            
            break;
            
        case ServerRequestTypeGoogleSearchWithDetail:
        {
            NSDictionary* dict = obj[@"result"];
            self.dataManager.googleSearchDetailModel = [[SearchLocationDetailModel alloc]initWithDictionary:dict error:nil];
        }
            break;
        default:
            
            SLog(@"the return result is :%@",obj);
            break;
    }
}

@end
