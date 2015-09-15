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
    }
    
    return self;
}

-(id)initWithDraftModel:(DraftModel*)model
{
    if (self = [super init]) {
        
        _arrPostImagesList = [NSMutableArray new];
                
        for (int i = 0 ; i<model.arrPost.count; i++) {
            
            if (i == 0) {
                _postMainTitle = [model.arrPost[0] title];
                _postMainDescription = [model.arrPost[0] message];

            }
            else
            {
                _postSecondTitle = [model.arrPost[1] title];
                _postSecondDescription = [model.arrPost[1] message];
            }
        }
        
        _postURL  = model.link;

    }
    
    _arrPostImagesList = [model.arrPhotos mutableCopy];
    
    return self;
}

@end
