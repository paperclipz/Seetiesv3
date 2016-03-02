
//  Utils.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//
#import "Utils.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation Utils

+(BOOL)isGuestMode
{
    if ([Utils checkUserIsLogin]) {
        return NO;
    }
    else{
        return YES;
    }
    
}

+(void)setLogout
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString *parseToken = [[NSString alloc]initWithFormat:@"seeties_%@",[Utils getUserID]];
    [currentInstallation removeObject:@"all" forKey:@"channels"];
    [currentInstallation removeObject:parseToken forKey:@"channels"];
    [currentInstallation saveInBackground];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:TOKEN];
    [defaults synchronize];
    
    AppDelegate *appdelegate;
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [Utils reloadAppView];
    [appdelegate.landingViewController showLoginView];

}

+(void)reloadAppView
{
    AppDelegate *appdelegate;
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate.landingViewController reloadData];
}

+(BOOL)isLogin
{
    BOOL isSuccessLogin = false;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckLogin = [defaults objectForKey:@"CheckLogin"];

    
    if ([CheckLogin isEqualToString:@"LoginDone"]) {
        isSuccessLogin = true;
    }
    
    return isSuccessLogin;
}

/*new checking for login using token |Experimental as of 26/1/2016|*/
+(BOOL)checkUserIsLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:TOKEN];
 
    if ([Utils isStringNull:token]) {
        return NO;
    }
    else{
        return YES;
    }

}

+(NSString*)getAppToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:TOKEN]?[defaults objectForKey:TOKEN]:@"";
    return token;
}

+(NSString*)getUserID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USERID];
}

+(void)setParseToken:(NSData*)data
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"DeviceTokenPush"];
    [defaults synchronize];
    
}

+(void)deleteParseToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"DeviceTokenPush"];
    [defaults synchronize];
}

+(NSData*)getParseToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData* data =[defaults objectForKey:@"DeviceTokenPush"];
    
    return data;
}


+(BOOL)isParseRegisered
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData* data =[defaults objectForKey:@"DeviceTokenPush"];
    
    if (data) {
        return YES;
    }
    else{
        return NO;
    }
}

+(void)registerParseAfterLogin:(NSString*)userID
{
    if (![Utils isParseRegisered]) {
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        NSString *parseToken = [[NSString alloc]initWithFormat:@"seeties_%@",userID];
        
        if ([Utils getUserID]) {
            NSString *previousParseToken = [[NSString alloc]initWithFormat:@"seeties_%@",[Utils getUserID]];
            [currentInstallation removeObject:@"all" forKey:@"channels"];
            [currentInstallation removeObject:previousParseToken forKey:@"channels"];
            [currentInstallation saveInBackground];
        }
        
        if ([self getParseToken]) {
            [currentInstallation setDeviceTokenFromData:[self getParseToken]];
            currentInstallation.channels = @[parseToken,@"all"];
            [currentInstallation saveInBackground];
            
        }
        else
        {
            SLog(@"parse token not registed to user");
        }
    }
}

#pragma mark - Utilities
+(NSString*)getWeekName:(int)integer
{
    
    switch (integer) {
        default:
        case 1:
            return LocalisedString(@"Mon");
            break;
        case 2:
            return LocalisedString(@"Tue");
            break;
        case 3:
            return LocalisedString(@"Wed");
            break;
        case 4:
            return LocalisedString(@"Thu");
            break;
        case 5:
            return LocalisedString(@"Fri");
            break;
        case 6:
            return LocalisedString(@"Sat");
            break;
        case 0:
            return LocalisedString(@"Sun");
            break;
    }
}

+(int)getWeekInteger:(NSString*)week
{
    
    int returnWeekInteger;
    
    SWITCH (week) {
        
        CASE (@"Mon"){
            returnWeekInteger = 1;
            break;
            
        }
        CASE (@"Tue"){
            returnWeekInteger = 2;
            break;
            
        }
        CASE (@"Wed"){
            returnWeekInteger = 3;
            break;
            
        }
        CASE (@"Thu"){
            returnWeekInteger = 4;
            break;
            
        }
        CASE (@"Fri"){
            returnWeekInteger = 5;
            break;
        }
        CASE (@"Sat"){
            returnWeekInteger = 6;
            break;
            
        }
        DEFAULT
        {
            returnWeekInteger = 0;
            break;
            
        }
        
    }
    
    return returnWeekInteger;

}


