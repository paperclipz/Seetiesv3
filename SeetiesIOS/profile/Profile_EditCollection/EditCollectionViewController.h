//
//  EditCollectionViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "UITableView+LongPressReorder.h"

@interface EditCollectionViewController : CommonViewController <UITableViewDataSource,UITableViewDelegate>
-(void)requestServerForCollectionDetails:(NSString*)collectionID successBlock:(IDBlock)successBlock failBlock:(IDBlock)failBlock;
-(void)initData:(CollectionModels*)model;

@property(nonatomic,copy)IDBlock btnEditClickBlock;
@end
