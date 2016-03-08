//
//  SignupPageViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/27/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SignupPageViewController.h"
#import "ForgotPasswordViewController.h"

@interface SignupPageViewController ()
@property(nonatomic)ForgotPasswordViewController* forgotPasswordViewController;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UIView *ibContentUserName;
@property (weak, nonatomic) IBOutlet UIView *ibContentEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView *ibContentPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
@property (weak, nonatomic) IBOutlet UILabel *lblSignUp;

@end

@implementation SignupPageViewController


- (IBAction)btnSubmitClicked:(id)sender {
    
    if (self.signUpClickBlock) {
        if ([self validate]) {
            self.signUpClickBlock(self.txtUserName.text,self.txtPassword.text,self.txtEmail.text);

        }
    }
}

-(BOOL)validate
{
    
    if (self.txtPassword.text.length <7) {
        
        [TSMessage showNotificationInViewController:self title:LOCALIZATION(@"system") subtitle:LOCALIZATION(@"Password should be more than 8 character") type:TSMessageNotificationTypeError];
        
        return false;
    }
    else if(self.txtUserName.text.length<=1)
    {
        [TSMessage showNotificationInViewController:self title:LOCALIZATION(@"system") subtitle:LOCALIZATION(@"Username should be more than 1 character") type:TSMessageNotificationTypeError];

        return false;
        
    }
    else if(![Utils validateEmail:self.txtEmail.text])
    {
        [TSMessage showNotificationInViewController:self title:LOCALIZATION(@"system") subtitle:LOCALIZATION(@"Not valid email address") type:TSMessageNotificationTypeError];

    }
    
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    [self changeLanguage];
    [Utils setRoundBorder:self.ibContentUserName color:LINE_COLOR borderRadius:self.ibContentUserName.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.ibContentEmail color:LINE_COLOR borderRadius:self.ibContentEmail.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.ibContentPassword color:LINE_COLOR borderRadius:self.ibContentPassword.frame.size.height/2 borderWidth:1.0f];
    [self.btnSignup setSideCurveBorder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeLanguage
{
    self.txtUserName.placeholder = LocalisedString(@"username/ email address");
    self.txtPassword.placeholder = LocalisedString(@"password");
    self.txtEmail.placeholder = LocalisedString(@"email address");

    [self.btnSignup setTitle:LocalisedString(@"Submit") forState:UIControlStateNormal];
    self.lblSignUp.text = LocalisedString(@"Sign up");


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

-(ForgotPasswordViewController*)forgotPasswordViewController
{
    if (!_forgotPasswordViewController) {
        _forgotPasswordViewController = [ForgotPasswordViewController new];
    }
    
    return _forgotPasswordViewController;
}


@end
