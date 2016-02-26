//
//  AppInfoModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/24/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface AppInfoModel : JSONModel

@property(nonatomic,strong)NSArray<CategoryModel>* categories;
@property(nonatomic,strong)NSArray<LanguageModel>* languages;

@end
