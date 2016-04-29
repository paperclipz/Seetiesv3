//
//  VoucherInfoModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 22/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "VoucherInfoModel.h"

@implementation VoucherInfoModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    for (NSString *key in [self codableProperties])
    {
        
        [encoder encodeObject:[self valueForKey:key] forKey:key];
        
    }
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        
        for (NSString *key in [self codableProperties])
        {
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
            
        }
    }
    
    return self;
}


@end
