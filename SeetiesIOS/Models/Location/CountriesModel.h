//
//  CountriesModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/1/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "Model.h"
#import "CountryModel.h"

@protocol CountryModel
@end

@interface CountriesModel : Model

@property(nonatomic,strong)NSArray<CountryModel>* countries;
@property(nonatomic,strong)CountryModel *current_country;
-(void)processShouldDisplay;

@end
