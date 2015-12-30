//
//  PhotoViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/3/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"

@interface PhotoViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;

-(void)initData:(NSArray*)array scrollToIndexPath:(NSIndexPath*)indexPath;

-(void)collectionViewSrollToIndexPath;
@property (weak, nonatomic) IBOutlet UIView *ibDragableView;
@property(nonatomic,copy)IndexPathBlock didPopViewControllerAtIndexPathBlock;

@property(nonatomic,copy)VoidBlock triggerLoadMoreBlock;

@end
