//
//  EditPhotoViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/20/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CustomEditPhotoTableViewCell.h"
#import "UITableView+LongPressReorder.h"
#import "DoImagePickerController.h"

#import "AviarySDK.h"
typedef void (^ImageBlock)(UIImage* image);
typedef void (^DoneBlock)(NSArray* arrayImages,NSArray* arrDeleteImages);

@interface EditPhotoViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,DoImagePickerControllerDelegate,AFPhotoEditorControllerDelegate>
-(void)initData:(RecommendationModel*)model;

@property(nonatomic,strong)DoImagePickerController* imagePickerViewController;

@property(nonatomic,copy)DoneBlock doneBlock;

@end
