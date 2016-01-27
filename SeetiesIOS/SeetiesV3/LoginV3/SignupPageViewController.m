//
//  SignupPageViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/27/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SignupPageViewController.h"

@interface SignupPageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UIView *ibContentUserName;
@property (weak, nonatomic) IBOutlet UIView *ibContentEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView *ibContentPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation SignupPageViewController
- (IBAction)btnSubmitClicked:(id)sender {
    
    if (self.signUpClickBlock) {
        self.signUpClickBlock(self.txtUserName.text,self.txtPassword.text,self.txtEmail.text);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    [Utils setRoundBorder:self.ibContentUserName color:TEXT_GRAY_COLOR borderRadius:self.ibContentUserName.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.ibContentEmail color:TEXT_GRAY_COLOR borderRadius:self.ibContentEmail.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.ibContentPassword color:TEXT_GRAY_COLOR borderRadius:self.ibContentPassword.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.btnSubmit color:[UIColor clearColor] borderRadius:self.btnSubmit.frame.size.height/2 borderWidth:1.0f];
    
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
