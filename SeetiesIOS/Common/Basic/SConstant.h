//
//  SConstant.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//

#import <Foundation/Foundation.h>

#define API_VERSION @"3.0"

@interface SConstant : NSObject


typedef enum
{
    /*Login*/
    ServerRequestTypeLogin = 1,
    ServerRequestTypeLoginFacebook,
    ServerRequestTypeLoginInstagram,
    ServerRequestTypeRegister,
    ServerRequestTypeGetLogout,
    /*Login*/

    
    ServerRequestTypeGetNewsFeed,
    ServerRequestTypeGetLanguage,
    ServerRequestTypeGetApiVersion,
    ServerRequestTypeGetExplore,
    ServerRequestTypeGoogleSearch,
    ServerRequestType4SquareSearch,
    ServerRequestTypeGoogleSearchWithDetail,
    ServerRequestTypeGetRecommendationDraft,
    ServerRequestTypePostCreatePost,
    ServerRequestTypePostDeletePost,
    ServerRequestTypePostSaveDraft,
    ServerRequestTypeGetPostInfo,
    ServerRequestTypeGetGeoIP,
    ServerRequestTypeGetCategories,
    
    // ========== Collection ========== //
    ServerRequestTypeGetCollectionInfo,
    ServerRequestTypePostCreateCollection,
    ServerRequestTypeGetTagsSuggestion,
    ServerRequestTypeGetUserCollections,
    ServerRequestTypeGetUserFollowingCollections,
    ServerRequestTypeGetUserSuggestedCollections,
    ServerRequestTypeGetUserPosts,
    ServerRequestTypeGetUserLikes,
    ServerRequestTypeDeleteCollection,
    ServerRequestTypePostFollowCollection,
    ServerRequestTypePostShareCollection,
    ServerRequestTypePutCollectPost,
    // ========== Collection ========== //
    // ========== User Info ========== //
    ServerRequestTypeGetUserInfo,
    ServerRequestTypePostFollowUser,
    // ========== User Info ========== //

    
    // ========== SEETIES SHOP ========== //

    ServerRequestTypeGetSeetiShopDetail,
    ServerRequestTypeGetSeetiShopCollection,
    ServerRequestTypeGetSeetiShopPhoto,
    ServerRequestTypeGetSeetoShopNearbyShop,
    ServerRequestTypeGetSeetoShopRecommendations,
    ServerRequestTypeGetSeetoShopTranslation,
    // ========== SEETIES SHOP ========== //
    
    /*LIKE A POST*/
    ServerRequestTypePostLikeAPost,
    ServerRequestTypeDeleteLikeAPost,
    
    /*LIKE A POST*/
    
    
    /*SEARCH*/
    ServerRequestTypeSearchPosts,
    ServerRequestTypeSearchUsers,
    ServerRequestTypeSearchCollections,
    
    /*User Follower / Following*/
    ServerRequestTypeUserFollower,
    ServerRequestTypeUserFollowing,
    
    /*Get Country*/
    ServerRequestTypeGetHomeCountry,
    ServerRequestTypeGetHomeCountryPlace,
    
}ServerRequestType;

typedef enum
{
    ViewTypeNewsFeed = 1,
    ViewTypeExplore = 2,
    ViewTypeNitification = 3,
    ViewTypeExploreProfile
    
}ViewType;

typedef enum
{
    FeedType_Following_Post = 1,
    FeedType_Local_Quality_Post = 2,
    FeedType_Abroad_Quality_Post = 3,
    FeedType_Announcement = 4,
    FeedType_Announcement_Welcome = 5,
    FeedType_Announcement_Campaign = 6,
    FeedType_Suggestion_Featured = 7,
    FeedType_Suggestion_Friend = 8,
    FeedType_Deal = 9,
    FeedType_Invite_Friend = 10,
    FeedType_Country_Promotion = 11,
    FeedType_Collect_Suggestion = 12,
    FeedType_Following_Collection = 13,
    FeedType_Deal_Main = 14,
    FeedType_Deal_QuickBrowse = 15,
    FeedType_Deal_DealOfTheDay = 16,
    FeedType_Deal_YourWallet = 17,
    
    
}FeedType;


