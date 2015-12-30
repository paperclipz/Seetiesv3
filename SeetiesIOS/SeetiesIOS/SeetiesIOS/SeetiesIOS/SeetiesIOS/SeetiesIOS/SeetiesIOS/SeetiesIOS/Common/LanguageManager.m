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
    
    [[NSUserDefaults standardUserDefaults] setObject:locale.languageCode forKey:DEFAULTS_KEY_LANGUAGE_CODE];
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
    NSString *languageCode = [[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE] lowercaseString];
    
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
- (NSString *)getTranslationForKey:(NSString *)key {
    
    NSString *languageCode = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];

    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:languageCode ofType:@"lproj"];
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

@end
