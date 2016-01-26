//
//  PromoCodeViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 26/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PromoCodeViewController.h"

@interface PromoCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ibPromoCodeText;
@property (weak, nonatomic) IBOutlet UILabel *ibTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibOuterCloseBtn;
@property (weak, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet UIView *ibOuterContentView;

@end

@implementation PromoCodeViewController

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

-(void)viewDidLayoutSubviews{
    [self.ibContentView setRoundedBorder];
}

- (IBAction)buttonCloseClicked:(id)sender {
    [self hideView];
}

- (IBAction)buttonSubmitClicked:(id)sender {
}

-(void)showView{
    [self show:self.view transparentView:self.ibOuterCloseBtn MovingContentView:self.ibOuterContentView];
}

-(void)hideView{
    [self hideWithAnimation:YES MainView:self.view transparentView:self.ibOuterCloseBtn MovingContentView:self.ibOuterContentView];
}

-(void)show:(UIView*)mainView transparentView:(UIView*)transparentView MovingContentView:(UIView*)mvView
{
    if ( mainView.hidden) {
        mainView.hidden = false;
        
        transparentView.alpha = 0;
        [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            transparentView.alpha = 0.6f;
        } completion:^(BOOL finished) {
            
        }];
        
        mvView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            mvView.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            
        }];
        
    }
    
}

-(void)hideWithAnimation:(BOOL)isAnimate MainView:(UIView*)mainView transparentView:(UIView*)transparentView MovingContentView:(UIView*)mvView
{
    if (!mainView.hidden) {
        transparentView.alpha = 0.6f;
        
        [UIView animateWithDuration:isAnimate?ANIMATION_DURATION:0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            transparentView.alpha = 0;
            
        } completion:^(BOOL finished) {
            mainView.hidden = true;
            
        }];
        
        mvView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            mvView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }completion:^(BOOL finished) {
            
        }];
    }
    
    
}
@end
