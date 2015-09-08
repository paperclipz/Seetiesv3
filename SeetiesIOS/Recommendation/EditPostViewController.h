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
@interface EditPostViewController : CommonViewController
-(void)initData:(RecommendationModel*)model;

@property(nonatomic,strong)NMBottomTabBarController* nmBottomTabBarController;
@property(nonatomic,strong)CustomPickerViewController* customPickerViewController;

@end
