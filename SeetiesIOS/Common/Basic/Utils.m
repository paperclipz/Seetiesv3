
//  Utils.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//
#import "Utils.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "DealModel.h"

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


+(void)presentView:(UIViewController*)vc Completion:(NullBlock)completionBlock
{

    AppDelegate *appdelegate;
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appdelegate.landingViewController.loginViewController presentViewController:vc animated:YES completion:nil];
    
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
    [defaults setObject:nil forKey:USERID];
     BOOL walkthrough = [[defaults objectForKey:FIRST_TIME_SHOW_DEAL_WALKTHROUGH] boolValue];
    BOOL warning = [[defaults objectForKey:FIRST_TIME_SHOW_DEAL_WARNING] boolValue];

    NSData* data = [Utils getParseToken];

    BOOL isProduction = [Utils getIsDevelopment];

    [defaults synchronize];
    
    
    // set back nsdictionary data
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

    [defaults setBool:walkthrough forKey:FIRST_TIME_SHOW_DEAL_WALKTHROUGH];
    [defaults setBool:warning forKey:FIRST_TIME_SHOW_DEAL_WARNING];
    [Utils setParseToken:data];
    [Utils setIsDevelopment:isProduction];
    AppDelegate *appdelegate;
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [Utils reloadAppView:YES];
    [appdelegate.landingViewController showLoginView];
    
    //Clear instagram webview cookie
    [[InstagramEngine sharedEngine] logout];
}

+(void)reloadAppView:(BOOL)navigateToHome
{
    AppDelegate *appdelegate;
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate.landingViewController reloadData];
    
    if (navigateToHome) {
        appdelegate.landingViewController.tabBarController.selectedIndex = 0;
    }
}


+(void)reloadHomeView:(int)type
{
    if (type == 1) {
        
        AppDelegate *appdelegate;
        
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appdelegate.landingViewController.newsFeedViewController reloadNewsFeed];
        
    }
}

+(void)reloadProfileView
{
    AppDelegate *appdelegate;
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate.landingViewController.ct3MeViewController reloadData];
}

+(void)reloadTabbar
{
    AppDelegate *appdelegate;
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate.landingViewController reloadTabbar];
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
   // if (![Utils isParseRegisered]) {
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        NSString *parseToken = [[NSString alloc]initWithFormat:@"seeties_%@",userID];
        
        if (userID) {
            NSString *previousParseToken = [[NSString alloc]initWithFormat:@"seeties_%@",userID];
            [currentInstallation removeObject:@"all" forKey:@"channels"];
            [currentInstallation removeObject:previousParseToken forKey:@"channels"];
            [currentInstallation saveInBackground];
        }
        
        if ([Utils getParseToken]) {
            [currentInstallation setDeviceTokenFromData:[self getParseToken]];
            currentInstallation.channels = @[parseToken,@"all"];
            [currentInstallation saveInBackground];
            
        }
        else
        {
            SLog(@"parse token not registed to user");
        }
   // }
}

+(BOOL)isPhoneNumberVerified{
    
    ProfileModel *profileModel = [[DataManager Instance] getCurrentUserProfileModel];
    return profileModel.phone_verified;
}

+(BOOL)hasReferralCampaign{
    
    DataManager* manager = [ConnectionManager dataManager];
    CountriesModel *countries = manager.appInfoModel.countries;
    if (!countries) {
        return NO;
    }
    
    CountryModel *currentCountry = countries.current_country;
    return currentCountry.invite_friend_banner.message? YES : NO;
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


// from local code to language long code from server
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
    return [UIImage imageNamed:@"EmptyBlueImg.png"];
}

+(UIImage*)getProfilePlaceHolderImage
{
    return [UIImage imageNamed:@"DefaultProfilePic.png"];
}
+(UIImage*)getShopPlaceHolderImage
{
    return [UIImage imageNamed:@"SsDefaultDisplayPhoto.png"];
}

+(UIImage*)getCoverPlaceHolderImage
{
    return [UIImage imageNamed:@"SSCoverPhotoOverlay.png"];
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
    
    if ([array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSMutableArray class]]) {
        
        if (array == nil || [array count] == 0) {
            _isNUll = YES;
        }

    }
    else{
        
        _isNUll = YES;
    }
    
       return _isNUll;
}