+ (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+(NSString*)currencyCode:(NSString*)currency
{
    NSString* tempCurrencyCode;
    
    SWITCH (currency) {
       
        CASE (USD){
            tempCurrencyCode = @"840";
            break;

        }
        CASE (THB){
            tempCurrencyCode = @"764";
            break;

        }
        CASE (IDR){
            tempCurrencyCode = @"360";
            break;

        }
        CASE (SGD){
            tempCurrencyCode = @"702";
            break;

        }
        CASE (TWD){
            tempCurrencyCode = @"901";
            break;
        }
        CASE (PHP){
            tempCurrencyCode = @"608";
            break;

        }
        CASE (MYR){
            tempCurrencyCode = @"458";
            break;
            
        }

        DEFAULT
        {
            tempCurrencyCode = nil;
            break;

        }
        
    }
    
    return tempCurrencyCode;
}

+(NSString*)currencyString:(NSString*)code
{
    
    SWITCH (code) {
       
        CASE (@"840"){
            return USD;
            break;
        }
        CASE (@"764"){
            return THB;
            break;

        }
        CASE (@"360"){
            return IDR;
            break;

        }
        CASE (@"702"){
            return SGD;
            break;

        }
        CASE (@"901"){
            return TWD;
            break;

        }
        CASE (@"608"){
            return TWD;
            break;

        }
        
        CASE (@"458"){
            return MYR;
            break;
            
        }
        DEFAULT
        {
            return USD;
            break;
            
        }
    }
    
    return nil;
}

+(NSString*)convertToJsonString:(NSDictionary*)dict
{
    NSError *error = nil;
    NSData *json;
    NSString *jsonString;
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        // Serialize the dictionary
        json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        
        // If no errors, let's view the JSON
        if (json != nil && error == nil)
        {
            jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
        }
    }
    
    return jsonString;
}

+(BOOL)stringIsNilOrEmpty:(NSString*)aString {
    return !(aString && aString.length);
}
#define ENGLISH_CODE @"530b0ab26424400c76000003"
#define CHINESE_CODE @"530b0aa16424400c76000002"
#define TAIWAN_CODE @"530d5e9b642440d128000018"
#define INDONESIA_CODE @"53672e863efa3f857f8b4ed2"
#define FILIPINES_CODE @"539fbb273efa3fde3f8b4567"
#define THAI_CODE @"544481503efa3ff1588b4567"

#define ENGLISH_SHORT_NAME @"en"
#define CHINESE_SHORT_NAME @"zh-Hans"
#define TAIWAN_SHORT_NAME @"zh-Hant"
#define INDONESIA_SHORT_NAME @"id"
#define FILIPINES_SHORT_NAME @"tl-PH"
#define THAI_SHORT_NAME @"th"

#define TAIWAN_STR @"简体中文"
#define CHINESE_STR @"繁體中文 "
#define CHINESE_CENTRAL @"中文 "


+(NSString*)getLanguageCodeFromLocale:(NSString*)shortName
{
  
    SWITCH (shortName) {
        
        CASE (ENGLISH_SHORT_NAME){
            return ENGLISH_CODE;
            break;
        }
        CASE (CHINESE_SHORT_NAME){
            return CHINESE_CODE;
            break;
        }

        CASE (TAIWAN_SHORT_NAME){
            return TAIWAN_CODE;
            break;
        }

        CASE (INDONESIA_SHORT_NAME){
            return INDONESIA_CODE;
            break;
        }

        CASE (FILIPINES_SHORT_NAME){
            return FILIPINES_CODE;
            break;
        }

        CASE (THAI_SHORT_NAME){
            return THAI_CODE;
            break;
        }
        DEFAULT
        {
            return ENGLISH_CODE;
            break;
            
        }
        
        return nil;
    }
            
}

