//
//  DataManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DataManager.h"
#import "DraftModel.h"



@interface DataManager()

@property(nonatomic,strong)NSMutableDictionary* dictCollections;
@property(nonatomic,copy)BoolBlock boolBlock;


@end
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

-(NSMutableDictionary*)dictCollections
{
    if (!_dictCollections) {
        _dictCollections = [NSMutableDictionary new];
    }
    
    return _dictCollections;
}
+(void)getCollectionFollowing:(NSString*)collectionID HasCollected:(BoolBlock)isCollected completion:(CompletionVoidBlock)completionBlock
{
    BOOL isTempCollected = NO;

    DataManager* dataManager = [DataManager Instance];
    
    if ([[dataManager.dictCollections allKeys]containsObject:collectionID]) {
       
        isTempCollected = [[dataManager.dictCollections objectForKey:collectionID]boolValue];
        if (isCollected) {
            isCollected(isTempCollected);
        }
        
    }
    else{
        if (completionBlock) {
            completionBlock();
        }
    }
    
}

+(BOOL)isCollectionFollowed:(NSString*)collectionID isFollowing:(BOOL)isFollowing
{
    
    BOOL isCollected = isFollowing;
    DataManager* dataManager = [DataManager Instance];
    if ([[dataManager.dictCollections allKeys]containsObject:collectionID]) {
        isCollected = [[dataManager.dictCollections objectForKey:collectionID]boolValue];

    }
    else{
    
        [DataManager setCollectionFollowing:collectionID isFollowing:isFollowing];
    }
    
    return isCollected;
    

}


+(void)setCollectionFollowing:(NSString*)collectionID isFollowing:(BOOL)following
{
    DataManager* dataManager = [DataManager Instance];

    [dataManager.dictCollections setValue:[NSNumber numberWithBool:following] forKey:collectionID];

}

@end
