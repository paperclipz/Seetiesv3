//
//  LanguageManager.m
//  Language Changer
//
//  Created by Alan Chung on 25/11/2014.
//  Copyright (c) 2014 Alan Chung. All rights reserved.
//
//  Singleton that manages the language selection and translations for strings in the app.
//

#import "LanguageManager.h"
#import "Locale.h"
#import "Utils.h"

@implementation LanguageManager

#pragma mark - Object Lifecycle
+ (LanguageManager *)sharedLanguageManager {
    
    // Create a singleton.
    static dispatch_once_t once;
    static LanguageManager *languageManager;
    dispatch_once(&once, ^ { languageManager = [[LanguageManager alloc] init]; });
    return languageManager;
}

- (id)init {
    
    if (self = [super init]) {
        

        // Manually create a list of available localisations for this example project.

        Locale *english = [[Locale alloc] initWithLanguageCode:ENGLISH_SERVER_NAME countryCode:@"gb" name:@"English"];
        Locale *cn_simplified = [[Locale alloc] initWithLanguageCode:CHINESE_SERVER_NAME countryCode:@"fr" name:@"Simplified Chinese"];
        Locale *cn_traditional = [[Locale alloc] initWithLanguageCode:TAIWAN_SERVER_NAME countryCode:@"de" name:@"Traditional Chinese"];
        Locale *indonesian = [[Locale alloc] initWithLanguageCode:INDONESIA_SERVER_NAME countryCode:@"it" name:@"Bahasa Indonesia"];
        Locale *thai = [[Locale alloc] initWithLanguageCode:THAI_SERVER_NAME countryCode:@"jp" name:@"Thai"];
        Locale *philippines = [[Locale alloc] initWithLanguageCode:FILIPINES_SERVER_NAME countryCode:@"jp" name:@"Filipino"];
        
        self.availableLocales = @[english, cn_simplified, cn_traditional, indonesian, thai,philippines];
    }
    
    return self;
}

#pragma mark - Methods

-(NSString*)convertCodeFromServerToLocal:(NSString*)serverCode
{
    
    if ([serverCode isEqualToString:TAIWAN_SERVER_NAME])
    {
        return TAIWAN_SHORT_NAME;

    }
    else if ([serverCode isEqualToString:CHINESE_SERVER_NAME])
    {
        return CHINESE_SHORT_NAME;

    }
    else if ([serverCode isEqualToString:INDONESIA_SERVER_NAME])
    {
        return INDONESIA_SHORT_NAME;
        
    }
    
    else if ([serverCode isEqualToString:THAI_SERVER_NAME])
    {
        return THAI_SHORT_NAME;
    }
    else if ([serverCode isEqualToString:FILIPINES_SERVER_NAME])
    {
        return FILIPINES_SHORT_NAME;
    }    
    else
    {
        return ENGLISH_SHORT_NAME;
    }

}
- (NSString *)getTranslationForKey:(NSString *)key {
    
    NSString *languageCode = [LanguageManager getAppServerCode];
    NSString* localCode = [self convertCodeFromServerToLocal:languageCode];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:localCode ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:bundlePath];
     NSString *translatedString = [languageBundle localizedStringForKey:key value:@"" table:nil];
    if (translatedString.length < 1) {
        
        // There is no localizable strings file for the selected language.
        translatedString = NSLocalizedStringWithDefaultValue(key, nil, [NSBundle mainBundle], key, key);
    }
    
    return translatedString;
}

+(NSString*)stringForKey:(NSString*)cKey withPlaceHolder:(NSDictionary*)dict
{
    NSString* str = LocalisedString(cKey);

    if (str && dict) {
  
        for (NSString *key in dict.allKeys) {
            @try {
                
                if ([dict[key] isKindOfClass:[NSString class]]) {
                    str = [str stringByReplacingOccurrencesOfString:key withString:dict[key]];
                }
                else {
                    str = [str stringByReplacingOccurrencesOfString:key withString:[dict[key] stringValue]];
                }
                
            } @catch (NSException *exception) {
                SLog(@"Language manager error key: %@", key);
            }
            
        }
    }
  
    
    
    
    return str;
}

