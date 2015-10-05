//
//  CustomEditPhotoTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//


@class CustomEditPhotoTableViewCell;

typedef void (^CellBlock)(CustomEditPhotoTableViewCell* cell);

@interface CustomEditPhotoTableViewCell : UITableViewCell<UITextViewDelegate>

-(void)initData:(PhotoModel*)model;
@property(nonatomic,copy)CellBlock deleteBlock;
@property(nonatomic,copy)CellBlock editBlock;
@property(nonatomic,strong)PhotoModel* model;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@end