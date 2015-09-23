//
//  ConnectionManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "ConnectionManager.h"
#import "NSArray+JSON.h"

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
        _manager.securityPolicy.validatesDomainName = NO;
      //  _manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
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
    
    [LoadingManager show];

    NSLog(@"Request Server : %@ \n\n Request Json : %@",url,[dict JSONString]);
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
             [LoadingManager hide];

             
         }
                   failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [LoadingManager hide];

         }];
        
    }
    else{
    
        [self.manager GET:url parameters:dict
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             [self storeServerData:responseObject requestType:type];
            
             NSLog(@"Success: %@", operation.responseString);

             
             if (completeBlock) {
                 completeBlock(responseObject);
                 [self processApiversion];
             }
             [LoadingManager hide];

             
         }
                   failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [LoadingManager hide];

         }];

    }
   
}



-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error
{
    NSLog(@"Request Server : %@ \n\n Request Json : %@",[self getFullURLwithType:type],[dict JSONString]);
    
    [self.manager POST:[self getFullURLwithType:type] parameters:dict
               success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self storeServerData:responseObject requestType:type];
         if (completeBlock) {
             completeBlock(responseObject);
             NSLog(@"\n\n  Success: %@ ***** %@", operation.responseString, responseObject);
             [self processApiversion];
         }
     }
               failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"\n\n  Error: %@", error);
     }];
    
    
}


-(void)requestServerWithGet:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error
{
    
    NSString* fullURL;

    if (appendString) {
        fullURL = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:type],appendString];
        
    }
    else
    {
        fullURL = [self getFullURLwithType:type];
    }
    
    SLog(@"Request Server : %@ \n\n request Json : %@",fullURL,[dict bv_jsonStringWithPrettyPrint:YES]);
    

    [self.manager GET:fullURL parameters:dict
               success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self storeServerData:responseObject requestType:type];
         
         
         if (completeBlock) {
             completeBlock(responseObject);
             NSLog(@"\n\n Success: %@", [responseObject bv_jsonStringWithPrettyPrint:YES]);
             [self processApiversion];
         }
         
     }
               failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"\n\n Error: %@", error);

     }];
    
}

-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString meta:(NSArray*)arrMeta completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock
{
    [LoadingManager show];

    NSString* fullURL;
    if (appendString) {
        
        fullURL = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:type],appendString];

    }
    
    else{
    
        fullURL = [self getFullURLwithType:type];
    }
    
    SLog(@"Request Server : %@ \n\n request Json : %@",fullURL,[dict bv_jsonStringWithPrettyPrint:YES]);
    
    AFHTTPRequestOperation *op = [self.manager POST:fullURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //do not put image inside parameters dictionary BUT append it
        
        for (int i = 0; i<arrMeta.count; i++) {
            
            PhotoModel* model = arrMeta[i];
                       [formData appendPartWithFormData:[[@(i)stringValue]  dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"photos_meta[%d][position]",i]];
            [formData appendPartWithFormData:[model.caption?model.caption:@"" dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"photos_meta[%d][caption]",i]];
            
            if(model.photo_id)
            {
                [formData appendPartWithFormData:[model.photo_id dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"photos_meta[%d][photo_id]",i]];

            }
            else{
                
                NSData *imageData = UIImageJPEGRepresentation(model.image,0.5);
                if (imageData) {
                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"photos[%d]",i] fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                }

            
            }
        
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completeBlock) {
            completeBlock(responseObject);
        }
        
        [LoadingManager hide];

        NSLog(@"\n\n Success: %@", [responseObject bv_jsonStringWithPrettyPrint:YES]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (errorBlock) {
            errorBlock(error);
        }
        
        [LoadingManager hide];

        NSLog(@"\n\n  Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
}
-(void)requestServerWithDelete:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error
{
    
    NSString* fullString = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:type],appendString];

    NSLog(@"Request Server DELETE : %@ \n\n Request Json : %@",fullString,dict);
    
    [self.manager DELETE:fullString parameters:dict
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
        case ServerRequestTypePostDeletePost:

            str = @"v2.0/post";
            
            break;
            
        case ServerRequestTypeGetRecommendationDraft:
            str = @"v2.0/draft";
            
            break;
            
            case ServerRequestTypeGetGeoIP:
            
            return [NSString stringWithFormat:@"https://geoip.seeties.me/geoip/"];

            break;
            
        case ServerRequestTypeGetCategories:
            str = @"v2.0/system/update/category";
            break;
        case ServerRequestTypeGetCollectionInfo:
        default:
             str = @"v2.0";
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
            [self processApiversion];
            
            break;
            
        case ServerRequestTypeGetLanguage:
            self.dataManager.languageModels = [[LanguageModels alloc]initWithDictionary:obj error:nil];
            break;
            
        case ServerRequestTypeGetExplore:
            
            SLog(@"response explore : %@",[obj JSONString]);
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
            [self.dataManager.googleSearchDetailModel process];
        }
            break;
            
        case ServerRequestTypeGetRecommendationDraft:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.draftsModel = [[DraftsModel alloc]initWithDictionary:dict error:nil];
            [self.dataManager.draftsModel process];
        }
            break;
            
        case ServerRequestTypePostDeletePost:
        {
           
        }
            break;
        case ServerRequestTypeGetCategories:
        
            self.dataManager.categoriesModel = [[CategoriesModel alloc]initWithDictionary:obj error:nil];
           
            break;
            
        case ServerRequestTypeGetCollectionInfo:
            
          //  self.dataManager.categoriesModel = [[CategoriesModel alloc]initWithDictionary:obj error:nil];
            
            break;

            
        default:
            
            SLog(@"the return result is :%@",obj);
            break;
    }
}


@end