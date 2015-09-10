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

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
+(CGRect)getDeviceScreenSize;
#define DEVICE_COLOR [UIColor colorWithRed: 51.0 / 255 green: 181.0 / 255 blue: 229.0 / 255 alpha: 1.0]

#define CustomFontName @"ProximaNovaSoft-Regular"


+(void)setButtonWithBorder:(UIButton*)button;
+(NSString*)getWeekName:(int)integer;
+(void)setButtonWithBorder:(UIButton*)button color:(UIColor*)color;
+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius;


// ============== FONT =========

+(UIFont*)defaultFont;
+(UIColor*)defaultTextColor;


// ===== Validation ======== //
+ (BOOL) validateUrl: (NSString *) candidat;
// ===== Validation ======== //




@end
