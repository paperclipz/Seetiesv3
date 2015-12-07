//
//  SeShopDetailModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/4/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeShopDetailModel.h"
@interface SeShopDetailModel()
@property(nonatomic,strong)NSMutableArray* arrayInfo;
@end
@implementation SeShopDetailModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"url.facebook": @"urlFacebook",
                                                       @"url.website": @"urlWebsite",
                                                       }];
}


-(void)process
{
    self.arrayInfo = [NSMutableArray new];
    if (![Utils isStringNull:_recommended_information]) {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        [temp setObject:_recommended_information forKey:@"Best known for"];
    }
    else if(true)//check price
    {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        [temp setObject:_recommended_information forKey:@"Price"];
    }
    
    else if(true)//check Hours
    {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        [temp setObject:_recommended_information forKey:@"Hours"];
    }
    
    else if(![Utils isStringNull:_contact_number])//check Phone Number
    {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        [temp setObject:_recommended_information forKey:@"Phone Number"];
    }
    
    else if(![Utils isStringNull:_urlWebsite])//check URL/Link
    {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        [temp setObject:_recommended_information forKey:@"URL/Link"];
    }

    else if(![Utils isStringNull:_urlFacebook])//check Facebook
    {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        [temp setObject:_recommended_information forKey:@"Facebook"];
    }
    


}

-(NSArray*)arrayInformation
{
    return [NSArray arrayWithArray:_arrayInfo];
}
@end
