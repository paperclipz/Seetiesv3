//
//  LanguageModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LanguageModel
@end

@interface LanguageModel : Model

@property (nonatomic,strong)NSString* language_code;    //eg: zh_TW
@property (nonatomic,strong)NSString* caption;      //eg: Traditional Chinese
@property (nonatomic,strong)NSString* langID;   //eg: 530d5e9b642440d128000018
@property (nonatomic,strong)NSString* origin_caption;   //eg: 简体中文

@end

@interface LanguageModels : Model

@property (nonatomic,strong)NSArray<LanguageModel>* languages;

@end