typedef enum
{
    AnnouncementType_User = 1,
    AnnouncementType_Post = 2,
    AnnouncementType_URL = 3,
    AnnouncementType_NA = 4
    
}AnnouncementType;

extern NSString *const SERVER_PATH_LINK_LIVE;
extern NSString *const SERVER_PATH_LINK_DEV;
extern NSString *const SERVER_PATH_LIVE;
extern NSString *const SERVER_PATH_DEV;
extern NSString *const SERVER_SUBPATH;
extern NSString *const IP_URL_PATH;


extern NSString *const URL_ABOUT_US;
extern NSString *const URL_TERM_OF_USE;
extern NSString *const URL_PRIVACY_POLICY;

//=============== social media key =================//
extern NSString *const GOOGLE_API_KEY;
extern NSString *const GOOGLE_PLACE_AUTOCOMPLETE_API;
extern NSString *const GOOGLE_PLACE_DETAILS_API;

extern NSString *const kAFAviaryAPIKey;
extern NSString *const kAFAviarySecret;

extern NSString *const Insta_Client_ID;
extern NSString *const Insta_Client_Secret;
extern NSString *const Insta_Client_callback;

@end




#define TOKEN_2_0 @"JDJ5JDEwJDZyamE0MlZKbTNKbHpDSElxR0dpUGVnbkJQMzdzRC40eDJna2M3RlJiVFZVbnJzRVpTQTNt"

// ======================= LANGUAGE CODE ========================//
#define ENGLISH_CODE @"530b0ab26424400c76000003"
#define CHINESE_CODE @"530b0aa16424400c76000002"
#define TAIWAN_CODE @"530d5e9b642440d128000018"
#define INDONESIA_CODE @"53672e863efa3f857f8b4ed2"
#define FILIPINES_CODE @"539fbb273efa3fde3f8b4567"
#define THAI_CODE @"544481503efa3ff1588b4567"
// ======================= LANGUAGE CODE ========================//

// NSUserDefaults keys
#define DEFAULTS_KEY_LANGUAGE_CODE @"LanguageCode" // The key against which to store the selected language code.

/*
 * Custom localised string macro, functioning in a similar way to the standard NSLocalisedString().
 */
#define CustomLocalisedString(key, comment) \
[[LanguageManager sharedLanguageManager] getTranslationForKey:key]
#define LocalisedString(key) \
[[LanguageManager sharedLanguageManager] getTranslationForKey:key]

#define ErrorTitle @"error"
#define GoodNetwork YES

#define BORDER_WIDTH 1.0f

#define NOTIFICAION_TYPE_REFRESH_COLLECTION @"collection"
#define NOTIFICAION_TYPE_REFRESH_POST @"post"
#define NOTIFICAION_TYPE_REFRESH_LIKES @"likes"
#define NOTIFICAION_TYPE_REFRESH_PROFILE @"profile"


// ================== seeties shop ================//
#define VIEW_PADDING 10.0f
#define TRANSITION_DURTION 0.3f


#if TARGET_IPHONE_SIMULATOR
static BOOL IS_SIMULATOR = YES;

#else
static BOOL IS_SIMULATOR = NO;
#endif

/*NSUserDefaults key*/
#define TOKEN @"ExpertToken"
#define USERID @"Useruid"
#define KEY_SYSTEM_LANG @"system_language"

#define KEY_LANGUAGE_ONE @"lang_one"
#define KEY_LANGUAGE_TWO @"lang_two"

/*NSUserDefaults key*/


#pragma mark - DEFINE UI

#define TAB_BAR_HEIGHT 60.0f

#pragma mark - API KEY
#define DEVICE_TYPE 2




