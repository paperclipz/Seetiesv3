//
//  RecommendationViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/11/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectImageViewController.h"
#import "AssetHelper.h"
#import "DoImagePickerController.h"
#import "WhereIsThisViewController.h"
#import "EditPhotoViewController.h"

#import "STSearchViewController.h"

@interface RecommendationViewController : BaseViewController<DoImagePickerControllerDelegate>

@property(nonatomic,strong)SelectImageViewController* assetPickerViewController;
@property(nonatomic,strong)STSearchViewController* stSearchViewController;
@property(nonatomic,strong)DoImagePickerController* doImagePickerController;

@property(nonatomic,strong)EditPhotoViewController* editPhotoViewController;

@end
