//
//  EditPostViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommentViewController.h"
#import "NMBottomTabBarController.h"
@interface EditPostViewController : CommentViewController
-(void)initData;

@property(nonatomic,strong)NMBottomTabBarController* nmBottomTabBarController;


@end
