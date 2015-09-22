//
//  SConstant.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//

#import <Foundation/Foundation.h>

#define API_VERSION @"1.3"

@interface SConstant : NSObject


typedef enum
{
    ServerRequestTypeLogin = 1,
    ServerRequestTypeNewsFeed = 2,
    ServerRequestTypeGetLanguage = 3,
    ServerRequestTypeGetApiVersion = 4,
    ServerRequestTypeGetExplore = 5,
    ServerRequestTypeGoogleSearch,
    ServerRequestType4SquareSearch,
    ServerRequestTypeGoogleSearchWithDetail,
    ServerRequestTypeGetRecommendationDraft,
    ServerRequestTypePostCreatePost,
    ServerRequestTypePostDeletePost,
    ServerRequestTypeGetGeoIP,
    ServerRequestTypeGetCategories
    
}ServerRequestType;

typedef enum
{
    ViewTypeNewsFeed = 1,
    ViewTypeExplore = 2,
    ViewTypeNitification = 3,
    ViewTypeExploreProfile
    
}ViewType;

extern NSString *const SERVER_PATH_LIVE;
extern NSString *const SERVER_PATH_DEV;
extern NSString *const SERVER_SUBPATH;
extern NSString *const IP_URL_PATH;

//=============== social media key =================//
extern NSString *const GOOGLE_API_KEY;
extern NSString *const GOOGLE_PLACE_AUTOCOMPLETE_API;
extern NSString *const GOOGLE_PLACE_DETAILS_API;

extern NSString *const kAFAviaryAPIKey;
extern NSString *const kAFAviarySecret;

@end

#define TOKEN_2_0 @"JDJ5JDEwJDZyamE0MlZKbTNKbHpDSElxR0dpUGVnbkJQMzdzRC40eDJna2M3RlJiVFZVbnJzRVpTQTNt"


#ifndef Language_Changer_Constants_h
#define Language_Changer_Constants_h

#define ENGLISH_CODE @"530b0ab26424400c76000003"
#define CHINESE_CODE @"530b0aa16424400c76000002"
#define TAIWAN_CODE @"530d5e9b642440d128000018"
#define INDONESIA_CODE @"53672e863efa3f857f8b4ed2"
#define FILIPINES_CODE @"539fbb273efa3fde3f8b4567"
#define THAI_CODE @"544481503efa3ff1588b4567"

// NSUserDefaults keys
#define DEFAULTS_KEY_LANGUAGE_CODE @"LanguageCode" // The key against which to store the selected language code.

/*
 * Custom localised string macro, functioning in a similar way to the standard NSLocalisedString().
 */
#define CustomLocalisedString(key, comment) \
[[LanguageManager sharedLanguageManager] getTranslationForKey:key]
#define LocalisedString(key) \
[[LanguageManager sharedLanguageManager] getTranslationForKey:key]

#define ErrorTitle @"Error"
#define GoodNetwork YES
#endif

