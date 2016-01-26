//
//  CustomPickerViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CustomPickerViewController.h"

#define ANIMATION_DURATION 0.5f
@interface CustomPickerViewController ()
{
    __weak IBOutlet UIView *contentView;
    CGRect showFrame;
    CGRect hideFrame;
    BOOL isShow;
    __weak IBOutlet UIButton *btnDraft;
    __weak IBOutlet UIButton *ibBtnCancel;
    __weak IBOutlet UIButton *btnRecommendation;
    __weak IBOutlet UIImageView *frameOne;
    __weak IBOutlet UIImageView *frameTwo;
}
@property (copy, nonatomic) IDBlock buttonOneBlock;
@property (copy, nonatomic) IDBlock buttonTwoBlock;
@property (weak, nonatomic) IBOutlet UIImageView *ibTransparentView;
@property (weak, nonatomic) IBOutlet UIView *ibFullContentView;

@end

#pragma mark - IBACTION
@implementation CustomPickerViewController
- (IBAction)btnAddURLClicked:(id)sender {
    if(self.buttonOneBlock)
    {
        self.buttonOneBlock(self);
        [self hideWithAnimation:YES];
    }
        
}
- (IBAction)btnAddLangClicked:(id)sender {
    if(self.buttonTwoBlock)
    {
        self.buttonTwoBlock(self);
        [self hideWithAnimation:YES];

    }
}
- (IBAction)btnCancelClicked:(id)sender {
    if(self.cancelBlock)
    {
        self.cancelBlock(self);
        [self hideWithAnimation:YES];

    }
}

-(void)btnBackClicked:(id)sender
{
    [self hideWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hidden = true;
    // Do any additional setup after loading the view from its nib.
    
    [self initSelfView];
    [self changeLanguage];
    
    SLog(@"frame one w: %f || H : %f",frameOne.frame.size.width,frameOne.frame.size.height);
    SLog(@"frame Two w: %f || H : %f",frameTwo.frame.size.width,frameTwo.frame.size.height);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    self.view.frame = [Utils getDeviceScreenSize];
    showFrame = self.view.frame;
    hideFrame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    UITapGestureRecognizer *single_tap_recognizer;
    single_tap_recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnBackClicked:)];
    [single_tap_recognizer setNumberOfTouchesRequired : 1];
    [self.ibTransparentView addGestureRecognizer : single_tap_recognizer];
    
    [self makeBorderRound:ibBtnCancel];
    [self makeBorderRound:contentView];
}

-(void)makeBorderRound:(UIView*)view
{
    [[view layer] setBorderWidth:0.3f];
    [[view layer] setCornerRadius:5.0f];
}

//-(void)presentView:(UIView*)view
//{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1.0f;
//    transition.type = kCATransitionFromTop; //choose your animation
//    [self.view.layer addAnimation:transition forKey:nil];
//    self.view.frame = [Utils getDeviceScreenSize];
//    [view addSubview:self.view];
//}

-(void)show
{
    [self show:self.view transparentView:self.ibTransparentView MovingContentView:self.ibFullContentView];
}

-(void)hideWithAnimation:(BOOL)isAnimate
{
    [self hideWithAnimation:isAnimate MainView:self.view transparentView:self.ibTransparentView MovingContentView:self.ibFullContentView];
}

-(void)show:(UIView*)mainView transparentView:(UIView*)transparentView MovingContentView:(UIView*)mvView
{
    if ( mainView.hidden) {
        mainView.hidden = false;
        
        mvView.frame = hideFrame;
        transparentView.alpha = 0;
        [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            mvView.frame = showFrame;
            transparentView.alpha = 1.0f;
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }

}

-(void)hideWithAnimation:(BOOL)isAnimate MainView:(UIView*)mainView transparentView:(UIView*)transparentView MovingContentView:(UIView*)mvView
{
    if (!mainView.hidden) {
        mvView.frame = showFrame;
        transparentView.alpha = 1.0f;
        
        [UIView animateWithDuration:isAnimate?ANIMATION_DURATION:0 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            mvView.frame = hideFrame;
            transparentView.alpha = 0;
            
        } completion:^(BOOL finished) {
            mainView.hidden = true;
            
        }];
    }

    
}

+(id)initializeWithBlock:(IDBlock)buttonOne buttonTwo:(IDBlock)buttonTwo cancelBlock:(IDBlock)cancelBlock
{
    CustomPickerViewController* temp = [CustomPickerViewController new];
    temp.buttonOneBlock = buttonOne;
    temp.buttonTwoBlock = buttonTwo;
    temp.cancelBlock = cancelBlock;
    return temp;
}

#pragma mark -Change Lanugage
-(void)changeLanguage
{
    
    [btnDraft setTitle:LocalisedString(@"Saved drafts") forState:UIControlStateNormal];
    [btnRecommendation setTitle:LocalisedString(@"Write a recommendation") forState:UIControlStateNormal];
    [ibBtnCancel setTitle:LocalisedString(@"Cancel") forState:UIControlStateNormal];
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
