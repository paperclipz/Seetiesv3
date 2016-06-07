//
//  SignupPageViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/27/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SignupPageViewController.h"

@interface SignupPageViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UIView *ibContentUserName;
@property (weak, nonatomic) IBOutlet UIImageView *ibStatusUserName;
@property (weak, nonatomic) IBOutlet UIView *ibContentEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIImageView *ibStatusEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView *ibContentPassword;
@property (weak, nonatomic) IBOutlet UIImageView *ibStatusPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
@property (weak, nonatomic) IBOutlet UILabel *lblSignUp;

@property (weak, nonatomic) IBOutlet UIView *ibInitialReferralView;
@property (weak, nonatomic) IBOutlet UILabel *ibEnterReferralLbl;
@property (weak, nonatomic) IBOutlet UIView *ibReferralView;
@property (weak, nonatomic) IBOutlet UITextField *ibReferralCodeTxt;
@property (weak, nonatomic) IBOutlet UIImageView *ibStatusReferral;

@property(nonatomic) BOOL isChecking;

@end

@implementation SignupPageViewController


- (IBAction)btnSubmitClicked:(id)sender {
    
    if (self.signUpClickBlock) {
        if ([self validate]) {
            if ([Utils isStringNull:self.ibReferralCodeTxt.text]) {
                self.signUpClickBlock(self.txtUserName.text,self.txtPassword.text,self.txtEmail.text, self.ibReferralCodeTxt.text);
            }
            else{
                [self requestServerToCheckUserRegistrationData:self.ibReferralCodeTxt.text forField:@"referral_code"];
            }
        }
    }
}

- (IBAction)btnEnterPromoClicked:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        self.ibReferralView.hidden = NO;
        [self.ibReferralView setAlpha:1];
        [self.ibInitialReferralView setAlpha:0];
        self.ibInitialReferralView.hidden = YES;
    }];
}

