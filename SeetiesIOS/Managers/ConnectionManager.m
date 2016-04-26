//
//  ConnectionManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "ConnectionManager.h"
#import "NSArray+JSON.h"
#import <StoreKit/StoreKit.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@interface ConnectionManager()<SKStoreProductViewControllerDelegate>
@property (strong, nonatomic) DataManager *dataManager;
@property(nonatomic)SKStoreProductViewController* skStoreProductViewController;
@property(strong,nonatomic)AFHTTPSessionManager* manager;

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
    //return SERVER_PATH_LIVE;

    if ([Utils isAppProductionBuild]) {
        BOOL isDev = [Utils getIsDevelopment];
        return isDev?SERVER_PATH_DEV:SERVER_PATH_LIVE;
    }
    else{
        return SERVER_PATH_DEV;
    }
    
}

-(AFHTTPSessionManager*)manager
{
 
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
    
}

-(void)requestServerWith:(AFNETWORK_TYPE)networkType serverRequestType:(ServerRequestType)serverType parameter:(NSDictionary*)parameter appendString:(NSString*)appendString success:(IDBlock)success failure:(IErrorBlock)failure
{
    if ([self validateBeforeRequest:serverType]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    else{
        
        NSString* fullURL;
        NSString* strNetworkType;

        if (appendString) {
            fullURL = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:serverType],appendString];
            
        }
        else
        {
            fullURL = [self getFullURLwithType:serverType];
        }
        
        
        switch (networkType) {
            case AFNETWORK_GET:
            {
                strNetworkType = @"GET";
                [self.manager GET:fullURL parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    
                  
                    [self storeServerData:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];

                    [LoadingManager hide];

                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    if (failure) {
                        failure(error);
                    }
     
                    [LoadingManager hide];
                }];
            }
                break;
                
            case AFNETWORK_POST:
            {
                strNetworkType = @"POST";
                [self.manager POST:fullURL parameters:parameter constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSLog(@"JSON: %@", responseObject);
                    
                    [self storeServerData:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                    
                    [LoadingManager hide];

                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                    NSLog(@"Error: %@", error);
                    
                    if (failure) {
                        failure(error);
                    }
                    
                    [LoadingManager hide];
                }];

            }
                break;
                
            case AFNETWORK_DELETE:
            {
                strNetworkType = @"DELETE";
                [self.manager DELETE:fullURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSLog(@"JSON: %@", responseObject);
                    
                    [self storeServerData:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                    
                    [LoadingManager hide];

                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    NSLog(@"Error: %@", error);
                    
                    if (failure) {
                        failure(error);
                    }
                    
                    [LoadingManager hide];
                }];
            }
                break;
                
            case AFNETWORK_PUT:
            {
                strNetworkType = @"PUT";
                
            }
                break;
                
            case AFNETWORK_CUSTOM_GET:
            {
                
                fullURL = appendString;

                [self.manager GET:fullURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    
                    
                    [self storeServerData:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                    
                    [LoadingManager hide];
                    
                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    if (failure) {
                        failure(error);
                    }
                    
                    [LoadingManager hide];
                }];

                strNetworkType = @"CUSTOM_GET";
                
            }
                break;
                
            case AFNETWORK_CUSTOM_POST:
            {
                
                fullURL = appendString;
                
                [self.manager POST:fullURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    
                    
                    [self storeServerData:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                    
                    [LoadingManager hide];
                    
                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    if (failure) {
                        failure(error);
                    }
                    
                    [LoadingManager hide];
                }];

                strNetworkType = @"CUSTOM_POST";
                
            }
                break;
                
            default:
                break;
        }
        
        SLog(@"\n\n ===== [REQUEST SERVER WITH %@][URL] : %@ \n [REQUEST JSON] : %@\n\n",strNetworkType,fullURL,[parameter bv_jsonStringWithPrettyPrint:YES]);

       
    }
}

