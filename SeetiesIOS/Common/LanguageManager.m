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
//        Locale *english = [[Locale alloc] initWithLanguageCode:@"en" countryCode:@"gb" name:@"English"];
//        Locale *cn_simplified = [[Locale alloc] initWithLanguageCode:@"zh-Hans" countryCode:@"fr" name:@"Simplified Chinese"];
//        Locale *cn_traditional = [[Locale alloc] initWithLanguageCode:@"zh-Hant" countryCode:@"de" name:@"Traditional Chinese"];
//        Locale *indonesian = [[Locale alloc] initWithLanguageCode:@"id" countryCode:@"it" name:@"Bahasa Indonesia"];
//        Locale *thai = [[Locale alloc] initWithLanguageCode:@"th" countryCode:@"jp" name:@"Thai"];
//        Locale *philippines = [[Locale alloc] initWithLanguageCode:@"tl-PH" countryCode:@"jp" name:@"Filipino"];
//        self.availableLocales = @[english, cn_simplified, cn_traditional, indonesian, thai,philippines];
        
        Locale *english = [[Locale alloc] initWithLanguageCode:@"en" countryCode:@"gb" name:@"English"];
        Locale *cn_simplified = [[Locale alloc] initWithLanguageCode:@"zh-Hans" countryCode:@"fr" name:@"Simplified Chinese"];
        Locale *cn_traditional = [[Locale alloc] initWithLanguageCode:@"zh-Hant" countryCode:@"de" name:@"Traditional Chinese"];
        Locale *indonesian = [[Locale alloc] initWithLanguageCode:@"id" countryCode:@"it" name:@"Bahasa Indonesia"];
        Locale *thai = [[Locale alloc] initWithLanguageCode:@"th" countryCode:@"jp" name:@"Thai"];
        Locale *philippines = [[Locale alloc] initWithLanguageCode:@"tl-PH" countryCode:@"jp" name:@"Filipino"];
        self.availableLocales = @[english, cn_simplified, cn_traditional, indonesian, thai,philippines];
    }
    
    return self;
}

#pragma mark - Methods

/*!
 * @function setLanguageWithLocalisation:
 *
 * @abstract
 * Sets the language code string in the user defaults, based on the given Localisation object.
 *
 * @param localisation
 * The localisation object whose language code we are storing in the user defaults.
 */
- (void)setLanguageWithLocale:(Locale *)locale {
    
    [[NSUserDefaults standardUserDefaults] setObject:locale.languageCode forKey:KEY_SYSTEM_LANG];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*!
 * @function getSelectedLocalisation
 *
 * @abstract
 * Get the localisation object from the list of available localisations that matches the language code
 * stored in the user defaults.
 *
 * @return
 * The Localisation object based on the language code stored in the user defaults.
 *
 * @discussion
 * Returns nil if a language code has not been set in the user defaults.
 */
- (Locale *)getSelectedLocale {
    
    Locale *selectedLocale = nil;
    
    // Get the language code.
    NSString *languageCode = [[[NSUserDefaults standardUserDefaults] stringForKey:KEY_SYSTEM_LANG] lowercaseString];
    
    // Iterate through available localisations to find the one that matches languageCode.
    for (Locale *locale in self.availableLocales) {
        
        if ([locale.languageCode caseInsensitiveCompare:languageCode] == NSOrderedSame) {
            
            selectedLocale = locale;
            break;
        }
    }
    
    return selectedLocale;
}

/*!
 * @function getTranslationForKey:
 *
 * @abstract
 * Return a translated string for the given string key.
 *
 * @param key
 * The key of the string whose translation we want to look up.
 *
 * @return
 * The translated string for the given key.
 *
 * @discussion
 * Uses the string stored in the user defaults to determine which language to translate to. Translations for
 * keys are found in the Localisable.strings files in the relevant .lproj folder for the selected language.
 */
#define LANG_EN @"en"
#define LANG_TW @"zh_TW"
#define LANG_ZH_CN @"zh_CN"
#define LANG_IN @"in"
#define LANG_TH @"th"

-(NSString*)convertCodeFromServerToLocal:(NSString*)serverCode
{

   
    
    if ([serverCode isEqualToString:LANG_TW])
    {
        return @"zh-Hant";

    }
    else if ([serverCode isEqualToString:LANG_ZH_CN])
    {
        return @"zh-Hans";

    }
    else if ([serverCode isEqualToString:LANG_IN])
    {
        return @"id";
        
    }
    
    else if ([serverCode isEqualToString:LANG_TH])
    {
        return @"th";
    }
    else
    {
        return @"en";
    }

}
- (NSString *)getTranslationForKey:(NSString *)key {
    
    NSString *languageCode = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_SYSTEM_LANG];

    NSString* localCode = [self convertCodeFromServerToLocal:languageCode];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:localCode ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:bundlePath];
  //  NSLog(@"bundlePath is %@",bundlePath);
  //  NSLog(@"languageBundle is %@",languageBundle);
    // Get the translated string using the language bundle.
    NSString *translatedString = [languageBundle localizedStringForKey:key value:@"" table:nil];
   // NSLog(@"translatedString is %@",translatedString);
    if (translatedString.length < 1) {
        
        // There is no localizable strings file for the selected language.
        translatedString = NSLocalizedStringWithDefaultValue(key, nil, [NSBundle mainBundle], key, key);
    }
    
    return translatedString;
}


// language code in KEY_SYSTEM_LANG is the code from server not from local. everytime using it need to convert server to local code first
- (void)setLanguageCode:(NSString*)code {
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:code?code:ENGLISH_SHORT_NAME forKey:KEY_SYSTEM_LANG];
    
    [userDefault synchronize];
}

+(NSString*)stringForKey:(NSString*)key withPlaceHolder:(NSDictionary*)dict
{
    NSString* str = LocalisedString(key);
    
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
    
    return str;
}

@end