+(NSString*)getLanguageName:(NSString*)code
{
    
    LanguageModels* langmodels = [[ConnectionManager dataManager]languageModels];
  
    NSString* languageStr = @"";
    
    for (int i = 0; i<langmodels.languages.count; i++) {
     
        LanguageModel* model = langmodels.languages[i];
     
        if ([model.langID isEqualToString:code]) {
            
            languageStr = model.origin_caption;
            break;
        }
        

    }
    return languageStr;
}

+(NSString*)getLanguageCode:(NSString*)name
{
    
    LanguageModels* langmodels = [[ConnectionManager dataManager]languageModels];
    
    NSString* langCode = @"";

    for (int i = 0; i<langmodels.languages.count; i++) {
        
        LanguageModel* model = langmodels.languages[i];
        
        if ([model.origin_caption isEqualToString:name]) {
            
            langCode = model.langID;
            break;
        }
        
    }
    return langCode;
    

}

#pragma mark - UI Utilities
+(CGRect)getDeviceScreenSize
{
    CGRect frame = [[UIScreen mainScreen] bounds];
  //  SLog(@"screen size width : %f    ||  height : %f",frame.size.width,frame.size.height);
    return frame;
}

+(void)setButtonWithBorder:(UIButton*)button
{
    
    [[button layer] setBorderWidth:BORDER_WIDTH];
    [[button layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[button layer] setCornerRadius:5.0f];
}

+(void)setButtonWithBorder:(UIButton*)button color:(UIColor*)color
{
    
    [[button layer] setBorderWidth:BORDER_WIDTH];
    [[button layer] setBorderColor:color.CGColor];
    [[button layer] setCornerRadius:5.0f];
}

+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius
{
    
    [[view layer] setBorderWidth:BORDER_WIDTH];
    [[view layer] setBorderColor:color.CGColor];
    [[view layer] setCornerRadius:borderRadius];
    [[view layer] setMasksToBounds:YES];
    
}

+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius borderWidth:(float)borderWidth
{
    
    [[view layer] setBorderWidth:borderWidth];
    [[view layer] setBorderColor:color.CGColor];
    [[view layer] setCornerRadius:borderRadius];
    [[view layer] setMasksToBounds:YES];
    
}

+(UIFont*)defaultFont
{
    
    return [UIFont fontWithName:CustomFontName size:15];
}

+(UIColor*)defaultTextColor
{
    return [UIColor lightGrayColor];
}

+(UIImage*)getPlaceHolderImage
{
    return [UIImage imageNamed:@"NoImage.png"];
}

+(NSURL*)getPrefixedURLFromString:(NSString*)url
{
    NSString *myURLString = url;
    NSURL *myURL;
    if ([myURLString.lowercaseString hasPrefix:@"http://"]) {
        myURL = [NSURL URLWithString:myURLString];
    } else {
        myURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",myURLString]];
    }
    
    return myURL;
    

}

+(BOOL)isStringNull:(NSString*)str
{
    BOOL _isNUll = false;
    

    if ([str isEqualToString:@""] || str.length == 0 || str == nil) {
        _isNUll = true;
    }

    return _isNUll;
}

+(BOOL)isArrayNull:(NSArray*)array
{
    BOOL _isNUll = NO;
    if (array == nil || [array count] == 0) {
        _isNUll = YES;
    }
    return _isNUll;
}

#pragma mark - App Utilities
+(NSString*)getDeviceAppLanguageCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* userLanguage = [defaults objectForKey:KEY_SYSTEM_LANG];

    if ([Utils isStringNull:userLanguage]) {
        userLanguage = [Utils getDeviceDefaultLanguageCode];
    }
    
    if (userLanguage) {
        if ([userLanguage isEqualToString:@"English"]) {
            
            return ENGLISH_CODE;
        }else if([userLanguage isEqualToString:@"Simplified Chinese"] || [userLanguage isEqualToString:@"简体中文"]){
            return CHINESE_CODE;

        }else if([userLanguage isEqualToString:@"Traditional Chinese"] || [userLanguage isEqualToString:@"繁體中文"]){

            return TAIWAN_CODE;
            
        }else if([userLanguage isEqualToString:@"Bahasa Indonesia"]){

            return INDONESIA_CODE;

        }else if([userLanguage isEqualToString:@"Thai"] || [userLanguage isEqualToString:@"th"] || [userLanguage isEqualToString:@"ภาษาไทย"]){
            return THAI_CODE;
        }
    
    }
    return nil;
    
}

