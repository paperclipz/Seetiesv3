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
    
    
    if ([Utils isAppProductionBuild]) {
        self.serverPath = SERVER_PATH_LIVE;

    }
    else{
        self.serverPath = SERVER_PATH_DEV;

    }
    // ====== set to Live if wanna go production ======
    
       self.dataManager = [DataManager Instance];
    
    return self;
}



+(NSString*)getServerPath
{
    return [[ConnectionManager Instance]serverPath];
}

-(NSString*)serverPath
{
    
    if ([Utils isAppProductionBuild]) {
        BOOL isDev = [Utils getIsDevelopment];
        return isDev?SERVER_PATH_DEV:SERVER_PATH_LIVE;
    }
    else{
        return SERVER_PATH_DEV;
    }
    
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
    
    if ([self validateBeforeRequest:type]) {
        
        return;
    }
    
    if(isPost)
    {
        [self.manager POST:url parameters:dict
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             [self storeServerData:responseObject requestType:type withURL:url completionBlock:completeBlock errorBlock:error];
             
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
             
             [self storeServerData:responseObject requestType:type withURL:url completionBlock:completeBlock errorBlock:error];
             
             
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
    if ([self validateBeforeRequest:type]) {
        
        return;
    }
    NSString* fullURL = [self getFullURLwithType:type];
    
    SLog(@"\n\n ===== [REQUEST SERVER WITH POST][URL] : %@ \n [REQUEST JSON] : %@\n\n",fullURL,[dict bv_jsonStringWithPrettyPrint:YES]);
    
    
    [self.manager POST:fullURL parameters:dict
               success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self storeServerData:responseObject requestType:type withURL:fullURL completionBlock:completeBlock errorBlock:error];
         
         [LoadingManager hide];
     }
               failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"\n\n  Error: %@", error);
         [LoadingManager hide];

     }];
    
    
}


-(void)requestServerWithGet:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock
{
    
    if ([self validateBeforeRequest:type]) {
        
        return;
    }
    
    NSString* fullURL;
    
    if (appendString) {
        fullURL = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:type],appendString];
        
    }
    else
    {
        fullURL = [self getFullURLwithType:type];
    }
    
    if (IS_SIMULATOR && type == ServerRequestTypeGetNewsFeed) {
        [self storeServerData:[self getJsonForType:type] requestType:type withURL:fullURL completionBlock:completeBlock errorBlock:errorBlock];
        
        if (completeBlock) {
            completeBlock(nil);
        }
        return;
    }
    
    
    SLog(@"\n\n ===== [REQUEST SERVER WITH GET][URL] : %@ \n [REQUEST JSON] : %@\n\n",fullURL,[dict bv_jsonStringWithPrettyPrint:YES]);
    
    [self.manager GET:fullURL parameters:dict
              success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self storeServerData:responseObject requestType:type withURL:fullURL completionBlock:completeBlock errorBlock:errorBlock];
         
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
-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock
{
    
    if ([self validateBeforeRequest:type]) {
        
        return;
    }
    
    [LoadingManager show];
    
    NSString* fullURL;
    if (appendString) {
        
        fullURL = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:type],appendString];
        
    }
    
    else{
        
        fullURL = [self getFullURLwithType:type];
    }
    
    SLog(@"\n\n ===== Request Server ===== : %@ \n\n request Json : %@",fullURL,[dict bv_jsonStringWithPrettyPrint:YES]);
    
    [self.manager POST:fullURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // NSDictionary* resDict = [[NSDictionary alloc]initWithDictionary:responseObject];
        
        [self storeServerData:responseObject requestType:type withURL:fullURL completionBlock:completeBlock errorBlock:errorBlock];
        
        
        [LoadingManager hide];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (errorBlock) {
            errorBlock(error);
        }
        
        [LoadingManager hide];
        
        NSLog(@"\n\n  Error: %@ ***** %@", operation.responseString, error);
    }];
    
}