-(void)requestServerWithPost:(ServerRequestType)type param:(NSDictionary*)dict appendString:(NSString*)appendString meta:(NSArray*)arrMeta completeHandler:(IDBlock)completeBlock errorBlock:(IErrorBlock)errorBlock
{
//    [LoadingManager show];
    
    if ([self validateBeforeRequest:type]) {
        
        if (errorBlock) {
            errorBlock(nil);
        }
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
    
//    AFHTTPRequestOperation *op = [self.manager POST:fullURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        //do not put image inside parameters dictionary BUT append it
//        
//        for (int i = 0; i<arrMeta.count; i++) {
//            
//            PhotoModel* model = arrMeta[i];
//            [formData appendPartWithFormData:[[@(i+1)stringValue]  dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"photos_meta[%d][position]",i]];
//            [formData appendPartWithFormData:[model.caption?model.caption:@"" dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"photos_meta[%d][caption]",i]];
//            
//            if(model.photo_id)
//            {
//                [formData appendPartWithFormData:[model.photo_id dataUsingEncoding:NSUTF8StringEncoding] name:[NSString stringWithFormat:@"photos_meta[%d][photo_id]",i]];
//                
//            }
//            else{
//                
//                NSData *imageData = UIImageJPEGRepresentation(model.image,0.5);
//                if (imageData) {
//                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"photos[%d]",i] fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//                }
//                
//                
//            }
//            
//        }
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [self storeServerData:responseObject requestType:type withURL:fullURL completionBlock:completeBlock errorBlock:errorBlock];
//        
//        [LoadingManager hide];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        if (errorBlock) {
//           
//            @try {
//                errorBlock(error);
//
//            }
//            @catch (NSException *exception) {
//                
//            }
//           
//        }
//        [self showErrorHandling:operation Error:error];
//
//        [LoadingManager hide];
//        
//        NSLog(@"\n\n  Error: %@ ***** %@", operation.responseString, error);
//    }];
//    
//    
//    
//    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
//        
//    }];
//    
//    [op start];
}


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
            str = [NSString stringWithFormat:@"%@/home/featured-deals", API_VERION_URL];
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
            
        case ServerRequestTypePostReportPost:
            
            str = [NSString stringWithFormat:@"%@/post", API_VERION_URL];
            
            break;
        
        case ServerRequestTypeGetFriendSuggestion:
            str = [NSString stringWithFormat:@"%@/%@/friends", API_VERION_URL, [Utils getUserID]];
            break;
    
        case ServerRequestTypePostFriendSuggestion:
            str = [NSString stringWithFormat:@"%@/%@/post", API_VERION_URL, [Utils getUserID]];
            break;
            
        case ServerRequestTypePostCollectionFriendSuggestion:
            str = [NSString stringWithFormat:@"%@/%@/collections", API_VERION_URL, [Utils getUserID]];
            break;

        case ServerRequestTypePostSeetiesFriendSuggestion:
        case ServerRequestTypePostNonSeetiesFriendSuggestion:
            str = [NSString stringWithFormat:@"%@/seetishops", API_VERION_URL];
            break;
        case ServerRequestTypePostDealFriendSuggestion:
            str = [NSString stringWithFormat:@"%@/deals", API_VERION_URL];
            break;
            
        case ServerRequestTypeGoogleSearchWithDetail:
            
            return GOOGLE_PLACE_DETAILS_API;
            break;
        case ServerRequestTypeGoogleSearch:
            
            return GOOGLE_PLACE_AUTOCOMPLETE_API;
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
//            is_Production?SLog(@"[current app status] : LIVE"):SLog(@"[current app status] : development");
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
    
        [self storeServerData:obj requestType:type];

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
            NSDictionary *dict = obj[@"data"][@"featured_deals"];
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
        case ServerRequestTypePostUpdateUser:
        {
            NSDictionary *dict = obj[@"data"];
            self.dataManager.currentUserProfileModel = [[ProfileModel alloc] initWithDictionary:dict error:nil];
        }
            break;
            
        case ServerRequestTypeGetFriendSuggestion:
        {
            NSDictionary *dict = obj[@"data"];
            self.dataManager.friendSuggestionModel = [[FriendSuggestionModel alloc] initWithDictionary:dict error:nil];
            break;
            
        }
            
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
 
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetAllAppInfo parameter:nil appendString:nil success:^(id object) {

        
        if(completionBlock)
        {
            completionBlock(object);
        }
        
    } failure:^(id object) {
        
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
        case ServerRequestTypePostFollowUser:
        case ServerRequestTypePostFollowCollection:
            
            if ([Utils isGuestMode]) {
                
                flag = true;
                [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Please Login First") cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        [Utils showLogin];
                        
                    }
                }];
            }
            break;
        case ServerRequestTypePostCollectDeals:
        {
            if ([Utils isGuestMode]) {
                flag = true;
                
                [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Please Login First") cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        [Utils showLogin];
                        
                    }
                }];

            }
            
        }
           
            break;
            
        default:
            break;
    }
    
    return flag;
}

#pragma mark  - ERROR handling

//-(void)showErrorHandling:(AFHTTPRequestOperation*)operation Error:(NSError*)error
//{
//    
//    if([operation.response statusCode] == 503)
//    {
//        // Use the appropriate key to get the error data
//        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        
//        // Serialize the data into JSON
//        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
//        
//        // Print out the error JSON body
//        NSLog(@"AFNetworking error response body: %@", serializedData);
//        
//        NSString* code = serializedData[@"error"];
//        NSString* message = serializedData[@"message"];
//
//        if ([code isEqualToString:@"seeties.api.under_maintenance"]) {
//            
//            [Utils showLogin];
//
//            [UIAlertView showWithTitle:LocalisedString(@"system") message:message cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//                
//                
//            }];
//        }
//        else if ([code isEqualToString:@"seeties.apiversion.message"]) {
//         
//            
//            [Utils showLogin];
//            [UIAlertView showWithTitle:LocalisedString(@"system") message:message cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//                
//                if (buttonIndex == 0) {//cancel
//                    
//                }else if(buttonIndex == 1)//route to app store
//                {
//                    _skStoreProductViewController = nil;
//                    
//                    
//                    [Utils presentView:self.skStoreProductViewController Completion:^{
//                        
//                    }];
//                    
//                   // }];
//                    
//                }
//                
//            }];
//        }
//    }
//    
//}

-(SKStoreProductViewController *)skStoreProductViewController{
    if (!_skStoreProductViewController) {
        _skStoreProductViewController = [SKStoreProductViewController new];
        _skStoreProductViewController.delegate = self;
        NSDictionary *parameters = @{ SKStoreProductParameterITunesItemIdentifier:[NSNumber numberWithInteger:ITUNES_ITEM_IDENTIFIER] };
        [_skStoreProductViewController loadProductWithParameters:parameters completionBlock:nil];
    }
    return _skStoreProductViewController;
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [LoadingManager hide];
}

@end