//
//  RecommendationViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/11/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetHelper.h"
#import "DoImagePickerController.h"
#import "EditPhotoViewController.h"
#import "EditPostViewController.h"
#import "STSearchViewController.h"
#import "AddNewPlaceViewController.h"
#import "DraftViewController.h"


@interface RecommendationViewController : BaseViewController<DoImagePickerControllerDelegate>

@property(nonatomic,strong)UINavigationController* navRecommendationViewController;

@property(nonatomic,strong)STSearchViewController* stSearchViewController;
@property(nonatomic,strong)DoImagePickerController* doImagePickerController;
@property(nonatomic,strong)EditPostViewController* editPostViewController;
@property(nonatomic,strong)UINavigationController* navEditPostViewController;
@property(nonatomic,strong)AddNewPlaceViewController* addNewPlaceViewController;
@property(nonatomic,strong)DraftViewController* draftViewController;

@property(nonatomic,copy)IDBlock backBlock;
@property(nonatomic,copy)IDBlock donePostBlock;

-(void)initData:(int)type sender:(id)sender;

@end
