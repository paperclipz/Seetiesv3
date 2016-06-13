//
//  Utils.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DealModel;
@interface Utils : NSObject
#define MaxDistance 30000


// ======================== STTRING SWITCH CASE ========================
#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

// ======================== STTRING SWITCH CASE ========================

typedef void(^ButtonBlock) (id sender);
typedef void(^NullBlock) (void);

typedef enum
{
    ShareTypePost,
    ShareTypeCollection,
    ShareTypePostUser,
    ShareTypeSeetiesShop,
    ShareTypeNonSeetiesShop,
    ShareTypeDeal,
    ShareTypeInvite,
    ShareTypeReferralInvite
} ShareType;


typedef enum
{
    ENGLISH = 0,
    MALAY = 1,
    CHINESE = 2
} Language;

typedef enum
{
    SearchTypeGoogle = 2,
    SearchTypeFourSquare = 1,
    SearchTypeSeeties = 5,
    SearchTypeDefault = 4
    
}SearchType;
typedef enum
{
    PlaceViewTypeEdit = 0,
    PlaceViewTypeNew = 1
    
} PlaceViewType;

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

typedef enum {

    ProfileViewTypeOthers,
    ProfileViewTypeOwn,

    
} ProfileViewType;

typedef enum {
    
    CollectionListingTypeMyOwn,
    CollectionListingTypeFollowing,
    CollectionListingTypeSuggestion,
    CollectionListingTypeTrending,
    CollectionListingTypeSeetiesShop
    
} CollectionListingType;

typedef enum {
    
    UsersListingTypeFollower,
    UsersListingTypeFollowing

    
} UsersListingType;

typedef enum {
    
    SearchListingTypeShop,
    SearchsListingTypeCollections,
    SearchsListingTypePosts,
    SearchsListingTypeSeetizens
    
    
} SearchListingType;

typedef enum {
    
    SeetiesShopTypeDetail,
    SeetiesShopTypeMap,
    SeetiesShopTypeDeal,
    SeetiesShopTypeCollections,
    SeetiesShopTypeRecommendation,
    SeetiesShopTypeNearbyShop
    
}SeetiesShopType;

//typedef enum {
//    
//    IsSeetiesShop,
//    NonSeetiesShop,
//    
//}SeetiesShopVerifyType;

#pragma mark - app utils
+(BOOL)isLogin;
+(NSString*)getAppToken;
+(NSString*)getUserID;
+(BOOL)isGuestMode;
+(BOOL)checkUserIsLogin;//new check user login using token
+(void)setLogout;

+(void)reloadAppView:(BOOL)navigateToHome;
+(void)reloadProfileView;
+(void)reloadHomeView:(int)type;
+(void)reloadTabbar;

+(NSData*)getParseToken;
+(void)setParseToken:(NSData*)data;
+(void)registerParseAfterLogin:(NSString*)userID;
+(BOOL)isPhoneNumberVerified;
+(BOOL)hasReferralCampaign;

#define UIColorFromRGB(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define DEFAULT_BORDER_RADIUS 5.0f



+(CGRect)getDeviceScreenSize;
#define DEVICE_COLOR [UIColor colorWithRed: 41.0 / 255 green: 182.0 / 255 blue: 246.0 / 255 alpha: 1.0]
#define TEXT_GRAY_COLOR [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]
#define TWO_ZERO_FOUR_COLOR [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0]
#define ONE_ZERO_TWO_COLOR [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]
#define TWO_FOUR_FIVE_COLOR [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]

#define SELECTED_GREEN [UIColor colorWithRed:156.0f/255.0 green:204.0f/255.0 blue:101.0f/255.0 alpha:1.0]
#define SELECTED_RED [UIColor colorWithRed:226.0/255.0 green:60.0/255.0 blue:78.0/255.0 alpha:1.0]
#define SELECTED_YELLOW [UIColor colorWithRed:250.0/255.0 green:221.0/255.0 blue:96.0/255.0 alpha:1.0]

#define LINE_COLOR [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]
#define ERROR_COLOR [UIColor colorWithRed:239.0/255.0 green:94.0/255.0 blue:65.0/255.0 alpha:1.0]
#define OUTLINE_COLOR [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]


#define GREEN_STATUS [UIColor colorWithRed:122.0f/255.0 green:210.0f/255.0 blue:26.0f/255.0 alpha:1.0]
#define GREY_APP_COLOR [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]

#define BUTTON_DISABLED_COLOR [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]
#define BUTTON_REDEEM_ACTIVE_COLOR [UIColor colorWithRed:242.0/255.0f green:109.0/255.0f blue:125.0/255.f alpha:1.0]

#define CustomFontName @"ProximaNovaSoft-Regular"
#define CustomFontNameBold @"ProximaNovaSoft-Bold"
#define REGULAR @"Regular"
#define BOLD @"Bold"
#define ANIMATION_DURATION 0.5f

// ========================  Day ==========================

+(NSString*)getWeekName:(int)integer;
+(int)getWeekInteger:(NSString*)week;
+(NSString*)getTimeZone;
+(NSInteger)numberOfDaysLeft:(NSDate*)date;
+(BOOL)isValidDateString:(NSString*)dateString;
//Compare date only (exclude time)
+(BOOL)isDate:(NSDate*)currentDate betweenFirstDate:(NSDate*)firstDate andLastDate:(NSDate*)lastDate;
//Compare both date and time
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
// ========================  Day ==========================

