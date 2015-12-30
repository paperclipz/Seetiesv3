//
//  EditCollectionDetailViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/23/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"


@interface EditCollectionDetailViewController : CommonViewController<UICollectionViewDataSource,UICollectionViewDelegate>
-(void)initData:(CollectionModel*)model;

@property(nonatomic,copy)IDBlock btnDoneBlock;
@property(nonatomic,copy)VoidBlock btnCancelBlock;

@end
