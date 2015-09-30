//
//  Localisation.h
//  Language Changer
//
//  Created by Alan Chung on 25/11/2014.
//  Copyright (c) 2014 Alan Chung. All rights reserved.
//
//  Object representing a locale, containing a language code, country code and name.
//

#import <Foundation/Foundation.h>

@interface Locale : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *languageCode;
@property (nonatomic, copy) NSString *countryCode;

- (id)initWithLanguageCode:(NSString *)languageCode countryCode:(NSString *)countryCode name:(NSString *)name;

@end
