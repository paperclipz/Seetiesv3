//
//  Localisator.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOCALIZATION(text) [[Localisator sharedInstance] localizedStringForKey:(text)]
#define SETLANGUAGE(text) [[Localisator sharedInstance] setLanguage:(text)]

static NSString * const kNotificationLanguageChanged = @"kNotificationLanguageChanged";

@interface Localisator : NSObject

@property (nonatomic, strong) NSArray* availableLanguages;
@property (nonatomic, assign) BOOL saveInUserDefaults;
@property NSString * currentLanguage;

+ (Localisator*)sharedInstance;
-(NSString *)localizedStringForKey:(NSString*)key;
-(BOOL)setLanguage:(NSString*)newLanguage;

@end