-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString meta:(NSArray*)arrMeta completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock
{
//    [LoadingManager show];
    
    if ([self validateBeforeRequest:type]) {
        
        return;
    }
    
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
        
        [self storeServerData:responseObject requestType:type withURL:fullURL completionBlock:completeBlock errorBlock:errorBlock];
        
        [LoadingManager hide];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (errorBlock) {
           
            @try {
                errorBlock(error);

            }
            @catch (NSException *exception) {
                
            }
           
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
    
    if ([self validateBeforeRequest:type]) {
        
        return;
    }
    
    NSString* fullURL = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:type],appendString];
    
    NSLog(@"\n\n ===== Request Server DELETE ===== : %@ \n\n Request Json : %@",fullURL,dict);
    
    [self.manager DELETE:fullURL parameters:dict
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self storeServerData:responseObject requestType:type withURL:fullURL completionBlock:completeBlock errorBlock:error];
         
         
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
    if ([self validateBeforeRequest:type]) {
        
        return;
    }
    
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
         
         [self storeServerData:responseObject requestType:type withURL:fullURL completionBlock:completeBlock errorBlock:error];
         
     }
              failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"\n\n Error: %@", error);
         [LoadingManager hide];
         
     }];
    
}

//-(void)processApiversion
//{
//    [Utils setIsDevelopment:!self.dataManager.apiVersionModel.production];
//}

#pragma mark - SEETIES URL
-(NSString*)getFullURLwithType:(ServerRequestType)type
{
    NSString* str;
    switch (type) {
        case ServerRequestTypeLogin:
            str = [NSString stringWithFormat:@"%@/login",API_VERION_URL];
            
            break;
        case ServerRequestTypeLoginFacebook:
            str = [NSString stringWithFormat:@"%@/login/facebook",API_VERION_URL];
            
            break;
        case ServerRequestTypeLoginInstagram:
            str = [NSString stringWithFormat:@"%@/login/instagram",API_VERION_URL];
            
            break;
            
        case ServerRequestTypeRegister:
            str = [NSString stringWithFormat:@"%@/register",API_VERION_URL];
            
            break;
        case ServerRequestTypeGetLogout:
            str = [NSString stringWithFormat:@"%@/logout",API_VERION_URL];
            
            break;
            
        case ServerRequestTypeGetNewsFeed:
            str = [NSString stringWithFormat:@"%@/feed/v2",API_VERION_URL];
            
            break;
            
        case ServerRequestTypeGetAllAppInfo:
            str = [NSString stringWithFormat:@"%@/system/update/all",API_VERION_URL];
            
            break;
            
        case ServerRequestTypeGetLanguage:
            
            str = [NSString stringWithFormat:@"%@/system/update/languages",API_VERION_URL];
            break;
            
        case ServerRequestTypeGetCategory:
            str = [NSString stringWithFormat:@"%@/system/update/category",API_VERION_URL];
            
            break;
//        case ServerRequestTypeGetApiVersion:
//            
//            str = [NSString stringWithFormat:@"%@/system/apiversion?device_type=2",API_VERION_URL];
//            return [NSString stringWithFormat:@"https://%@/%@",SERVER_PATH_DEV,str];
//            
//            break;
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
            
            return [NSString stringWithFormat:@"https://geoip.seeties.me/geoip"];
            
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
        case ServerRequestTypeGetSeetoShopTranslation:
        case ServerRequestTypeGetSeetiShopDeal:
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
        case ServerRequestTypePutCollectPost:
        case ServerRequestTypePostCreateCollection:
        case ServerRequestTypeUserFollower:
        case ServerRequestTypeUserFollowing:
        case ServerRequestTypePostProvisioning:
        case  ServerRequestTypePostUpdateUser:
        default:
            str = API_VERION_URL;
            break;
            
        case ServerRequestTypePostLikeAPost:
        case ServerRequestTypeDeleteLikeAPost:
            str = [NSString stringWithFormat:@"%@/post",API_VERION_URL];
            break;
        case ServerRequestTypeSearchPosts:
            str = [NSString stringWithFormat:@"%@/search",API_VERION_URL];

            break;
        case ServerRequestTypeSearchUsers:
            str = [NSString stringWithFormat:@"%@/search/user",API_VERION_URL];

            break;
        case ServerRequestTypeSearchCollections:
            str = [NSString stringWithFormat:@"%@/search/collections",API_VERION_URL];
            break;
        case ServerRequestTypeSearchShops:
            str = [NSString stringWithFormat:@"%@/search/shops",API_VERION_URL];

            break;
            
        case ServerRequestTypeGetHomeCountry:
            str = [NSString stringWithFormat:@"%@/system/update/countries",API_VERION_URL];
            
            break;
            
        case ServerRequestTypeGetHomeCountryPlace:
            str = [NSString stringWithFormat:@"%@/home/countries",API_VERION_URL];
            
            break;
            
        case ServerRequestTypeGetHome:
            str = [NSString stringWithFormat:@"%@/home",API_VERION_URL];
            
            break;
        case ServerRequestTypeGetHomeUpdater:
            str = [NSString stringWithFormat:@"%@/home/update",API_VERION_URL];
            
            break;
            
        case ServerRequestTypeGetSuperDeals:
            str = [NSString stringWithFormat:@"%@/home/superdeals", API_VERION_URL];
            break;
            
        case ServerRequestTypeGetDealCollectionDeals:
            str = [NSString stringWithFormat:@"%@/deal-collections", API_VERION_URL];

            break;
            
        case ServerRequestTypeGetVoucherInfo:
        case ServerRequestTypePostCollectDeals:
        case ServerRequestTypeDeleteVoucher:
            str = [NSString stringWithFormat:@"%@/vouchers", API_VERION_URL];
            break;
            
        case ServerRequestTypePutRedeemVoucher:
            str = [NSString stringWithFormat:@"%@/vouchers/redeem", API_VERION_URL];
            break;
            
        case ServerRequestTypeGetFollowingNotifictions:
            str = [NSString stringWithFormat:@"%@/notifications/following", API_VERION_URL];
            break;
            
        case ServerRequestTypeGetNotifications:
            str = [NSString stringWithFormat:@"%@/notifications", API_VERION_URL];
            break;
            
        case ServerRequestTypeGetNotificationCount:
            str = [NSString stringWithFormat:@"%@/notifications/count", API_VERION_URL];
            break;
            
        case ServerRequestTypeGetDealRelevantDeals:
        case ServerRequestTypeGetDealInfo:
            str = [NSString stringWithFormat:@"%@/deals", API_VERION_URL];
            break;
            
        case ServerRequestTypePostTOTP:
            str = [NSString stringWithFormat:@"%@/totp", API_VERION_URL];
            break;
            
        case ServerRequestTypePostVerifyTOTP:
            str = [NSString stringWithFormat:@"%@/totp/verify", API_VERION_URL];
            break;
            
        case ServerRequestTypeGetPromoCode:
        case ServerRequestTypePostRedeemPromoCode:
            str = [NSString stringWithFormat:@"%@/promo-codes", API_VERION_URL];
            break;
        case ServerRequestTypeGetPlacesSuggestion:
            str = [NSString stringWithFormat:@"%@/places", API_VERION_URL];
            break;
            
#pragma mark Report
        case ServerRequestTypePostReportShop:
            
            str = [NSString stringWithFormat:@"%@/seetishops", API_VERION_URL];

            break;
        case ServerRequestTypePostReportDeal:
            
            str = [NSString stringWithFormat:@"%@/deals", API_VERION_URL];
            
            break;
            
            
    }
    
    return [NSString stringWithFormat:@"https://%@/%@",self.serverPath,str];
    
}

