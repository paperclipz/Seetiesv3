
//  Utils.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//
#import "Utils.h"
// =====================  CURRENCY =========================
#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

@implementation Utils
{
    
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

+(void)setIsLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckLogin = [[NSString alloc]initWithFormat:@"LoginDone"];
    [defaults setObject:CheckLogin forKey:@"CheckLogin"];

}
+(NSString*)getAppToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"ExpertToken"];
}
+(NSString*)getUserID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Useruid"];
}

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
    NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
    
    for (int i = 0; i< LanguageName_Array.count; i++) {
        if ([code isEqualToString:LanguageID_Array[i]]) {
            
            return LanguageName_Array[i];
        }
    }
    return nil;
}

+(NSString*)getLanguageCode:(NSString*)name
{
    NSString* tempName = name;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
    NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
    
    if ([tempName isEqualToString:TAIWAN_STR] || [tempName isEqualToString:CHINESE_STR]) {
        return CHINESE_CODE;
        
    }
    
    for (int i = 0; i< LanguageName_Array.count; i++) {
        if ([tempName isEqualToString:LanguageName_Array[i]]) {
            
            return LanguageID_Array[i];
        }
    }
    
    return LanguageID_Array[0];
    
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

@end
