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
@property(nonatomic,strong)NSMutableDictionary* dictUser;
@property(nonatomic,strong)NSMutableDictionary* dictLikes;
@property(nonatomic,strong)NSMutableDictionary* dictPosts;
@property(nonatomic,strong)NSMutableDictionary* dictVoucherCollections;

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

-(NSMutableDictionary*)dictLikes
{
    if (!_dictLikes) {
        _dictLikes = [NSMutableDictionary new];
    }
    
    return _dictLikes;
}


#pragma mark - Posts Local Storage
+(void)getPostCollected:(NSString*)postID isCollected:(BoolBlock)isCollectedBlock PostNotCollectedBlock:(CompletionVoidBlock)notCollectedBlock
{
    BOOL isTempPosts = NO;
    
    DataManager* dataManager = [DataManager Instance];
    
    if ([[dataManager.dictPosts allKeys]containsObject:postID]) {
        
        isTempPosts = [[dataManager.dictLikes objectForKey:postID]boolValue];
        
        if (isCollectedBlock) {
            isCollectedBlock(isTempPosts);
        }
    }
    else{
        if (notCollectedBlock) {
            notCollectedBlock();
        }
    }
    
}
/*post collected to default*/
+(void)setPostsCollected:(NSString*)postID isPostCollected:(BOOL)collected
{
    DataManager* dataManager = [DataManager Instance];
    
    [dataManager.dictPosts setValue:[NSNumber numberWithBool:collected] forKey:postID];
    
}

#pragma mark - Likes Local Storage

+(void)getPostLikes:(NSString*)postID isLiked:(BoolBlock)isLikedBlock NotLikeBlock:(CompletionVoidBlock)notCollectedBlock
{
    BOOL isTempLikes = NO;
    
    DataManager* dataManager = [DataManager Instance];
    
    if ([[dataManager.dictLikes allKeys]containsObject:postID]) {
        
        isTempLikes = [[dataManager.dictLikes objectForKey:postID]boolValue];
        
        if (isLikedBlock) {
            isLikedBlock(isTempLikes);
        }
        
    }
    else{
        if (notCollectedBlock) {
            notCollectedBlock();
        }
    }
    
}
+(void)setPostLikes:(NSString*)postID isLiked:(BOOL)liked
{
    DataManager* dataManager = [DataManager Instance];
    
    [dataManager.dictLikes setValue:[NSNumber numberWithBool:liked] forKey:postID];
    
}


#pragma mark - Collection Local Storage
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

+(BOOL)isUserFollowed:(NSString*)UserID isFollowing:(BOOL)isFollowing
{
    
    BOOL isCollected = isFollowing;
    DataManager* dataManager = [DataManager Instance];
    if ([[dataManager.dictUser allKeys]containsObject:UserID]) {
        isCollected = [[dataManager.dictCollections objectForKey:UserID]boolValue];
        
    }
    else{
        
        [DataManager setCollectionFollowing:UserID isFollowing:isFollowing];
    }
    
    return isCollected;
    
}

+(void)setUserFollowing:(NSString*)UserID isFollowing:(BOOL)following
{
    DataManager* dataManager = [DataManager Instance];
    
    [dataManager.dictUser setValue:[NSNumber numberWithBool:following] forKey:UserID];
    
}


-(void)setCurrentUserProfileModel:(ProfileModel*)model
{
    _currentUserProfileModel = model;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updatePhoneVerification"
     object:self];
    
    [ProfileModel saveUserProfile:model];
    
}

-(ProfileModel*)getCurrentUserProfileModel
{
    if (_currentUserProfileModel) {
        return _currentUserProfileModel;
    }
    else{
        
        return [ProfileModel getUserProfile];

    }
    
    return _currentUserProfileModel;
}
@end
