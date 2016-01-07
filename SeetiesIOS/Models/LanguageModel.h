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

@property (nonatomic,strong)NSString* language_code;
@property (nonatomic,strong)NSString* caption;
@property (nonatomic,assign)int langID;
@end

@interface LanguageModels : Model

@property (nonatomic,strong)NSArray<LanguageModel>* languages;

@end

