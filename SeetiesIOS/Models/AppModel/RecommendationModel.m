//
//  RecommendationModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "RecommendationModel.h"

@implementation RecommendationModel


-(id)init
{
    if (self = [super init]) {
        
        _arrPostImagesList = [NSMutableArray new];
        _postMainLanguage = ENGLISH_CODE;
        _postSeconLanguage = ENGLISH_CODE;
    }
    
    return self;
}

-(id)initWithDraftModel:(DraftModel*)model
{
    if (self = [super init]) {
        
        _arrPostImagesList = [NSMutableArray new];
        _postMainLanguage = ENGLISH_CODE;
        _postSeconLanguage = ENGLISH_CODE;
        
        int counter = (int)model.arrPost.count;
        
        if(counter == 1)
        {
            _postMainTitle = [model.arrPost[0] title];
            _postMainDescription = [model.arrPost[0] message];
            _postMainLanguage = [model.arrPost[0] language];
        }
        else if(counter == 2)
        {
            _postMainTitle = [model.arrPost[0] title];
            _postMainDescription = [model.arrPost[0] message];
            _postMainLanguage = [model.arrPost[0] language];

            
            _postSecondTitle = [model.arrPost[1] title];
            _postSecondDescription = [model.arrPost[1] message];
            _postSeconLanguage = [model.arrPost[1] language];
            

        }
    
        
        _postURL  = model.link;
        _post_id = model.post_id;
    }
    
    _arrPostImagesList = [model.arrPhotos mutableCopy];
    _reccomendVenueModel = [RecommendationVenueModel new];
    [_reccomendVenueModel processDraftModel:model];
    _selectedCategories = model.category;
    
    
    return self;
}

-(NSMutableArray*)arrDeletedImages
{
    if (!_arrDeletedImages) {
        _arrDeletedImages = [NSMutableArray new];
    }
    
    return _arrDeletedImages;

}
//@property(nonatomic,strong)NSString* postMainTitle;
//@property(nonatomic,strong)NSString* postMainDescription;
//@property(nonatomic,strong)NSString* postSecondTitle;
//@property(nonatomic,strong)NSString* postSecondDescription;
//@property(nonatomic,strong)NSString* postURL;
//@property(nonatomic,strong)NSString* price;
//@property(nonatomic,strong)NSString* post_id;
//@property(nonatomic,strong)NSString* postMainLanguage;
//@property(nonatomic,strong)NSString* postSeconLanguage;
//@property(nonatomic,strong)NSArray* selectedCategories;
//
//
//@property(nonatomic,strong)NSMutableArray* arrDeletedImages;
//
//@property(nonatomic,strong)NSMutableArray* arrPostImagesList;//photoModel
//@property(nonatomic,strong)RecommendationVenueModel* reccomendVenueModel;
-(id) copyWithZone: (NSZone *) zone
{
    RecommendationModel *modelCopy = [[RecommendationModel allocWithZone: zone] init];
    
    modelCopy.arrPostImagesList = [[NSMutableArray alloc]initWithArray:_arrPostImagesList copyItems:YES];
    
    return modelCopy;
}
@end