#pragma mark - App Utilities

+(NSString*)getUniqueDeviceIdentifier
{
    
    //NSString *UUID = [[NSUUID UUID] UUIDString];
    
    //NSString *UUID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    // return UUID;
    
    NSString *appName;
    
    if ([Utils isAppProductionBuild]) {
        appName = @"Seeties";
    }
    else
    {
        appName = @"Dev";
        
    }
    
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"SeetiesAccount"];
    
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"SeetiesAccount"];
    }
    
    return strApplicationUUID;
    
    
}

+(NSString*)getDistance:(float)distance Locality:(NSString*)local
{
    NSString* strDistance;
    
    if(distance <= MaxDistance)
    {
        if (distance <= 1000) {
            strDistance = [NSString stringWithFormat:@"%.f M",distance];
            
        }
        else{
            strDistance = [NSString stringWithFormat:@"%.f KM",distance/1000];
            
        }
    }
    
    else{
        
        if ([Utils stringIsNilOrEmpty:local]) {
            
            if (distance <= 1000) {
                strDistance = [NSString stringWithFormat:@"%.f M",distance];
                
            }
            else{
                strDistance = [NSString stringWithFormat:@"%.f KM",distance/1000];
                
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


+(void)showVerifyPhoneNumber:(UIViewController*)viewController{
    PromoPopOutViewController *popOut = [PromoPopOutViewController new];
    [popOut setViewType:PopOutViewTypeEnterPhone];
    [popOut setPopOutCondition:PopOutConditionVerifyPhoneNumber];
    
    STPopupController *popOutController = [[STPopupController alloc]initWithRootViewController:popOut];
    popOutController.containerView.backgroundColor = [UIColor clearColor];
    [popOutController presentInViewController:viewController];
    [popOutController setNavigationBarHidden:YES];
}

+(void)showPromoView:(UIViewController*)viewController{
    PromoPopOutViewController *popOut = [PromoPopOutViewController new];
    [popOut setViewType:PopOutViewTypeEnterPhone];
    [popOut setPopOutCondition:PopOutConditionVerifyPhoneNumber];
    
    STPopupController *popOutController = [[STPopupController alloc]initWithRootViewController:popOut];
    popOutController.containerView.backgroundColor = [UIColor clearColor];
    [popOutController presentInViewController:viewController];
    [popOutController setNavigationBarHidden:YES];
}

+(void)showChangeVerifiedPhoneNumber:(UIViewController*)viewController{
    PromoPopOutViewController *popOut = [PromoPopOutViewController new];
    [popOut setViewType:PopOutViewTypeChangeVerifiedPhone];
    
    STPopupController *popOutController = [[STPopupController alloc]initWithRootViewController:popOut];
    popOutController.containerView.backgroundColor = [UIColor clearColor];
    [popOutController setNavigationBarHidden:YES];
    [popOutController presentInViewController:viewController];
}

+(NSString*)getTimeZone
{
    //int utcTimeZone = (int)[[NSTimeZone localTimeZone] secondsFromGMT] / 3600;
    
    NSDateFormatter *localTimeZoneFormatter = [NSDateFormatter new];
    localTimeZoneFormatter.timeZone = [NSTimeZone localTimeZone];
    localTimeZoneFormatter.dateFormat = @"Z";
    NSString *localTimeZoneOffset = [localTimeZoneFormatter stringFromDate:[NSDate date]];
    
    return localTimeZoneOffset;


}

+(NSInteger)numberOfDaysLeft:(NSDate*)date{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDateComponents *components = [cal components:NSCalendarUnitDay|NSCalendarUnitMinute fromDate:[NSDate new] toDate:date options:NSCalendarWrapComponents];
    
    if ([components day] == 0) {
        //if same day, check for time expiry
        if ([components minute] > 0) {
            return [components day]+1;
        }
    }
    
    return [components day];
}

+(BOOL)isDate:(NSDate*)currentDate betweenFirstDate:(NSDate*)firstDate andLastDate:(NSDate*)lastDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    unsigned int dateFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *currentDateComp = [calendar components:dateFlags fromDate:currentDate];
    NSDateComponents *firstDateComp = firstDate? [calendar components:dateFlags fromDate:firstDate] : nil;
    NSDateComponents *lastDateComp = lastDate? [calendar components:dateFlags fromDate:lastDate] : nil;
    
    currentDate = [calendar dateFromComponents:currentDateComp];
    firstDate = firstDateComp? [calendar dateFromComponents:firstDateComp] : nil;
    lastDate = lastDateComp? [calendar dateFromComponents:lastDateComp] : nil;
    
    if (!firstDate && !lastDate) {
        return YES;
    }
    else if (!firstDate && lastDate){
        NSComparisonResult result = [currentDate compare:lastDate];
        return (result == NSOrderedSame || result == NSOrderedAscending)? YES : NO;
    }
    else if (firstDate && !lastDate){
        NSComparisonResult result = [currentDate compare:firstDate];
        return (result == NSOrderedSame || result == NSOrderedDescending)? YES : NO;
    }
    else if (firstDate && lastDate){
        NSComparisonResult firstDateResult = [currentDate compare:firstDate];
        NSComparisonResult lastDateResult = [currentDate compare:lastDate];
        
        if (firstDateResult == NSOrderedSame || lastDateResult == NSOrderedSame) {
            return YES;
        }
        else if (firstDateResult == NSOrderedDescending && lastDateResult == NSOrderedAscending){
            return YES;
        }
    }

    return NO;
}

+(BOOL)isValidDateString:(NSString*)dateString{
    if ([self isStringNull:dateString]) {
        return NO;
    }
    
    if ([dateString isEqualToString:@"no_expiry_date"]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}


#pragma mark - SYSTEM PREFERENCE

/*base on bundle indetifier to return either live or dev*/
+(BOOL)isAppProductionBuild
{
    NSString*bundleIdentifer  = [[NSBundle mainBundle] bundleIdentifier];
    
    //delete this for live
   // return NO;

  //  return YES;
    if ([bundleIdentifer rangeOfString:@"Dev"].location == NSNotFound) {
        NSLog(@"App is On Live Server");
        
        return YES;
        
    } else {
        NSLog(@"App is On Dev Server");
        return NO;
        
    }
    
}
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
           
            BOOL isDev = ![Utils isAppProductionBuild];
            return isDev;
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

+(void)saveUserLocation:(NSString*)location Longtitude:(NSString*)longtitude Latitude:(NSString*)latitude PlaceID:(NSString*)place_id CountryID:(int)countryId SourceType:(NSString*)type
{
    @try {
        NSDictionary* dict = @{KEY_LOCATION:location?location:@"",
                               KEY_LONGTITUDE : longtitude?longtitude:@"",
                               KEY_LATITUDE : latitude?latitude:@"",
                               KEY_PLACE_ID : place_id?place_id:@"",
                               KEY_COUNTRY_ID : countryId? @(countryId): @(0),
                               KEY_SOURCE_TYPE :type?type:@""
                               };
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dict forKey:KEY_USER_PREF_MAIN_KEY];
        
        [defaults synchronize];

    }
    @catch (NSException *exception) {
        
    }
    
   
}

#pragma mark - Notification


+(void)startNotification
{
    [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:[Utils class]
                                   selector:@selector(requestServerForNotificationCount)
                                   userInfo:nil
                                    repeats:YES];

}

+(void)requestServerForNotificationCount
{
    
    if ([Utils isGuestMode]) {
        
        return;
    }
    
    NSString* token = [Utils getAppToken];
    
    NSDictionary* dict = @{@"token" : token?token:@""};
    
    if (![Utils isStringNull:token]) {
        
        [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetNotificationCount parameter:dict appendString:nil success:^(id object)
         {
             NSDictionary* returnDict = object[@"data"];
             
             @try {
                 int notCount = [returnDict[@"total_new_notifications"] intValue];
                 
                 NSDictionary* dict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",notCount] forKey:@"NOTIFICATION_COUNT"];
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"UpdateNotification"
                  object:nil userInfo:dict];
             }
             @catch (NSException *exception) {
                 SLog(@"server count not found");
             }
             
         } failure:^(id object) {
             
         }];
    }
}

@end
