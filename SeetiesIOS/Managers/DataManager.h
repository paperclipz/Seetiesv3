//
//  DataManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiVersionModel.h"
#import "LanguageModel.h"
#import "ExploreCountryModel.h"

@interface DataManager : NSObject
+ (id)Instance;


@property(nonatomic,strong)ApiVersionModel* apiVersionModel;
@property(nonatomic,strong)LanguageModels* languageModels;
@property(nonatomic,strong)ExploreCountryModels* exploreCountryModels;

@end
