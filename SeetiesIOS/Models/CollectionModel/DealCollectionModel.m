//
//  DealCollectionModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/26/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealCollectionModel.h"
#import "NSDate+Calendar.h"

@interface DealCollectionModel()

@property(nonatomic,strong)NSDictionary* contents;

@end

@implementation DealCollectionModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"expired_info.expired_in_days": @"expired_in_days",
                                                       @"expired_info.expired_at": @"expired_at"}];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(NSString*)cDescription
{
    @try {
        _cDescription = [_contents objectForKey:@"description"];
        
    } @catch (NSException *exception) {
        
    }
    return _cDescription;
}

-(NSString*)language_code
{
    @try {
        _language_code = [_contents objectForKey:@"language_code"];
        
    } @catch (NSException *exception) {
        
    }
    return _language_code;
}

-(NSString*)language_name
{
    @try {
        _language_name = [_contents objectForKey:@"language_name"];
        
    } @catch (NSException *exception) {
        
    }
    return _language_name;
}

-(NSString*)cTitle
{
    @try {
        _cTitle = [_contents objectForKey:@"title"];
        
    } @catch (NSException *exception) {
        
    }
    return _cTitle;
}

//+(JSONKeyMapper*)keyMapper
//{
//    return nil;
//}

#pragma mark - process is campaign is expired

-(BOOL)isCampaignExpired
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *expiryDate = [formatter dateFromString:self.expired_at];
    
    
    if ([expiryDate isGreaterDate:[NSDate date]]) {
        
       
        return YES;
        
    }
    else{
        return NO;
        
    }
}

#pragma mark - process is voucher is able to redeem

-(BOOL)isExceedNumberOfCollectable
{
    
    if (self.total_deals_collected >= self.total_deals_collectable) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