#pragma mark - Language Support
//KEY_SYSTEM_LANG save server code exp "EN" , "IN"
+(NSString*)getDeviceAppLanguageCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* userLanguage = [defaults objectForKey:KEY_SYSTEM_LANG];
    
    if ([Utils isStringNull:userLanguage]) {
        userLanguage = [LanguageManager getDeviceDefaultLanguageCode];
        
        return userLanguage;
    }
    
    if (userLanguage) {
        if ([userLanguage isEqualToString:@"English"] || [userLanguage isEqualToString:ENGLISH_SERVER_NAME]) {
            
            return ENGLISH_CODE;
        }else if([userLanguage isEqualToString:@"Simplified Chinese"] || [userLanguage isEqualToString:@"简体中文"] || [userLanguage isEqualToString:CHINESE_SERVER_NAME] || [userLanguage isEqualToString:CHINESE_SHORT_NAME]){
            return CHINESE_CODE;
            
        }else if([userLanguage isEqualToString:@"Traditional Chinese"] || [userLanguage isEqualToString:@"繁體中文"] || [userLanguage isEqualToString:TAIWAN_SERVER_NAME] || [userLanguage isEqualToString:TAIWAN_SHORT_NAME]){
            
            return TAIWAN_CODE;
            
        }else if([userLanguage isEqualToString:@"Bahasa Indonesia"] || [userLanguage isEqualToString:INDONESIA_SERVER_NAME] || [userLanguage isEqualToString:INDONESIA_SHORT_NAME] ){
            
            return INDONESIA_CODE;
            
        }else if([userLanguage isEqualToString:@"Thai"] || [userLanguage isEqualToString:@"th"] || [userLanguage isEqualToString:@"ภาษาไทย"] || [userLanguage isEqualToString:THAI_SERVER_NAME]){
            return THAI_CODE;
        }
    }
    return ENGLISH_CODE;
    
}

+(NSString*)getAppServerCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* userLanguage = [defaults objectForKey:KEY_SYSTEM_LANG];

    if ([Utils isStringNull:userLanguage]) {
      
        NSLocale *currentLocale = [NSLocale currentLocale];
        
        NSString* deviceLanguageCode = [currentLocale objectForKey:NSLocaleLanguageCode];
        
        NSString* serverLanguageCode = [LanguageManager convertLocalCodeToServer:deviceLanguageCode];
        
        userLanguage = serverLanguageCode;
    }
    
    return userLanguage;
}
// language code is of server code
+(void)setDeviceAppLanguage:(NSString*)languageCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:languageCode?languageCode:ENGLISH_SERVER_NAME forKey:KEY_SYSTEM_LANG];
    
    [defaults synchronize];
    
    
}

/*get device language not app language*/
+(NSString*)getDeviceDefaultLanguageCode
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    return  [Utils getLanguageCodeFromLocale:language];
    
}

+(NSString*)convertLocalCodeToServer:(NSString*)localCode
{
    
    if ([localCode isEqualToString:@"zh"])
    {
        return CHINESE_SERVER_NAME;
        
    }
//    else if ([localCode isEqualToString:@"zh"])
//    {
//        return CHINESE_SERVER_NAME;
//        
//    }
    else if ([localCode isEqualToString:@"id"])
    {
        return INDONESIA_SERVER_NAME;
        
    }
    
    else if ([localCode isEqualToString:@"th"])
    {
        return THAI_SERVER_NAME;
    }
//    else if ([localCode isEqualToString:@"ph"])
//    {
//        return FILIPINES_SERVER_NAME;
//    }
    else
    {
        return ENGLISH_SERVER_NAME;
    }
    
}

@end
