//
//  DataManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (id)Instance {
    
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

+(NSArray*)getSampleObject
{
    NSArray* tempArray = @[@"123",@"223",@"333"];
    
    return tempArray;
}

+(RecommendationModel*)getSampleRecommendation
{
    
  
        RecommendationModel* model = [RecommendationModel new];
        model.postMainTitle = @"111111";
        model.postMainDescription = @"222222222";
        model.arrPostImagesList = [NSMutableArray new];

        for (int j = 0; j<5; j++) {
            [model.arrPostImagesList addObject:[self getSampleEditPhotoModel]];
        }
  
    
    return model;
    
}

+(EditPhotoModel*)getSampleEditPhotoModel
{
    
        EditPhotoModel* model = [EditPhotoModel new];
        model.photoDescription = @"photos";
        model.image = [UIImage imageNamed:@"profile_1.png"];
    
    return model;
}
@end
