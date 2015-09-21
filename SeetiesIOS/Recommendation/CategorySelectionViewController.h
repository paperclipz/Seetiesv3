//
//  CategorySelectionViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/3/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategorySelectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,copy)IDBlock doneClickBlock;
@property (strong, nonatomic)NSArray* arrCategories;

@end
