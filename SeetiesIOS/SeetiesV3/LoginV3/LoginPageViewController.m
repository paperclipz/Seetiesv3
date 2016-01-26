//
//  LoginPageViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/26/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "LoginPageViewController.h"

@interface LoginPageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *lblUserName;
@property (weak, nonatomic) IBOutlet UITextField *lblPassword;
@property (weak, nonatomic) IBOutlet UIView *ibUserContentView;
@property (weak, nonatomic) IBOutlet UIView *ibPasswordContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@end

@implementation LoginPageViewController
- (IBAction)btnForgetPassword:(id)sender {
}
- (IBAction)btnLoginClicked:(id)sender {
    
    if (self.btnLoginClickedBlock) {
        self.btnLoginClickedBlock(self.lblUserName.text,self.lblPassword.text);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
}

-(void)initSelfView
{
    self.lblUserName.placeholder = LocalisedString(@"username/ email address");
    self.lblPassword.placeholder = LocalisedString(@"password");
    
    [Utils setRoundBorder:self.ibUserContentView color:TEXT_GRAY_COLOR borderRadius:self.ibUserContentView.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.ibPasswordContentView color:TEXT_GRAY_COLOR borderRadius:self.ibPasswordContentView.frame.size.height/2 borderWidth:1.0f];
    [Utils setRoundBorder:self.btnLogin color:[UIColor clearColor] borderRadius:self.btnLogin.frame.size.height/2 borderWidth:1.0f];

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
