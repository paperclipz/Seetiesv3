//
//  EditCollectionTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface EditCollectionTableViewCell : CommonTableViewCell<UITextViewDelegate>
-(void)initData:(PostModel*)model;
@property(nonatomic,copy)IDBlock deleteCellBlock;
-(void)saveData;
@end