#pragma mark - UI
+(void)setButtonWithBorder:button;
+(void)setButtonWithBorder:(UIButton*)button color:(UIColor*)color;
+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius;
+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius borderWidth:(float)borderWidth;
+(UIImage*)getPlaceHolderImage;
+(UIImage*)getProfilePlaceHolderImage;
+(UIImage*)getShopPlaceHolderImage;
+(UIImage*)getCoverPlaceHolderImage;

// ========================  FONT ==========================
+(UIFont*)defaultFont;
+(UIColor*)defaultTextColor;
// ========================  font ==========================


// =====================  VALIDATION =======================
+ (BOOL) validateUrl: (NSString *) candidat;
+ (BOOL) validateEmail: (NSString *) candidate;

// =====================  Validation =======================



// =====================  CURRENCY =========================
#pragma mark - CURRENCY
+(NSString*)currencyCode:(NSString*)currency;
+(NSString*)currencyString:(NSString*)code;

#define USD @"USD"
#define THB @"THB"
#define IDR @"IDR"
#define SGD @"SGD"
#define TWD @"TWD"
#define PHP @"PHP"
#define MYR @"MYR"

+(NSString*)getLanguageName:(NSString*)code;
+(NSString*)getLanguageCode:(NSString*)name;
+(NSString*)getLanguageCodeFromLocale:(NSString*)shortName;

// =====================  currency =========================

#pragma mark - JSON CONVERTER
+(NSString*)convertToJsonString:(NSDictionary*)dict;
+(BOOL)stringIsNilOrEmpty:(NSString*)aString;
+(NSURL*)getPrefixedURLFromString:(NSString*)url;
+(BOOL)isStringNull:(NSString*)str;
+(BOOL)isArrayNull:(NSArray*)array;

+(NSString*)getDistance:(float)distance Locality:(NSString*)local;

+(NSString*)getUniqueDeviceIdentifier;

#define ARRAY_LIST_SIZE 10.0f
#define LIKES_LIST_SIZE 30.0f

// seeties shop model
#define BestKnowFor @"Best known for"
#define PriceKey @"Price"
#define HoursKey @"Hours"
#define Phone_Number @"Phone Number"
#define URL_Link @"URL/Link"
#define FACEBOOK @"Facebook"
#define Nearby_Public_Transport @"nearby_public_transport"
#define Recommended_Information @"recommended_information"

//#define USER_SYSTEM_LANGUAGE_CODE @"user_system_language_code"

// ======================================   Prompt Message      ============================
#define SUCCESSFUL_COLLECTED @"Successful Collected"
#define SUCCESSFUL_FOLLOWED @"Successful Followed"

#pragma mark - LOGIN
+(void)showLogin;
+(void)showVerifyPhoneNumber:(UIViewController*)viewController;
+(void)showChangeVerifiedPhoneNumber:(UIViewController*)viewController;
+(void)presentView:(UIViewController*)vc Completion:(NullBlock)completionBlock;


#pragma mark - SYSTEM
+(BOOL)isAppProductionBuild;
+(void)setIsDevelopment:(BOOL)isDev;
+(BOOL)getIsDevelopment;

#pragma mark - LOCATION
#define KEY_USER_PREF_MAIN_KEY @"user_pref_key"
#define KEY_LATITUDE @"latitude_key"
#define KEY_LONGTITUDE @"longtitude_key"
#define KEY_LOCATION @"location_key"
#define KEY_PLACE_ID @"place_id_key"
#define KEY_COUNTRY_ID @"country_id_key"
#define KEY_SOURCE_TYPE @"source_type_key"

+(NSDictionary*)getSavedUserLocation;
+(void)saveUserLocation:(NSString*)location Longtitude:(NSString*)longtitude Latitude:(NSString*)latitude PlaceID:(NSString*)place_id CountryID:(int)countryId SourceType:(NSString*)type;


#pragma mark - LANGUAGE
#define ENGLISH_CODE @"530b0ab26424400c76000003"
#define CHINESE_CODE @"530b0aa16424400c76000002"
#define TAIWAN_CODE @"530d5e9b642440d128000018"
#define INDONESIA_CODE @"53672e863efa3f857f8b4ed2"
#define FILIPINES_CODE @"539fbb273efa3fde3f8b4567"
#define THAI_CODE @"544481503efa3ff1588b4567"

#define ENGLISH_SHORT_NAME @"en"
#define CHINESE_SHORT_NAME @"zh-Hans"
#define TAIWAN_SHORT_NAME @"zh-Hant"
#define INDONESIA_SHORT_NAME @"id"
#define FILIPINES_SHORT_NAME @"tl-PH"
#define THAI_SHORT_NAME @"th"


#define ENGLISH_SERVER_NAME @"en"
#define CHINESE_SERVER_NAME @"zh_CN"
#define TAIWAN_SERVER_NAME @"zh_TW"
#define INDONESIA_SERVER_NAME @"in"
#define FILIPINES_SERVER_NAME @"tl-PH"
#define THAI_SERVER_NAME @"th"

#define TAIWAN_STR @"繁體中文"
#define CHINESE_STR @"简体中文"
#define CHINESE_CENTRAL @"中文 "

#pragma mark - NOTIFICATION
+(void)startNotification;
+(void)requestServerForNotificationCount;


#pragma mark - ColorHex
+(UIColor*)colorWithHexString:(NSString*)hex;


#pragma mark - Storyboard
#define StoryBoardNameAndViewControlIdentifier(storyboardName, identifier) [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:identifier]

#define Storyboard_Collection @"Collection"

@end
