//
//  LoginPageViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/26/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "LoginPageViewController.h"
#import "CT3_ForgotPasswordViewController.h"

@interface LoginPageViewController ()
@property(nonatomic)CT3_ForgotPasswordViewController* forgotPasswordViewController;

@property (weak, nonatomic) IBOutlet UITextField *lblUserName;
@property (weak, nonatomic) IBOutlet UITextField *lblPassword;
@property (weak, nonatomic) IBOutlet UIView *ibUserContentView;
@property (weak, nonatomic) IBOutlet UIView *ibPasswordContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPassword;
@end

@implementation LoginPageViewController
- (IBAction)btnForgetPassword:(id)sender {
    
    _forgotPasswordViewController = nil;
    [self.navigationController pushViewController:self.forgotPasswordViewController animated:YES];
}

- (IBAction)btnLoginClicked:(id)sender {
    
    if (self.btnLoginClickedBlock) {
        if ([self validate]) {
            self.btnLoginClickedBlock(self.lblUserName.text,self.lblPassword.text);

        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.lblUserName) {
        [self.lblPassword becomeFirstResponder];
    }
    else if (textField == self.lblPassword){
        [self btnLoginClicked:textField];
    }
    
    return NO;
}

-(void)refreshView
{
    self.lblUserName.text = @"";
    self.lblPassword.text = @"";

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self refreshView];
}

-(BOOL)validate
{
    
    if (self.lblPassword.text.length <7) {
        
//        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Password should be more than 8 character") Type:TSMessageNotificationTypeError];
//        [MessageManager showMessage:LocalisedString(@"Password should be more than 8 character") Type:STAlertError];
        [MessageManager popoverErrorMessage:LocalisedString(@"Password should be more than 8 character") target:self popFrom:self.ibPasswordContentView];
        return false;
    }
    else if(self.lblUserName.text.length<=1)
    {
//        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Username should be more than 1 character") Type:TSMessageNotificationTypeError];
//        [MessageManager showMessage:LocalisedString(@"Username should be more than 1 character") Type:STAlertError];
        [MessageManager popoverErrorMessage:LocalisedString(@"Username should be more than 1 character") target:self popFrom:self.ibUserContentView];
        return false;

    }
    
    return YES;
}

-(void)initSelfView
{
    self.lblUserName.placeholder = LocalisedString(@"username/ email address");
    self.lblPassword.placeholder = LocalisedString(@"password");
    
    [Utils setRoundBorder:self.ibUserContentView color:LINE_COLOR borderRadius:self.ibUserContentView.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.ibPasswordContentView color:LINE_COLOR borderRadius:self.ibPasswordContentView.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.btnLogin color:[UIColor clearColor] borderRadius:self.btnLogin.frame.size.height/2 borderWidth:1.0f];

    [self.btnLogin setSideCurveBorder];
}


-(void)changeLanguage
{
    self.lblUserName.placeholder = LocalisedString(@"username/ email address");
    self.lblPassword.placeholder = LocalisedString(@"password");

    self.lblTitle.text = LocalisedString(@"Log in");
    [self.btnLogin setTitle:LocalisedString(@"Log in") forState:UIControlStateNormal];
    [self.btnForgetPassword setTitle:LocalisedString(@"ForgotPassword") forState:UIControlStateNormal];

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

#pragma mark - Declaration

-(CT3_ForgotPasswordViewController*)forgotPasswordViewController
{
    if (!_forgotPasswordViewController) {
        _forgotPasswordViewController = [CT3_ForgotPasswordViewController new];
    }
    
    return _forgotPasswordViewController;
}



@end