-(BOOL)isNeedRelogin:(NSDictionary*)obj
{
    
    @try {
        NSDictionary* dict = [[NSDictionary alloc]initWithDictionary:obj];
        
        
        NSDictionary* appInfo = dict[@"APIINFO"];
        
        if (appInfo) {
            BOOL is_Production = [[appInfo objectForKey:@"is_production"]boolValue];
            // is_Production = true;
            is_Production?SLog(@"[current app status] : LIVE"):SLog(@"[current app status] : development");
            BOOL app_is_production = ![Utils getIsDevelopment];
            
            if(is_Production == app_is_production)
            {
                return NO;
            }
            else{
                
                SLog(@"App relog due to changing of server path (Dev to Production)");
                return YES;
            }

        }
        
    }
    @catch (NSException *exception) {
        SLog(@"no value found for production");
    }
    
    
    return NO;
}

-(void)saveProductionSetting:(NSDictionary*)obj
{
    
    @try {
        NSDictionary* dict = [[NSDictionary alloc]initWithDictionary:obj];
        
        NSDictionary* appInfo = dict[@"APIINFO"];
        
        if (appInfo) {
            BOOL is_Production = [[appInfo objectForKey:@"is_production"]boolValue];
            
            //  is_Production = true;
            [Utils setIsDevelopment:!is_Production];
        }
    }
    
    @catch (NSException *exception) {
        SLog(@"fail to save production key");
    }
    
}
-(void)storeServerData:(id)obj requestType:(ServerRequestType)type withURL:(NSString*)url completionBlock:(IDBlock)completionBlock errorBlock:(IDBlock)errorBlock
{
    
    
    NSLog(@"\n\n\n [SUCCESS RESPONSE RESULT URL : %@] \n%@ \n\n\n", url,[obj bv_jsonStringWithPrettyPrint:YES]);
    
    
    if ([self isNeedRelogin:obj]) {
        
        SLog(@"change to dev");
        [self saveProductionSetting:obj];
      
        return;
    }
    
    
    [self saveProductionSetting:obj];

    
    [self storeServerData:obj requestType:type];
    
    NSDictionary* dict = [[NSDictionary alloc]initWithDictionary:obj];
    
    BOOL hasError = NO;
    
   
    
    @try {
        
        NSString* error = dict[@"error"];
        
        if (![Utils isStringNull:error]) {
            
            SLog(@"%@",dict[@"message"]);
            
            [MessageManager showMessage:LocalisedString(@"system") SubTitle:dict[@"message"] Type:TSMessageNotificationTypeError];
            //[TSMessage show];
            
            hasError = YES;
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    
    
    if (hasError) {
        if (errorBlock) {
            @try {
                errorBlock(dict[@"message"]);

            }
            @catch (NSException *exception) {
                
            }
           
        }

    }
    else{
    
        if (completionBlock) {
            completionBlock(dict);
        }
        
    }
   
}

-(void)processLogin
{
    ProfileModel* model = self.dataManager.userLoginProfileModel;
    if (model) {
        
        [Utils registerParseAfterLogin:model.uid];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:model.token forKey:TOKEN];
        [defaults setObject:model.uid forKey:USERID];
        [defaults setObject:model.system_language.caption forKey:KEY_SYSTEM_LANG];
        
        if (![Utils isArrayNull:model.languages]) {
            [defaults setObject:[model.languages[0] langID] forKey:KEY_LANGUAGE_ONE];
            
            if (model.languages.count>=2) {
                [defaults setObject:[model.languages[1] langID] forKey:KEY_LANGUAGE_TWO];
            }
        }
        
        [defaults synchronize];
    }
    
}

-(void)storeServerData:(id)obj requestType:(ServerRequestType)type
{
    
    [LoadingManager hide];
    NSError* error;

    //make checking for status fail or success here
    switch (type) {
        case ServerRequestTypeLogin:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.userLoginProfileModel = [[ProfileModel alloc]initWithDictionary:dict error:&error];
            [self processLogin];
            
        }
            
            break;
            
        case ServerRequestTypeLoginFacebook:
        {
            NSDictionary* dict = obj[@"data"];
            
            self.dataManager.userLoginProfileModel = [[ProfileModel alloc]initWithDictionary:dict error:&error];
            [self processLogin];
            
        }
            break;
            
        case ServerRequestTypeLoginInstagram:
        {
            NSDictionary* dict = obj[@"data"];
            
            self.dataManager.userLoginProfileModel = [[ProfileModel alloc]initWithDictionary:dict error:&error];
            [self processLogin];
            
        }
            break;
            
            
        case ServerRequestTypeRegister:
            
            break;
            
//        case ServerRequestTypeGetApiVersion:
//        {
//            self.dataManager.apiVersionModel = [[ApiVersionModel alloc]initWithDictionary:obj error:nil];
//            
//           // [self processApiversion];
//        }
            break;
            
        case ServerRequestTypeGetNewsFeed:
        {
            
            NSDictionary* dict = obj[@"data"];
            self.dataManager.newsFeedModels = [[NewsFeedModels alloc]initWithDictionary:dict error:&error];
            
            
            
            
        }
            break;
            
        case ServerRequestTypeGetLanguage:
            self.dataManager.languageModels = [[LanguageModels alloc]initWithDictionary:obj error:&error];
            break;
            
        case ServerRequestTypeGetExplore:
            
            self.dataManager.exploreCountryModels = [[ExploreCountryModels alloc]initWithDictionary:obj error:&error];
            break;
            
        case ServerRequestType4SquareSearch:
        {
            //            NSArray *venues = [obj valueForKeyPath:@"response.venues"];
            //            FSConverter *converter = [[FSConverter alloc]init];
            //  self.dataManager.fourSquareVenueModel = [converter convertToObjects:venues];
            
            // NSArray *venues = [obj valueForKeyPath:@"response.groups.items.venue"];
            self.dataManager.fourSquareVenueModel = [[FourSquareModel alloc]initWithDictionary:obj error:&error];
            
        }
            break;
            
        case ServerRequestTypeGoogleSearch:
            self.dataManager.googleSearchModel = [[SearchModel alloc]initWithDictionary:obj error:&error];
            
            break;
            
        case ServerRequestTypeGoogleSearchWithDetail:
        {
            NSDictionary* dict = obj[@"result"];
            self.dataManager.googleSearchDetailModel = [[SearchLocationDetailModel alloc]initWithDictionary:dict error:&error];
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
            
            self.dataManager.savedDraftModel = [[DraftModel alloc]initWithDictionary:dict error:&error];
            
            [self.dataManager.savedDraftModel customProcess];
            [self.dataManager.savedDraftModel process];

        }
            break;
            
        case ServerRequestTypeGetTagsSuggestion:
        {
            NSDictionary* dict = obj[@"data"];
            
            NSError* error;
            self.dataManager.tagModel = [[TagModel alloc]initWithDictionary:dict error:&error];
            
            SLog(@"%@",error);
        }
            break;
        case ServerRequestTypeGetUserCollections:
            
        {
            
            NSDictionary* dict = obj[@"data"];
            NSError* error;
            self.dataManager.userCollectionsModel = [[CollectionsModel alloc]initWithDictionary:dict error:&error];
            
            SLog(@"error : %@",error);
        }
            break;
        case ServerRequestTypeSearchCollections:
        {
            
            NSDictionary* dict = obj[@"data"][@"collections"];
            NSError* error;
            self.dataManager.userCollectionsModel = [[CollectionsModel alloc]initWithDictionary:dict error:&error];
            
            SLog(@"error : %@",error);
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
            NSDictionary *dict = obj[@"data"];
            self.dataManager.seNearbyShopModel = [[SeShopsModel alloc]initWithDictionary:dict error:nil];
        }
            break;
        case ServerRequestTypeGetSeetoShopRecommendations:
        {
            self.dataManager.userProfilePostModel = [[ProfilePostModel alloc]initWithDictionary:obj error:nil];
            [self.dataManager.userProfilePostModel.userPostData process];
        }
            break;
            
        case ServerRequestTypeGetSeetoShopTranslation:
        {
            SLog(@"the ServerRequestTypeGetSeetoShopTranslation result is :%@",obj);
            
        }
            break;
        case ServerRequestTypePutCollectPost:
            break;
        case ServerRequestTypeSearchPosts:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.userProfilePostModel = [[ProfilePostModel alloc]initWithDictionary:dict error:nil];
            [self.dataManager.userProfilePostModel.userPostData process];
        }
            break;
        case ServerRequestTypeUserFollower:
        case ServerRequestTypeUserFollowing:
        case ServerRequestTypeSearchUsers:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.usersModel = [[UsersModel alloc]initWithDictionary:dict error:nil];
        }
            break;
        case ServerRequestTypeGetHomeCountry:
        {
            NSDictionary* dict = obj[@"countries"];
            
            self.dataManager.countriesModel = [[CountriesModel alloc]initWithDictionary:dict error:nil];
            [self.dataManager.countriesModel processShouldDisplay];
        }
            break;
            
        case ServerRequestTypeGetHomeCountryPlace:
        {
           // NSDictionary* dict = obj[@"data"];
            
            //   AreaModel* model = [[AreaModel alloc]initWithDictionary:dict error:nil];
            
            //  SLog(@"%@",model);
        }
            break;
            
        case ServerRequestTypeGetHome:
        {
            
            NSDictionary* dict = obj[@"data"];
            self.dataManager.homeModel = [[HomeModel alloc]initWithDictionary:dict error:nil];
        }
            break;
            
        case ServerRequestTypeGetSuperDeals:
        {
            NSDictionary *dict = obj[@"data"][@"superdeals"];
            self.dataManager.dealsModel = [[DealsModel alloc] initWithDictionary:dict error:nil];
            
        }
            break;
            
        case ServerRequestTypeGetDealRelevantDeals:
        case ServerRequestTypeGetDealCollectionDeals:
        {
            NSDictionary *dict = obj[@"data"][@"deals"];
            self.dataManager.dealsModel = [[DealsModel alloc] initWithDictionary:dict error:nil];
            
        }
            break;
            
        case ServerRequestTypePostCollectDeals:
        case ServerRequestTypeDeleteVoucher:
        case ServerRequestTypeGetVoucherInfo:
        case ServerRequestTypeGetDealInfo:
        {
            NSDictionary *dict = obj[@"data"];
            self.dataManager.dealModel = [[DealModel alloc] initWithDictionary:dict error:nil];
        }
            break;
        
        case ServerRequestTypeGetUserVouchersHistoryList:
        case ServerRequestTypeGetUserVouchersList:
        {
            NSDictionary *dict  = obj[@"data"][@"vouchers"];
            self.dataManager.dealsModel = [[DealsModel alloc] initWithDictionary:dict error:nil];
        }
            break;
            
        case ServerRequestTypeGetHomeUpdater:
        {
            NSDictionary *dict = obj[@"data"];
            self.dataManager.dealsModel = [[DealsModel alloc] initWithDictionary:dict error:nil];
        }
            
            break;
            
        case ServerRequestTypeGetFollowingNotifictions:
        {
            NSDictionary* dict = obj[@"data"];
            self.dataManager.followingNotificationModels = [[NotificationModels alloc]initWithDictionary:dict error:nil];
        }
            break;
        case ServerRequestTypeGetNotifications:
            
        {
            @try {
                NSDictionary* dict = obj[@"data"][@"notifications"];
                self.dataManager.notificationModels = [[NotificationModels alloc]initWithDictionary:dict error:nil];
                
            }
            @catch (NSException *exception) {
                
                SLog(@"NotificationModels Not Initialized");
            }
        }
            
            break;
            
        case ServerRequestTypeGetAllAppInfo:
            
            self.dataManager.appInfoModel = [[AppInfoModel alloc]initWithDictionary:obj error:nil];
            
            if (self.dataManager.appInfoModel.languages) {
                
                self.dataManager.languageModels = [LanguageModels new];
                self.dataManager.languageModels .languages = self.dataManager.appInfoModel.languages;

            }

            break;
            //        case ServerRequestTypePostProvisioning:
            //
            //            break;
            
        case ServerRequestTypeSearchShops:
        {
            NSDictionary *dict = obj[@"data"][@"shops"];
            self.dataManager.seShopListingModel = [[SeShopsModel alloc]initWithDictionary:dict error:nil];
        }
            break;
            
        case ServerRequestTypeGetSeetiShopDeal:
        {
            NSDictionary *dict = obj[@"data"][@"deals"];
            self.dataManager.dealsModel = [[DealsModel alloc] initWithDictionary:dict error:nil];
        }
            break;
            
        case ServerRequestTypePostVerifyTOTP:
        {
            NSDictionary *dict = obj[@"data"];
            self.dataManager.currentUserProfileModel = [[ProfileModel alloc] initWithDictionary:dict error:nil];
        }
            break;
            
        case ServerRequestTypePostRedeemPromoCode:
        case ServerRequestTypeGetPromoCode:
        {
            @try{
                NSDictionary *dict = obj[@"data"];
                self.dataManager.dealsModel = [[DealsModel alloc] initWithDictionary:dict error:nil];
            }
            @catch(NSException *ex){
                self.dataManager.dealModel = nil;
            }
            
        }
            break;
            
        case ServerRequestTypeGetPlacesSuggestion:
        {
            NSDictionary *dict = obj[@"data"][@"shops"];
            self.dataManager.suggestedPlaceModel = [[SuggestedPlaceModel alloc]initWithDictionary:dict error:nil];
        }
            break;
            
        default:
            
            SLog(@"the return result is :%@",obj);
            break;
    }
}

-(id)getJsonForType:(ServerRequestType)type
{
    NSDictionary* localDict;
    
    NSString *textPAth = [[NSBundle mainBundle] pathForResource:@"feed" ofType:@"json"];
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPAth encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
    //    NSError *jsonError;
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    localDict = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    return localDict;
}

-(void)requestServerForAppInfo:(IDBlock)completionBlock FailBlock:(IErrorBlock)errorBlock
{
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetAllAppInfo param:nil appendString:nil completeHandler:^(id object) {
        
        if(completionBlock)
        {
            completionBlock(object);
        }
        
    } errorBlock:^(id object) {
        
        if(errorBlock)
        {
            errorBlock(object);
        }
    }];
}


#pragma mark - PRE REQUEST VALIDATION

-(BOOL)validateBeforeRequest:(ServerRequestType)type
{
    BOOL flag = false;
    
    switch (type) {
        case ServerRequestTypeDeleteLikeAPost:
        case ServerRequestTypePutCollectPost:

            
            if ([Utils isGuestMode]) {
                
                flag = true;
                [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Please Login First") cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        [Utils showLogin];
                        
                    }
                }];
            }

            break;
            
        default:
            break;
    }
    
    return flag;
}

@end