//
//  RecommendationModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendationModel : NSObject

@property(nonatomic,strong)NSString* postMainTitle;
@property(nonatomic,strong)NSString* postMainDescription;

@property(nonatomic,strong)NSString* postSecondTitle;
@property(nonatomic,strong)NSString* postSecondDescription;

@property(nonatomic,strong)NSString* postURL;


@property(nonatomic,strong)NSMutableArray* arrPostImagesList;

@end
