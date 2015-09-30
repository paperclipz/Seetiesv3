//
//  Localisator.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "Localisator.h"
#import "Locale.h"

#define kDeviceLanguage @"DeviceLanguage"

static NSString * const kSaveLanguageDefaultKey = @"kSaveLanguageDefaultKey";

@interface Localisator()

@property (nonatomic,strong) NSUserDefaults *defaults;
@end

@implementation Localisator

static NSBundle *bundle = nil;

#pragma  mark - Singleton Method

+ (Localisator*)sharedInstance
{
    static Localisator *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        bundle = [NSBundle mainBundle];
        _sharedInstance = [[Localisator alloc] init];
    });
    return _sharedInstance;
}


#pragma mark - Init methods

- (id)init
{
    if (self = [super init])
    {
        _defaults                       = [NSUserDefaults standardUserDefaults];
        _availableLanguages     = @[@"en",@"fil-PH",@"id",@"th",@"zh-Hans",@"zh-Hant"];
        _currentLanguage        = kDeviceLanguage;
        
        NSString *languageSaved = [self.defaults objectForKey:kSaveLanguageDefaultKey];
        
        if (languageSaved != nil)
        {
            [self setLanguage:languageSaved];
        }else{
        
            [self setSupportedDeviceLanguage];
        }
        
    }
    return self;
}

//-(NSArray*)availableLanguages
//{
//    if(!_availableLanguages)
//    {
//        Locale *english = [[Locale alloc] initWithLanguageCode:@"en" countryCode:@"gb" name:@"English"];
//        Locale *cn_simplified = [[Locale alloc] initWithLanguageCode:@"zh-Hans" countryCode:@"fr" name:@"Simplified Chinese"];
//        Locale *cn_traditional = [[Locale alloc] initWithLanguageCode:@"zh-Hant" countryCode:@"de" name:@"Traditional Chinese"];
//        Locale *indonesian = [[Locale alloc] initWithLanguageCode:@"id" countryCode:@"it" name:@"Bahasa Indonesia"];
//        Locale *thai = [[Locale alloc] initWithLanguageCode:@"th" countryCode:@"jp" name:@"Thai"];
//        Locale *philippines = [[Locale alloc] initWithLanguageCode:@"tl-PH" countryCode:@"jp" name:@"Filipino"];
//        _availableLanguages = @[english, cn_simplified, cn_traditional, indonesian, thai,philippines];
//    }
//    
//    return _availableLanguages;
//
//}


-(void)setSupportedDeviceLanguage
{
    
    NSString *language = [[NSString alloc]initWithFormat:@"%@",[[NSLocale preferredLanguages] objectAtIndex:0]];

    for (NSString * languageOptions in _availableLanguages) {
        
        if ([languageOptions caseInsensitiveCompare:language] == NSOrderedSame) {
            [self setLanguage:language];
            break;
        }
    }
    
    [self setLanguage:_availableLanguages[0]];

    
}

#pragma mark - saveInIUserDefaults custom accesser/setter

- (BOOL)saveInUserDefaults
{
    return ([_defaults objectForKey:kSaveLanguageDefaultKey] != nil);
}

- (void)setSaveInUserDefaults:(BOOL)saveInUserDefaults
{
    if (saveInUserDefaults) {
        [self.defaults setObject:_currentLanguage forKey:kSaveLanguageDefaultKey];
    } else {
        [self.defaults setObject:nil forKey:kSaveLanguageDefaultKey];
    }
    [self.defaults synchronize];;
}

#pragma mark - Private  Instance methods

- (BOOL)loadDataForLanguage:(NSString *)newLanguage
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:newLanguage ofType:@"lproj"];
    if (bundle != [NSBundle bundleWithPath:path]) {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            _currentLanguage = [newLanguage copy];
            bundle = [NSBundle bundleWithPath:path];
            
            return YES;
            
        } else {
            
            // Reset localization
            _currentLanguage = kDeviceLanguage;
            bundle = [NSBundle mainBundle];
        }
    }
    return NO;
}


#pragma mark - Public Instance methods

- (NSString *)localizedStringForKey:(NSString*)key
{
    return [bundle localizedStringForKey:key value:key table:nil];
}

- (BOOL)setLanguage:(NSString *)newLanguage
{
    if (newLanguage == nil || [newLanguage isEqualToString:_currentLanguage] || ![self.availableLanguages containsObject:newLanguage])
        return NO;
    
    if ([newLanguage isEqualToString:@"DeviceLanguage"]) {
        
        _currentLanguage = kDeviceLanguage;
        bundle = [NSBundle mainBundle];
        [self updateApplicationData];
        
        return YES;
        
    } else {
        
        BOOL isLoadingOk = [self loadDataForLanguage:newLanguage];
        
        if (isLoadingOk) {
            [self updateApplicationData];
        }
        return isLoadingOk;
    }
}
- (void)updateApplicationData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLanguageChanged
                                                        object:nil];
    [self.defaults setObject:_currentLanguage forKey:kSaveLanguageDefaultKey];
    [_defaults synchronize];
    [self setSaveInUserDefaults:YES];
}

@end
