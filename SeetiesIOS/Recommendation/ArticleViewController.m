//
//  ArticleViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UIView *ibFullContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibBackgroundView;
@end

@implementation ArticleViewController
- (IBAction)btnBackClicked:(id)sender {
    [self hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = [Utils getDeviceScreenSize];
    self.view.frame = frame;
    [self.view needsUpdateConstraints];
    self.view.hidden = YES;
    
    SLog(@"image name %@",LocalisedString(@"qrimage"));
    self.ibImageView.image = [UIImage imageNamed:LocalisedString(@"qrimage")];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)show
{
    [self show:self.view transparentView:self.ibBackgroundView MovingContentView:self.ibFullContentView];

}

-(void)hide
{
    [self hideWithAnimation:YES MainView:self.view transparentView:self.ibBackgroundView MovingContentView:self.ibFullContentView];

}
-(void)show:(UIView*)mainView transparentView:(UIView*)transparentView MovingContentView:(UIView*)mvView
{
    if (mainView.hidden) {
        mvView.frame = CGRectMake(0 , self.view.frame.size.height,  self.view.frame.size.width,  self.view.frame.size.height);

        mainView.hidden = false;
        transparentView.alpha = 0;
        
        [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            mvView.frame = CGRectMake(0, 0,  self.view.frame.size.width,  self.view.frame.size.height);
            transparentView.alpha = 1.0f;
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

-(void)hideWithAnimation:(BOOL)isAnimate MainView:(UIView*)mainView transparentView:(UIView*)transparentView MovingContentView:(UIView*)mvView
{
    if (!mainView.hidden) {
        transparentView.alpha = 1.0f;
        
        [UIView animateWithDuration:isAnimate?ANIMATION_DURATION:0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            mvView.frame = CGRectMake(0, self.view.frame.size.height,  self.view.frame.size.width,  self.view.frame.size.height);
            transparentView.alpha = 0;
            
        } completion:^(BOOL finished) {
            mainView.hidden = true;
            
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
