//
//  ArticleViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()
{
    BOOL isShow;
}
@property (weak, nonatomic) IBOutlet UIImageView *ibBackgroundView;
@end

@implementation ArticleViewController
- (IBAction)btnBackClicked:(id)sender {
    [self hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isShow =false;
    CGRect frame = [Utils getDeviceScreenSize];
    self.view.frame = CGRectMake(0, frame.size.height,  frame.size.width,  frame.size.height);

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)show
{

    if (!isShow) {
        self.ibBackgroundView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = CGRectMake(0, 0,  self.view.frame.size.width,  self.view.frame.size.height);
            self.ibBackgroundView.alpha = 1.0f;

        }];
        isShow = true;
    }
    
}

-(void)hide
{
    if (isShow) {
        self.ibBackgroundView.alpha = 1.0f;

        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = CGRectMake(0, self.view.frame.size.height,  self.view.frame.size.width,  self.view.frame.size.height);
            isShow = false;
            self.ibBackgroundView.alpha = 0;
        }];
    }


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
