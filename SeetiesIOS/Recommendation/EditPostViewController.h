//
//  EditPostViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommentViewController.h"
#import "CustomPickerViewController.h"
#import "RecommendationModel.h"
#import "ArticleViewController.h"


typedef enum
{
    EditPostTypeDraft = 0,
    EditPostTypeDraftNew = 1,
    EditPostTypePostEdit
} EditPostType;


@interface EditPostViewController : CommonViewController
//-(void)initData:(RecommendationModel*)model;
-(void)initDataDraft:(DraftModel*)model;
-(void)loadData;
-(void)initDataPostEdit:(DraftModel*)model;

@property(nonatomic,strong)CustomPickerViewController* customPickerViewController;
@property(nonatomic,strong)ArticleViewController* articleViewController;

@property(nonatomic,assign)EditPostType editPostType;

@property(nonatomic,copy)IDBlock editPostBackBlock;
@property(nonatomic,copy)IDBlock editPostDoneBlock;


-(void)requestServerForPostInfo:(NSString*)postID completionBLock:(VoidBlock)completionBlock;

@end
