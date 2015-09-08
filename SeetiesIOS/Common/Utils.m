//
//  Utils.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//
#import "Utils.h"

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

+(CGRect)getDeviceScreenSize
{
    return [[UIScreen mainScreen] bounds];
}

+(void)setButtonWithBorder:(UIButton*)button
{
    
    [[button layer] setBorderWidth:0.3f];
    [[button layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[button layer] setCornerRadius:5.0f];
}

+(void)setButtonWithBorder:(UIButton*)button color:(UIColor*)color
{
    
    [[button layer] setBorderWidth:0.3f];
    [[button layer] setBorderColor:color.CGColor];
    [[button layer] setCornerRadius:5.0f];
}

+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius
{
    [[view layer] setBorderWidth:0.3f];
    [[view layer] setBorderColor:color.CGColor];
    [[view layer] setCornerRadius:borderRadius];

}

+(UIFont*)defaultFont
{
    
    return [UIFont fontWithName:CustomFontName size:15];
}

+(UIColor*)defaultTextColor
{
    return [UIColor lightGrayColor];
}

+(NSString*)getWeekName:(int)integer
{
    
    switch (integer) {
        default:
        case 1:
            return @"Mon";
            break;
        case 2:
            return @"Tue";
            break;
        case 3:
            return @"Wed";
            break;
        case 4:
            return @"Thu";
            break;
        case 5:
            return @"Fri";
            break;
        case 6:
            return @"Sat";
            break;
        case 7:
            return @"Sun";
            break;
    }
}
@end
