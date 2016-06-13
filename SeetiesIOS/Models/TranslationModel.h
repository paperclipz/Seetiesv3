//
//  TranslationModel.h
//  Seeties
//
//  Created by Lai on 11/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TranslationModel : JSONModel

@property (strong, nonatomic) NSDictionary *translations;

@end

@interface TranslatedContentModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;

@end