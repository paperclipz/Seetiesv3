//
//  EditPostViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommentViewController.h"
#import "NMBottomTabBarController.h"
#import "CustomPickerViewController.h"
#import "RecommendationModel.h"


typedef enum
{
    EditPostTypeDraft = 0,
    EditPostTypeDraftNew = 1
} EditPostType;


@interface EditPostViewController : CommonViewController
-(void)initData:(RecommendationModel*)model;
-(void)initDataDraft:(DraftModel*)model;
-(void)loadData;

@property(nonatomic,strong)NMBottomTabBarController* nmBottomTabBarController;
@property(nonatomic,strong)CustomPickerViewController* customPickerViewController;
@property(nonatomic,assign)EditPostType editPostType;

@property(nonatomic,copy)IDBlock editPostBackBlock;

@end
