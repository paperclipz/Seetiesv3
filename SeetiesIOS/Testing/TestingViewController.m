//
//  TestingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/18/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "TestingViewController.h"
#import "UIImageView+Extension.h"

@interface TestingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView tintWithOverlay];
    //self.imageView.image = [[UIImage imageNamed:@"BahasaIndonesia.png"] imageWithColorOverlay:[UIColor blackColor]];
//    NSString* apple = @"#this is so good hahahaha #yes";
//    SLog(@"%@",apple.tags);
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
