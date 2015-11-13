//
//  EditCollectionViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "UITableView+LongPressReorder.h"
#import "EditCollectionDetailViewController.h"

@interface EditCollectionViewController : CommonViewController <UITableViewDataSource,UITableViewDelegate>
-(void)requestServerForCollectionDetails:(NSString*)collectionID successBlock:(IDBlock)successBlock failBlock:(IDBlock)failBlock;
-(void)initData:(NSString*)collectionID ProfileType:(ProfileViewType)type;
@property(nonatomic,strong)EditCollectionDetailViewController* editCollectionDetailViewController;

@property(nonatomic,copy)IDBlock btnEditClickBlock;
@property(nonatomic,copy)VoidBlock refreshBlock;
@end
