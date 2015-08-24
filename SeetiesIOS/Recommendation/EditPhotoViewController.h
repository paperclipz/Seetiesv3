//
//  EditPhotoViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/20/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommentViewController.h"
#import "CustomEditPhotoTableViewCell.h"
#import "UITableView+LongPressReorder.h"
#import "BMXSwipableCell.h"

@interface EditPhotoViewController : CommentViewController<UITableViewDataSource,UITableViewDelegate,BMXSwipableCellDelegate>

@end