/*get device language not app language*/
+(NSString*)getDeviceDefaultLanguageCode
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
 
    return  [Utils getLanguageCodeFromLocale:language];

}



+(NSString*)getDistance:(float)distance Locality:(NSString*)local
{
    NSString* strDistance;
    
    if(distance <= MaxDistance)
    {
        if (distance <= 1000) {
            strDistance = [NSString stringWithFormat:@"%.1f Meter",distance];
            
        }
        else{
            strDistance = [NSString stringWithFormat:@"%.1f KM",distance/100];
            
        }
    }
    
    else{
        
        if ([Utils stringIsNilOrEmpty:local]) {
            
            if (distance <= 1000) {
                strDistance = [NSString stringWithFormat:@"%.1f Meter",distance];
                
            }
            else{
                strDistance = [NSString stringWithFormat:@"%.1f KM",distance/100];
                
            }
            
        }
        else{
            strDistance = local;
            
        }
        
    }
    
    return strDistance;
    
}

+(void)showLogin
{
    AppDelegate *appdelegate;
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appdelegate.landingViewController showLoginView];

}

+(NSString*)getTimeZone
{
    //int utcTimeZone = (int)[[NSTimeZone localTimeZone] secondsFromGMT] / 3600;
    
    NSDateFormatter *localTimeZoneFormatter = [NSDateFormatter new];
    localTimeZoneFormatter.timeZone = [NSTimeZone localTimeZone];
    localTimeZoneFormatter.dateFormat = @"Z";
    NSString *localTimeZoneOffset = [localTimeZoneFormatter stringFromDate:[NSDate date]];
    
    return localTimeZoneOffset;
//    NSString* strUTC;
//    switch (utcTimeZone) {
//        case 0:
//            
//            strUTC = @"";
//            break;
//            
//        case 1:
//            
//            break;
//            
//        case 2:
//            
//            break;
//            
//        case 3:
//            
//            break;
//        
//            
//        case 4:
//            
//            break;
//            
//        case 5:
//            
//            break;
//            
//        case 6:
//            
//            break;
//        case 7:
//            
//            break;
//
//        default:
//        case 8:
//            
//            break;
//
//        case 9:
//            
//            break;
//
//        case 10:
//            
//            break;
//
//        case 11:
//            
//            break;
//
//        case 12:
//            
//            break;
//
//    }

}

+(NSInteger)numberOfDaysLeft:(NSDate*)date{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [cal components:NSCalendarUnitDay fromDate:[NSDate new] toDate:date options:NSCalendarWrapComponents];
    
    return [components day];
}

#pragma mark - SYSTEM PREFERENCE

+(void)setIsDevelopment:(BOOL)isDev
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* key;

    if (isDev) {
        key = @"0";
    }
    else
    {
        key = @"1";

    }
    [defaults setObject:key forKey:KEY_PRODUCTION];
    
    [defaults synchronize];
}

+(BOOL)getIsDevelopment
{
    
    @try {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString* key =  [defaults objectForKey:KEY_PRODUCTION];
        
        
        if ([Utils isStringNull:key]) {
            return YES;
        }
        if ([key isEqualToString:@"0"]) {
            return YES;
            
        }
        else
        {
            return NO;
            
        }

    }
    @catch (NSException *exception) {
        
        return YES;
    }
  
    
}

+(NSDictionary*)getSavedUserLocation
{
    /*dictionary consist of location, longtitude and latitude*/
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* dict = [defaults objectForKey:KEY_USER_PREF_MAIN_KEY];
    
    return dict;
    
}

+(void)saveUserLocation:(NSString*)location Longtitude:(NSString*)longtitude Latitude:(NSString*)latitude
{
    
    NSDictionary* dict = @{KEY_LOCATION:location,
                           KEY_LONGTITUDE : longtitude,
                           KEY_LATITUDE : latitude
                           };
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:KEY_USER_PREF_MAIN_KEY];
    
    [defaults synchronize];

}


@end
