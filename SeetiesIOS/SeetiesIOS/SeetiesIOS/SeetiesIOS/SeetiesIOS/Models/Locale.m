//
//  Localisation.m
//  Language Changer
//
//  Created by Alan Chung on 25/11/2014.
//  Copyright (c) 2014 Alan Chung. All rights reserved.
//
//  Object representing a locale, containing a language code, country code and name.
//

#import "Locale.h"

@implementation Locale

- (id)initWithLanguageCode:(NSString *)languageCode countryCode:(NSString *)countryCode name:(NSString *)name {
    
    if (self = [super init]) {
        
        self.languageCode = languageCode;
        self.countryCode = countryCode;
        self.name = name;
    }
    
    return self;
}

@end
