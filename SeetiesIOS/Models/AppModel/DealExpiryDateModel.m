//
//  ExpiryDateModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 25/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealExpiryDateModel.h"

#define STORE_DEAL_ARRAY_KEY @"deal_array_key"


@implementation DealExpiryDateModel

-(BOOL)isEqual:(id)object{
    if (object == nil) {
        return NO;
    }
    if (![object isKindOfClass:DealExpiryDateModel.class]) {
        return NO;
    }
    
    DealExpiryDateModel *otherExpiryModel = (DealExpiryDateModel*)object;
    return [otherExpiryModel.expiryDate isEqualToString:self.expiryDate]? YES : NO;
}

-(NSUInteger)hash{
    return self.expiryDate.hash;
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


+(void)saveWalletList:(NSArray<DealExpiryDateModel *>*)array
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:STORE_DEAL_ARRAY_KEY];
    
    if (![Utils isArrayNull:array]) {
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:array];
        [defaults setObject:encodedObject forKey:STORE_DEAL_ARRAY_KEY];
        [defaults synchronize];
        
        
    }
    else{
        
        SLog(@"%@",array);
    }
    
}

+(NSArray<DealExpiryDateModel*>*)getWalletList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData * data = [defaults objectForKey:STORE_DEAL_ARRAY_KEY];
    
    NSArray<DealExpiryDateModel *>* array;
    
    array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return array;
}

+(void)deleteVoucherWallet:(DealModel*)model
{
    if (model.total_available_vouchers != -1) {
        
        NSArray<DealExpiryDateModel *>* array = [DealExpiryDateModel getWalletList];
        
        for (int i = 0; array.count; i++) {
            
            DealExpiryDateModel* deModel = array[i];
            for (int j = 0; j<deModel.dealModelArray.count; j++) {
                
                DealModel* dModel = deModel.dealModelArray[i];
                
                if ([model isEqual:dModel]) {
                    
                    [array[i].dealModelArray removeObject:dModel];
                    
                    [DealExpiryDateModel saveWalletList:array];
                    
                    break;
                }
                
            }
        }
    }
}

@end
