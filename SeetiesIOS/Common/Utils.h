//
//  Utils.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

typedef void(^ButtonBlock) (id sender);

typedef enum
{
    ENGLISH = 0,
    MALAY = 1,
    CHINESE = 2
} Language;

typedef enum
{
    SearchTypeGoogle = 1,
    SearchTypeFourSquare = 2,
    SearchTypeDefault = 0
    
}SearchType;
typedef enum
{
    PlaceViewTypeEdit = 0,
    PlaceViewTypeNew = 1
    
} PlaceViewType;

+(BOOL)isLogin;
+(void)setIsLogin;
+(NSString*)getAppToken;
+(NSString*)getUserID;

#define UIColorFromRGB(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

+(CGRect)getDeviceScreenSize;
#define DEVICE_COLOR [UIColor colorWithRed: 41.0 / 255 green: 182.0 / 255 blue: 246.0 / 255 alpha: 1.0]
#define TEXT_GRAY_COLOR [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]
#define TWO_ZERO_FOUR_COLOR [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0]

#define CustomFontName @"ProximaNovaSoft-Regular"
#define CustomFontNameBold @"ProximaNovaSoft-Bold"

// ========================  Day ==========================

+(NSString*)getWeekName:(int)integer;
+(int)getWeekInteger:(NSString*)week;
// ========================  Day ==========================

+(void)setButtonWithBorder:(UIButton*)button color:(UIColor*)color;
+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius;
+(void)setButtonWithBorder:(UIButton*)button;
+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius borderWidth:(float)borderWidth;


// ========================  FONT ==========================
+(UIFont*)defaultFont;
+(UIColor*)defaultTextColor;
// ========================  font ==========================


// =====================  VALIDATION =======================
+ (BOOL) validateUrl: (NSString *) candidat;
// =====================  Validation =======================



// =====================  CURRENCY =========================
+(NSString*)currencyCode:(NSString*)currency;
+(NSString*)currencyString:(NSString*)code;

#define USD @"USD"
#define THB @"THB"
#define IDR @"IDR"
#define SGD @"SGD"
#define TWD @"TWD"
#define PHP @"PHP"
#define MYR @"MYR"

+(NSString*)getLanguageName:(NSString*)code;
+(NSString*)getLanguageCode:(NSString*)name;

// =====================  currency =========================

//easy conversion to jsonstring
+(NSString*)convertToJsonString:(NSDictionary*)dict;
+(BOOL)stringIsNilOrEmpty:(NSString*)aString;

@end
