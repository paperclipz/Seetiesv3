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
    ServerRequestTypeGetExplore = 5
    
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


@end

#ifndef Language_Changer_Constants_h
#define Language_Changer_Constants_h

// NSUserDefaults keys
#define DEFAULTS_KEY_LANGUAGE_CODE @"LanguageCode" // The key against which to store the selected language code.

/*
 * Custom localised string macro, functioning in a similar way to the standard NSLocalisedString().
 */
#define CustomLocalisedString(key, comment) \
[[LanguageManager sharedLanguageManager] getTranslationForKey:key]


#define ErrorTitle @"Error"
#endif

