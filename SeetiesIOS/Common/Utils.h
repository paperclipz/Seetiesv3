//
//  Utils.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject


typedef enum
{
    ENGLISH = 0,
    MALAY = 1,
    CHINESE = 2
} Language;


+(BOOL)isLogin;

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
+(CGRect)getDeviceScreenSize;
#define BACKGROUND_COLOR_1 [UIColor colorWithRed: 103.0 / 255 green: 128.0 / 255 blue: 172.0 / 255 alpha: 1.0]

@end
