//
//  CustomPickerViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CustomPickerViewController.h"

@interface CustomPickerViewController ()
{
    __weak IBOutlet UIView *contentView;
    CGRect showFrame;
    CGRect hideFrame;
    BOOL isShow;
    __weak IBOutlet UIButton *ibBtnCancel;
}
@property (weak, nonatomic) IBOutlet UIVisualEffectView *ibTransparentView;
@property (copy, nonatomic) IDBlock buttonOneBlock;
@property (copy, nonatomic) IDBlock buttonTwoBlock;

@end

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
   // [self hideWithAnimation:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        isShow = YES;
    // Do any additional setup after loading the view from its nib.
    
    [self initSelfView];
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

-(void)presentView:(UIView*)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.type = kCATransitionFromTop; //choose your animation
    [self.view.layer addAnimation:transition forKey:nil];
    self.view.frame = [Utils getDeviceScreenSize];
    [view addSubview:self.view];
}

-(void)show
{
    
    if (!isShow) {
        self.view.frame = hideFrame;
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.view.frame = showFrame;
            isShow = true;

            
        } completion:^(BOOL finished) {

        }];

    }
   }

-(void)hideWithAnimation:(BOOL)isAnimate
{
    

    if (isShow) {
        self.view.frame = showFrame;
        
        [UIView animateWithDuration:isAnimate?0.5f:0 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            self.view.frame = hideFrame;
            isShow = false;

        } completion:^(BOOL finished) {
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
