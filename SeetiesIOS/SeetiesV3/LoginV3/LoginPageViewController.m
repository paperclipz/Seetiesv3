//
//  LoginPageViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/26/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "LoginPageViewController.h"
#import "ForgotPasswordViewController.h"

@interface LoginPageViewController ()
@property(nonatomic)ForgotPasswordViewController* forgotPasswordViewController;

@property (weak, nonatomic) IBOutlet UITextField *lblUserName;
@property (weak, nonatomic) IBOutlet UITextField *lblPassword;
@property (weak, nonatomic) IBOutlet UIView *ibUserContentView;
@property (weak, nonatomic) IBOutlet UIView *ibPasswordContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
}

-(BOOL)validate
{
    
    if (self.lblPassword.text.length <7) {
        
        [MessageManager showMessage:LOCALIZATION(@"system") SubTitle:LOCALIZATION(@"Password should be more than 8 character") Type:TSMessageNotificationTypeError];
        
        return false;
    }
    else if(self.lblUserName.text.length<=1)
    {
        [MessageManager showMessage:LOCALIZATION(@"system") SubTitle:LOCALIZATION(@"Username should be more than 1 character") Type:TSMessageNotificationTypeError];
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

    self.lblTitle.text = LocalisedString(@"Log In");
    [self.btnLogin setTitle:LocalisedString(@"Log In") forState:UIControlStateNormal];
    [self.btnForgetPassword setTitle:LocalisedString(@"Forget password?") forState:UIControlStateNormal];

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

-(ForgotPasswordViewController*)forgotPasswordViewController
{
    if (!_forgotPasswordViewController) {
        _forgotPasswordViewController = [ForgotPasswordViewController new];
    }
    
    return _forgotPasswordViewController;
}

@end
