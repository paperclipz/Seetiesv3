//
//  SConstant.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//

#import <Foundation/Foundation.h>


@interface SConstant : NSObject


typedef enum
{
    ServerRequestTypeDefault,
    /*Login*/
    ServerRequestTypeLogin = 1,
    ServerRequestTypeLoginFacebook,
    ServerRequestTypeLoginInstagram,
    ServerRequestTypeRegister,
    ServerRequestTypeGetLogout,
    ServerRequestTypePostCheckUserRegistrationData,
    ServerRequestTypePostForgotPassword,
    /*Login*/

    ServerRequestTypeGetNewsFeed,
    ServerRequestTypeGetAllAppInfo,
    ServerRequestTypePostProvisioning,
    ServerRequestTypeGetLanguage,
    ServerRequestTypeGetCategory,
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
    ServerRequestTypeGetPlacesSuggestion,
    
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
    ServerRequestTypePostUpdateUser,
    
    // ========== User Info ========== //

    
    // ========== SEETIES SHOP ========== //

    ServerRequestTypeGetSeetiShopDetail,
    ServerRequestTypeGetSeetiShopCollection,
    ServerRequestTypeGetSeetiShopPhoto,
    ServerRequestTypeGetSeetoShopNearbyShop,
    ServerRequestTypeGetSeetoShopRecommendations,
    ServerRequestTypeGetSeetoShopTranslation,
    ServerRequestTypeGetSeetiShopDeal,
    // ========== SEETIES SHOP ========== //
    
    /*LIKE A POST*/
    ServerRequestTypePostLikeAPost,
    ServerRequestTypeDeleteLikeAPost,
    
    /*LIKE A POST*/
    
    
    /*SEARCH*/
    ServerRequestTypeSearchPosts,
    ServerRequestTypeSearchUsers,
    ServerRequestTypeSearchCollections,
    ServerRequestTypeSearchShops,

    /*User Follower / Following*/
    ServerRequestTypeUserFollower,
    ServerRequestTypeUserFollowing,
    
    /*Get Country*/
    ServerRequestTypeGetHomeCountry,
    ServerRequestTypeGetHomeCountryPlace,
    
    /*HOME*/
    ServerRequestTypeGetHome,
    ServerRequestTypeGetHomeSuperDeal,
    ServerRequestTypeGetHomeUpdater,
    
    //===DEALS===//
    ServerRequestTypeGetDealCollectionDeals,
    ServerRequestTypeGetSuperDeals,
    ServerRequestTypePostCollectDeals,
    ServerRequestTypeGetDealInfo,
    ServerRequestTypeGetDealRelevantDeals,
    ServerRequestTypeGetVoucherInfo,
    ServerRequestTypeGetUserVouchersList,
    ServerRequestTypeDeleteVoucher,
    ServerRequestTypeGetUserVouchersCount,
    ServerRequestTypePutRedeemVoucher,
    ServerRequestTypeGetUserVouchersHistoryList,
    ServerRequestTypeGetDealCollectionInfo,
    
    /*Notifications*/
    ServerRequestTypeGetFollowingNotifictions,
    ServerRequestTypeGetNotifications,
    ServerRequestTypeGetNotificationCount,
    /*Notifications*/

    //===TOTP===//
    ServerRequestTypePostTOTP,
    ServerRequestTypePostVerifyTOTP,
    //===TOTP===//
    
    //===PromoCode===//
    ServerRequestTypeGetPromoCode,
    ServerRequestTypePostRedeemPromoCode,
    //===PromoCode===//
    /*Report Shop*/
    ServerRequestTypePostReportShop,
    ServerRequestTypePostReportDeal,
    ServerRequestTypePostReportPost,
    /*Report Shop*/
    
    //** GetFriendSuggestion **//
    ServerRequestTypeGetFriendSuggestion,
    //** GetFriendSuggestion **//
    
    //** PostFriendSuggestion **//
    ServerRequestTypePostFriendSuggestion,
    ServerRequestTypePostCollectionFriendSuggestion,
    ServerRequestTypePostSeetiesFriendSuggestion,
    ServerRequestTypePostNonSeetiesFriendSuggestion,
    ServerRequestTypePostDealFriendSuggestion,
    //** PostFriendSuggestion **//

    //** EditProfile **//
    ServerRequestTypePostUserProfile
    //** EditProfile **//
    
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
 //   FeedType_Deal = 9,
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
    AnnouncementType_Promo = 4,
    AnnouncementType_Referral = 5,
    AnnouncementType_NA = 6
    
}AnnouncementType;

typedef enum
{
    DealType_Announcement = 1,
    DealType_Collection = 2,
    DealType_SuperDeal = 3,
    DealType_Greeting = 4,
    DealType_QuickBrowse = 5,
    DealType_Wallet = 6,
    DealType_ReferFriends = 7,
    
}DealType;


typedef enum
{
    NotificationType_Follow = 1,
    NotificationType_Like = 2,
    NotificationType_Mention = 3,
    NotificationType_Comment = 4,
    NotificationType_Collect = 5,
    NotificationType_PostShared = 6,
    NotificationType_CollectionShared = 7,
    NotificationType_CollectionFollow = 8,
    NotificationType_Seeties = 9,
    NotificationType_SeetiesShared = 10,
    NotificationType_Post = 11,
    NotificationType_None = 12,
    NotificationType_User = 13,
    NotificationType_DealShared = 14,
    NotificationType_ReferralReward = 15,
    NotificationType_Phone_Verification = 16,
    
}NotificationType;

extern NSString *const SERVER_PATH_LINK_LIVE;
extern NSString *const SERVER_PATH_LINK_DEV;
extern NSString *const SERVER_PATH_LIVE;
extern NSString *const SERVER_PATH_DEV;
extern NSString *const SERVER_SUBPATH;
extern NSString *const IP_URL_PATH;

extern NSString *const URL_RATE_US;
extern NSString *const URL_ABOUT_US;
extern NSString *const URL_TERM_OF_USE;
extern NSString *const URL_PRIVACY_POLICY;

extern NSInteger const ITUNES_ITEM_IDENTIFIER;

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
//#define DEFAULTS_KEY_LANGUAGE_CODE @"LanguageCode" // The key against which to store the selected language code.

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
#define KEY_PRODUCTION @"production_indicator"

#define KEY_LANGUAGE_ONE @"lang_one"
#define KEY_LANGUAGE_TWO @"lang_two"

#define FIRST_TIME_SHOW_DEAL_WALKTHROUGH @"FIRST_TIME_SHOW_WALKTHROUGH"
#define FIRST_TIME_SHOW_DEAL_WARNING @"FIRST_TIME_SHOW_WARNING"

/*NSUserDefaults key*/


#pragma mark - DEFINE UI

#define TAB_BAR_HEIGHT 60.0f

#pragma mark - API KEY
#define DEVICE_TYPE 2

//Share path
#define PRODUCTION_BASE_PATH @"https://seeties.me/"
#define DEVELOPMENT_BASE_PATH @"https://itcave2.seeties.me/"



