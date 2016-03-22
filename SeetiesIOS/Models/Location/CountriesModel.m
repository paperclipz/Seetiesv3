//
//  CountriesModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/1/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CountriesModel.h"

@implementation CountriesModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(void)processShouldDisplay
{
    if (![Utils isArrayNull:self.countries]) {
        NSMutableArray<CountryModel>* tempArray = [NSMutableArray<CountryModel> new];
        
        for (int i = 0; i < self.countries.count; i++) {
            CountryModel* model = self.countries[i];
            if (model.home_filter_display)
            {
                [tempArray addObject:model];
            }
            
        
        }
        
        self.countries = tempArray;
    }
}
@end