-(BOOL)validate
{
    
    if (self.txtPassword.text.length <7) {
        
//        [TSMessage showNotificationInViewController:self title:LocalisedString(@"system") subtitle:LocalisedString(@"Password should be more than 8 character") type:TSMessageNotificationTypeError];
//        [MessageManager showMessage:LocalisedString(@"Password should be more than 8 character") Type:STAlertError];
        [MessageManager popoverErrorMessage:LocalisedString(@"Password should be more than 8 character") target:self popFrom:self.ibContentPassword];
        return false;
    }
    else if(self.txtUserName.text.length<=1)
    {
//        [TSMessage showNotificationInViewController:self title:LocalisedString(@"system") subtitle:LocalisedString(@"Username should be more than 1 character") type:TSMessageNotificationTypeError];
//        [MessageManager showMessage:LocalisedString(@"Username should be more than 1 character") Type:STAlertError];
        [MessageManager popoverErrorMessage:LocalisedString(@"Username should be more than 1 character") target:self popFrom:self.ibContentUserName];

        return false;
        
    }
    else if(![Utils validateEmail:self.txtEmail.text])
    {
//        [TSMessage showNotificationInViewController:self title:LocalisedString(@"system") subtitle:LocalisedString(@"Not valid email address") type:TSMessageNotificationTypeError];
//        [MessageManager showMessage:LocalisedString(@"Not valid email address") Type:STAlertError];
        [MessageManager popoverErrorMessage:LocalisedString(@"Not valid email address") target:self popFrom:self.ibContentEmail];
        return NO;
    }
    else if (self.ibReferralCodeTxt.text.length > 0 && self.ibReferralCodeTxt.text.length != 10){
//        [TSMessage showNotificationInViewController:self title:LocalisedString(@"system") subtitle:LocalisedString(@"Referral code should be exactly 10 characters") type:TSMessageNotificationTypeError];
//        [MessageManager showMessage:LocalisedString(@"Referral code should be exactly 10 characters") Type:STAlertError];
        [MessageManager popoverErrorMessage:LocalisedString(@"Referral code should be exactly 10 characters") target:self popFrom:self.ibReferralView];
        
        return NO;
    }
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    self.isChecking = NO;
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange:(NSNotification*)notification
{
    UITextField *textField = (UITextField*)[notification object];
    //perform logic here, change button state, etc.
    
    switch (textField.tag) {
        case 1:
        {
            if(textField.text.length>=6){
                [self requestServerToCheckUserRegistrationData:textField.text forField:@"username" fromTextField:textField];
            }else{
                [self showStatusForTextField:textField valid:NO showStatus:textField.text.length>0];
            }
        }
            break;
            
        case 2:
        {
            if([Utils validateEmail:textField.text]){
                [self requestServerToCheckUserRegistrationData:textField.text forField:@"email" fromTextField:textField];
            }else{
                [self showStatusForTextField:textField valid:NO showStatus:textField.text.length>0];
            }
        }
            break;
            
        case 3:
        {
            if(textField.text.length>=8){
                [self requestServerToCheckUserRegistrationData:textField.text forField:@"password" fromTextField:textField];
            }else{
                [self showStatusForTextField:textField valid:NO showStatus:textField.text.length>0];
            }
        }
            break;
            
        case 4:
        {
            if(textField.text.length>=10){
                [self requestServerToCheckUserRegistrationData:textField.text forField:@"referral_code" fromTextField:textField];
            }else{
                [self showStatusForTextField:textField valid:NO showStatus:textField.text.length>0];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)showStatusForTextField:(UITextField *)textField valid:(BOOL)valid showStatus:(BOOL)showStatus{
    switch (textField.tag) {
        case 1:
        {
            self.ibStatusUserName.image = [self statusImage:valid];
            self.ibStatusUserName.hidden = !showStatus;
        }
            break;
            
        case 2:
        {
            self.ibStatusEmail.image = [self statusImage:valid];
            self.ibStatusEmail.hidden = !showStatus;
        }
            break;
            
        case 3:
        {
            self.ibStatusPassword.image = [self statusImage:valid];
            self.ibStatusPassword.hidden = !showStatus;
        }
            break;
            
        case 4:
        {
            self.ibStatusReferral.image = [self statusImage:valid];
            self.ibStatusReferral.hidden = !showStatus;
        }
            break;
            
        default:
            break;
    }
}

-(UIImage *)statusImage:(BOOL)valid{
    return [UIImage imageNamed:valid?@"CorrectFill.png":@"WrongFill.png"];
}

-(void)requestServerToCheckUserRegistrationData:(NSString*)data forField:(NSString*)field fromTextField:(UITextField *)fromTextField{
    if ([Utils isStringNull:data] || [Utils isStringNull:field]) {
        return;
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"field" : field,
                                                                                  @"value" : data
                                                                                  }];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostCheckUserRegistrationData parameter:dict appendString:nil success:^(id object) {
        
        [self showStatusForTextField:fromTextField valid:YES showStatus:YES];
    } failure:^(id object) {
        [self showStatusForTextField:fromTextField valid:NO showStatus:YES];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self changeLanguage];
}

-(void)initSelfView
{
    [Utils setRoundBorder:self.ibContentUserName color:LINE_COLOR borderRadius:self.ibContentUserName.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.ibContentEmail color:LINE_COLOR borderRadius:self.ibContentEmail.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.ibContentPassword color:LINE_COLOR borderRadius:self.ibContentPassword.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.ibReferralView color:LINE_COLOR borderRadius:self.ibReferralView.frame.size.height/2 borderWidth:1.0f];
    [self.btnSignup setSideCurveBorder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeLanguage
{
    self.txtUserName.placeholder = LocalisedString(@"create your username");
    self.txtPassword.placeholder = LocalisedString(@"password");
    self.txtEmail.placeholder = LocalisedString(@"email address");
    self.ibEnterReferralLbl.text = LocalisedString(@"Enter referral code");
    self.ibReferralCodeTxt.placeholder = LocalisedString(@"referral code (optional)");
    [self.btnSignup setTitle:LocalisedString(@"Create") forState:UIControlStateNormal];
    
    NSString* asd = LocalisedString(@"Sign up");
    self.lblSignUp.text = asd;


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

#pragma mark - RequestServer
-(void)requestServerToCheckUserRegistrationData:(NSString*)data forField:(NSString*)field{
    if ([Utils isStringNull:data] || [Utils isStringNull:field] || self.isChecking) {
        return;
    }
    
    self.isChecking = YES;
    [LoadingManager show];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"field" : field,
                                                                                  @"value" : data
                                                                                  }];

    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostCheckUserRegistrationData parameter:dict appendString:nil success:^(id object) {
        [LoadingManager hide];
        self.isChecking = NO;
        self.signUpClickBlock(self.txtUserName.text,self.txtPassword.text,self.txtEmail.text, self.ibReferralCodeTxt.text);
        
        
    } failure:^(id object) {
        [LoadingManager hide];
        self.isChecking = NO;
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Your referral code is invalid! But you may continue and try again later.") cancelButtonTitle:LocalisedString(@"Continue") otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            self.signUpClickBlock(self.txtUserName.text,self.txtPassword.text,self.txtEmail.text, self.ibReferralCodeTxt.text);
            
        }];
        
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
@end
