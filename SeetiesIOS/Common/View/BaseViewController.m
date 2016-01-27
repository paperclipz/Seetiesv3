//
//  BaseViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/7/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    __weak IBOutlet NSLayoutConstraint *constTabbarHeight;

}

@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    constTabbarHeight.constant = TAB_BAR_HEIGHT;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(id)init{
    
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = NO;
    }
    
    return self;
}

@end
