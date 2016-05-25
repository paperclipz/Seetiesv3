//
//  LanguageManager.h
//  Language Changer
//
//  Created by Alan Chung on 25/11/2014.
//  Copyright (c) 2014 Alan Chung. All rights reserved.
//
//  Singleton that manages the language selection and translations for strings in the app.
//

#import <Foundation/Foundation.h>

@class Locale;

@interface LanguageManager : NSObject

@property (nonatomic, copy) NSArray *availableLocales;

+ (LanguageManager *)sharedLanguageManager;
//- (void)setLanguageWithLocale:(Locale *)locale;
- (NSString *)getTranslationForKey:(NSString *)key;
+(NSString*)stringForKey:(NSString*)cKey withPlaceHolder:(NSDictionary*)dict;



+(NSString*)getDeviceAppLanguageCode;
+(NSString*)getDeviceDefaultLanguageCode;
+(void)setDeviceAppLanguage:(NSString*)languageCode;

// code are of server and local code not app code (app code refer to long string of numerics)
+(NSString*)getAppServerCode;
+(NSString*)convertLocalCodeToServer:(NSString*)localCode;

@end
