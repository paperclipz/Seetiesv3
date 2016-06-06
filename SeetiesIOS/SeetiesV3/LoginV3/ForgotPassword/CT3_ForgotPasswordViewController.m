//
//  CT3_ForgotPasswordViewController.m
//  Seeties
//
//  Created by Lup Meng Poo on 24/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_ForgotPasswordViewController.h"

@interface CT3_ForgotPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibInstructionLbl;
@property (weak, nonatomic) IBOutlet UIView *ibUsernameView;
@property (weak, nonatomic) IBOutlet UITextField *ibUsernameTxt;
@property (weak, nonatomic) IBOutlet UIButton *ibResetBtn;

@property BOOL isRequesting;
@end

@implementation CT3_ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isRequesting = NO;
    
    [Utils setRoundBorder:self.ibUsernameView color:OUTLINE_COLOR borderRadius:self.ibUsernameView.frame.size.height/2];
    [Utils setRoundBorder:self.ibResetBtn color:[UIColor clearColor] borderRadius:self.ibResetBtn.frame.size.height/2];
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)changeLanguage{
    self.ibHeaderTitle.text = LocalisedString(@"Forgot Password");
    self.ibInstructionLbl.text = LocalisedString(@"You'll receive instructions to reset your password in your mailbox as soon as we're done here!");
    self.ibUsernameTxt.placeholder = LocalisedString(@"Username / Email Address");
    [self.ibResetBtn setTitle:LocalisedString(@"Reset my password") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)verifyInput{
    return [Utils isStringNull:self.ibUsernameTxt.text]? NO : YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnResetClicked:(id)sender {
    if ([self verifyInput]) {
        [self requestServerForResetPassword];
    }
    else{
//        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Username / email cannot be empty") Type:TSMessageNotificationTypeError];
        [MessageManager showMessage:LocalisedString(@"Username / email cannot be empty") Type:STAlertError];
    }
}

-(void)requestServerForResetPassword{
    if (self.isRequesting) {
        return;
    }
    
    NSDictionary *dict = @{@"login_id": self.ibUsernameTxt.text? self.ibUsernameTxt.text : @""};
    
    self.isRequesting = YES;
    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostForgotPassword parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];
        self.isRequesting = NO;
        
//        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Check your email.") Type:TSMessageNotificationTypeSuccess];
        [MessageManager showMessage:LocalisedString(@"Check your email.") Type:STAlertSuccess];
        
    } failure:^(id object) {
        
        [LoadingManager hide];
        self.isRequesting = NO;
        
//        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Are you sure you've registered?") Type:TSMessageNotificationTypeError];
        [MessageManager showMessage:LocalisedString(@"Are you sure you've registered?") Type:STAlertError];
        
    }];
}

@end
