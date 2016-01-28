//
//  BaseViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/7/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"


@interface BaseViewController : GAITrackedViewController

-(void)reloadData;
//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end

