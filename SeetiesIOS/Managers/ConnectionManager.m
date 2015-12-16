//
//  ConnectionManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "ConnectionManager.h"
#import "NSArray+JSON.h"
#define API_VERION_URL @"v2.2"
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
    
    // ====== set to Live if wanna go production   ========
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
    
    NSLog(@"\n\n ===== Request Server ===== : %@ \n\n Request Json : %@",url,[dict bv_jsonStringWithPrettyPrint:YES]);
    if(isPost)
    {
        [self.manager POST:url parameters:dict
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             [self storeServerData:responseObject requestType:type];
             
             
             if (completeBlock) {
                 completeBlock(responseObject);

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
            
             
             if (completeBlock) {
                 completeBlock(responseObject);

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
    NSLog(@"\n\n ===== Request Server ===== : %@ \n\n Request Json : %@",[self getFullURLwithType:type],[dict JSONString]);
    
    [self.manager POST:[self getFullURLwithType:type] parameters:dict
               success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self storeServerData:responseObject requestType:type];
         if (completeBlock) {
             completeBlock(responseObject);
         }
     }
               failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"\n\n  Error: %@", error);
     }];
    
    
}


-(void)requestServerWithGet:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock
{
    
    NSString* fullURL;

    if (appendString) {
        fullURL = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:type],appendString];
        
    }
    else
    {
        fullURL = [self getFullURLwithType:type];
    }
    
    SLog(@"\n\n ===== [REQUEST SERVER WITH GET][URL] : %@ \n [REQUEST JSON] : %@\n\n",fullURL,[dict bv_jsonStringWithPrettyPrint:YES]);
    

    [self.manager GET:fullURL parameters:dict
               success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self storeServerData:responseObject requestType:type];
         
         
         if (completeBlock) {
             completeBlock(responseObject);

         }
         [LoadingManager hide];

         
     }
               failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (errorBlock) {
             errorBlock(error);
         }
         NSLog(@"\n\n Error: %@", error);
         [LoadingManager hide];
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
    
    SLog(@"\n\n ===== Request Server ===== : %@ \n\n request Json : %@",fullURL,[dict bv_jsonStringWithPrettyPrint:YES]);
    
    AFHTTPRequestOperation *op = [self.manager POST:fullURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //do not put image inside parameters dictionary BUT append it
        
        for (int i = 0; i<arrMeta.count; i++) {
            
            PhotoModel* model = arrMeta[i];
                       [formData appendPartWithFormData:[[@(i+1)stringValue]  dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"photos_meta[%d][position]",i]];
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
        
        NSDictionary* resDict = [[NSDictionary alloc]initWithDictionary:responseObject];
        
        if (resDict[@"error"]) {
            if (errorBlock) {
                errorBlock(resDict[@"error"]);

            }
        }
        else {
            [self storeServerData:responseObject requestType:type];
            if (completeBlock) {
                completeBlock(responseObject);
            }
        }
        

       
        
        [LoadingManager hide];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (errorBlock) {
            errorBlock(error);
        }
        
        [LoadingManager hide];

        NSLog(@"\n\n  Error: %@ ***** %@", operation.responseString, error);
    }];
    
   
    
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);

    }];
    
    [op start];
}


-(void)requestServerWithDelete:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error
{
    
    NSString* fullString = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:type],appendString];

    NSLog(@"\n\n ===== Request Server DELETE ===== : %@ \n\n Request Json : %@",fullString,dict);
    
    [self.manager DELETE:fullString parameters:dict
              success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self storeServerData:responseObject requestType:type];
         
         
         if (completeBlock) {
             completeBlock(responseObject);

         }
         [LoadingManager hide];

     }
              failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@ ***** %@", operation.responseString, error);
         [LoadingManager hide];

     }];
    
    
}
-(void)requestServerWithPut:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)error
{
    
    
        NSString* fullURL;
    
    if (appendString) {
        fullURL = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:type],appendString];
        
    }
    else
    {
        fullURL = [self getFullURLwithType:type];
    }
    
    SLog(@"\n\n ===== Request Server ===== : %@ \n\n request Json : %@",fullURL,[dict bv_jsonStringWithPrettyPrint:YES]);
    
    
    [self.manager PUT:fullURL parameters:dict
              success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self storeServerData:responseObject requestType:type];
         
         
         if (completeBlock) {
             completeBlock(responseObject);

         }

     }
              failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"\n\n Error: %@", error);
         [LoadingManager hide];

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
            
            str = [NSString stringWithFormat:@"/%@/system/languages",API_VERION_URL];
            break;
        case ServerRequestTypeGetApiVersion:
            
            str = [NSString stringWithFormat:@"%@/system/apiversion?device_type=2",API_VERION_URL];

            break;
        case ServerRequestTypeGetExplore:
            str = [NSString stringWithFormat:@"%@/explore",API_VERION_URL];

            break;
            
        case ServerRequestTypePostCreatePost:
        case ServerRequestTypePostDeletePost:
        case ServerRequestTypeGetPostInfo:
        case ServerRequestTypePostSaveDraft:
            str = [NSString stringWithFormat:@"%@/post",API_VERION_URL];

            
            break;
            
        case ServerRequestTypeGetRecommendationDraft:
            str = [NSString stringWithFormat:@"%@/draft",API_VERION_URL];

            break;
            
            case ServerRequestTypeGetGeoIP:
            
            return [NSString stringWithFormat:@"https://geoip.seeties.me/geoip/"];

            break;
            
        case ServerRequestTypeGetCategories:
            str = [NSString stringWithFormat:@"%@/system/update/category",API_VERION_URL];

            break;
        case ServerRequestTypeGetTagsSuggestion:
            str = [NSString stringWithFormat:@"%@/tags",API_VERION_URL];

            
            break;
            
        case ServerRequestTypeGetSeetiShopDetail:
        case ServerRequestTypeGetSeetiShopCollection:
        case ServerRequestTypeGetSeetiShopPhoto:
        case ServerRequestTypeGetSeetoShopNearbyShop:
        case ServerRequestTypeGetSeetoShopRecommendations:
            str = [NSString stringWithFormat:@"%@/seetishops",API_VERION_URL];

            break;
            
        case ServerRequestTypeGetCollectionInfo:
        case ServerRequestTypeGetUserCollections:
        case ServerRequestTypeGetUserFollowingCollections:
        case ServerRequestTypeGetUserSuggestedCollections:
        case ServerRequestTypeGetUserPosts:
        case ServerRequestTypeGetUserLikes:
        case ServerRequestTypePostFollowUser:
        case ServerRequestTypePostFollowCollection:
        default:
             str = API_VERION_URL;
            break;
            
    }
    
    return [NSString stringWithFormat:@"https://%@/%@",self.serverPath,str];
    
}

