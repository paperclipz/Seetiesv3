//
//  CT3_LoadingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/24/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_LoadingViewController.h"

@interface CT3_LoadingViewController ()

@end

@implementation CT3_LoadingViewController


-(instancetype)init{
    self = [super init];
    
    if (self) {

        SLog(@"%@",self.view);
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