-(void)storeServerData:(id)obj requestType:(ServerRequestType)type
{
    NSLog(@"\n\n\n [SUCCESS RESPONSE RESULT URL : %@] \n%@ \n\n\n", [self getFullURLwithType:type],[obj bv_jsonStringWithPrettyPrint:YES]);


    [LoadingManager hide];

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
        {
            
            NSDictionary* dict = obj[@"data"];

            self.dataManager.collectionModels = [[CollectionModel alloc]initWithDictionary:dict error:nil];
            [self.dataManager.collectionModels process];
        }
            break;
            
        case ServerRequestTypeGetPostInfo:
        {
            
            NSDictionary* dict = obj[@"data"];
            
            self.dataManager.editPostModel = [[DraftModel alloc]initWithDictionary:dict error:nil];
            [self.dataManager.editPostModel process];
        }
            break;
            
        case ServerRequestTypePostSaveDraft:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.savedDraftModel = [[DraftModel alloc]initWithDictionary:dict error:nil];
            [self.dataManager.savedDraftModel process];
        }
            break;
            
        case ServerRequestTypeGetTagsSuggestion:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.tagModel = [[TagModel alloc]initWithDictionary:dict error:nil];
        }
            break;
        case ServerRequestTypeGetUserCollections:
        {
            
            NSDictionary* dict = obj[@"data"];
            self.dataManager.userCollectionsModel = [[CollectionsModel alloc]initWithDictionary:dict error:nil];

        }
            break;
        case ServerRequestTypeGetUserInfo:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.userProfileModel = [[ProfileModel alloc]initWithDictionary:dict error:nil];
        }
            break;
            
        case ServerRequestTypeGetUserPosts:
        {
            self.dataManager.userProfilePostModel = [[ProfilePostModel alloc]initWithDictionary:obj error:nil];
            [self.dataManager.userProfilePostModel.userPostData process];

        }
            break;
            
        case ServerRequestTypeGetUserLikes:
        {
            self.dataManager.userProfileLikeModel = [[ProfilePostModel alloc]initWithDictionary:obj error:nil];
            [self.dataManager.userProfileLikeModel.userPostData process];

        }
            break;
        case ServerRequestTypeGetUserFollowingCollections:
        {
            
            NSDictionary* dict = obj[@"data"];
            self.dataManager.userFollowingCollectionsModel = [[CollectionsModel alloc]initWithDictionary:dict error:nil];
            
        }
           
            break;
            
        case ServerRequestTypeGetUserSuggestedCollections:
        {
            
            NSDictionary* dict = obj[@"data"];
            self.dataManager.userSuggestedCollectionsModel = [[CollectionsModel alloc]initWithDictionary:dict error:nil];
            
        }
            
            break;
        case ServerRequestTypeGetSeetiShopDetail:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.seShopDetailModel = [[SeShopDetailModel alloc]initWithDictionary:dict error:nil];
            [self.dataManager.seShopDetailModel process];
        }
            break;
            
        case ServerRequestTypeGetSeetiShopCollection:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.userSuggestedCollectionsModel = [[CollectionsModel alloc]initWithDictionary:dict error:nil];
        }
            break;
            
        case ServerRequestTypeGetSeetiShopPhoto:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.seShopPhotoModel = [[SeShopPhotoModel alloc]initWithDictionary:dict error:nil];
        }
            break;
            
        case ServerRequestTypeGetSeetoShopNearbyShop:
        {
            self.dataManager.seNearbyShopModel = [[SeetiShopsModel alloc]initWithDictionary:obj error:nil];
        }
            break;
        case ServerRequestTypeGetSeetoShopRecommendations:
        {
            self.dataManager.userProfilePostModel = [[ProfilePostModel alloc]initWithDictionary:obj error:nil];
            [self.dataManager.userProfilePostModel.userPostData process];
        }
            break;
            
            
        default:
            
            SLog(@"the return result is :%@",obj);
            break;
    }
}


@end