//
//  CT3_LoginViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_LoginViewController.h"
#import "LoginPageViewController.h"
#import "SignUpViewController.h"
#import "PInterestV2ViewController.h"

@interface CT3_LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (nonatomic) LoginPageViewController* loginPageViewController;
@property(nonatomic)SignUpViewController* signUpViewController;
@property(nonatomic)PInterestV2ViewController* pInterestV2ViewController;
@property (weak, nonatomic) IBOutlet UIButton *lblFacebook;
@property (weak, nonatomic) IBOutlet UIButton *lblInstagram;

@end

@implementation CT3_LoginViewController

- (IBAction)btnSignupClicked:(id)sender {
    
    [self.navigationController pushViewController:self.signUpViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    self.ibImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"Walkthrough1.png"],
                                         [UIImage imageNamed:@"Walkthrough2.png"],
                                         [UIImage imageNamed:@"Walkthrough3.png"],
                                         [UIImage imageNamed:@"Walkthrough4.png"], nil];
    self.ibImageView.animationDuration = 5.0f;
    self.ibImageView.animationRepeatCount = 0;
    [self.ibImageView startAnimating];
    
    [Utils setRoundBorder:self.lblFacebook color:[UIColor whiteColor] borderRadius:5.0f borderWidth:1.0f];
    [Utils setRoundBorder:self.lblInstagram color:[UIColor whiteColor] borderRadius:5.0f borderWidth:1.0f];

    
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
- (IBAction)btnLoginClicked:(id)sender {
    
    
    [self.navigationController pushViewController:self.loginPageViewController animated:YES];
}

-(IBAction)btnFacebookClicked:(id)sender{
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_birthday"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         switch (state) {
             case FBSessionStateOpen:{
                 [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                     if (error) {
                         
                         NSLog(@"error:%@",error);
                         
                         
                     }
                     else
                     {
                         FacebookModel* model = [FacebookModel new];

                         NSLog(@"Facebook Return Result : %@",user);

                         NSString* fb_user_id = (NSString *)[user valueForKey:@"id"];
                         [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
                             if (error) {
                                 // Handle error
                             }else {
                                 model.uID = fb_user_id;
                                 model.name = [FBuser name];
                                 model.userProfileImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", fb_user_id];
                                 model.email = [user valueForKey:@"email"];
                                 model.gender = [user valueForKey:@"gender"];
                                 model.dob = [user valueForKey:@"birthday"];
                                 model.userName = [user valueForKey:@"last_name"];
                                 model.userFullName = [[NSString alloc]initWithFormat:@"%@%@",[user valueForKey:@"first_name"],[user valueForKey:@"last_name"]];
                             
                              //   NSLog(@"session is %@",session);
                                 
                                 model.fbToken = [FBSession activeSession].accessTokenData.accessToken;
                                 [ConnectionManager dataManager].facebookLoginModel = model;
                                 [self requestServerForFacebookLogin];
                             }
                         }];
                         
                     }
                 }];
                 break;
             }
             case FBSessionStateClosed:
             case FBSessionStateClosedLoginFailed:
                 [FBSession.activeSession closeAndClearTokenInformation];
                 SLog(@"Facebook Login Failed");
                 break;
                 
             default:
                 break;
         }
         
         // Retrieve the app delegate
      //   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
       //  [appDelegate sessionStateChanged:session state:state error:error];
         
     }];
    //    }
    
}
#pragma mark - Declaration

-(PInterestV2ViewController*)pInterestV2ViewController
{
    if (!_pInterestV2ViewController) {
        _pInterestV2ViewController = [PInterestV2ViewController new];
    }
    
    return _pInterestV2ViewController;
}

-(SignUpViewController*)signUpViewController
{
    if (!_signUpViewController) {
        _signUpViewController = [SignUpViewController new];
        _signUpViewController.signUpClickBlock = ^(NSString* username, NSString* password,NSString* email)
        {
            
            
        };
    }
    
    return _signUpViewController;
}

-(LoginPageViewController*)loginPageViewController
{
    if (!_loginPageViewController) {
        _loginPageViewController = [LoginPageViewController new];
        
        
        __weak typeof (self)weakSelf = self;
        _loginPageViewController.btnLoginClickedBlock = ^(NSString* username,NSString* password)
        {
            
            [weakSelf requestServerForLogin:username Password:password];

        };

    }
    
    return _loginPageViewController;
}

#pragma mark - Server Request
-(void)requestServerForLogin:(NSString*)userName Password:(NSString*)password
{
 
    [LoadingManager show];
    
    NSDictionary* dict = @{@"login_id" : userName,
                           @"password" : password,
                           @"device_type" : @"2"};
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypeLogin param:dict completeHandler:^(id object) {
        
        if (self.didFinishLoginBlock) {
            self.didFinishLoginBlock();
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } errorBlock:^(id object) {
        
    }];

    
}

-(void)requestServerForFacebookLogin{

    [LoadingManager show];
    FacebookModel* model = [[ConnectionManager dataManager]facebookLoginModel];
  
    NSDictionary* dict = @{@"fb_id" : model.uID,
                           @"fb_token" : model.fbToken,
                           @"role" : @"user",
                           @"device_type" : @"2"};
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypeLoginFacebook param:dict completeHandler:^(id object) {
        

        if (self.didFinishLoginBlock) {
            self.didFinishLoginBlock();
        }
        [self.navigationController popToRootViewControllerAnimated:YES];

    } errorBlock:^(id object) {
        
    }];
    
}

-(void)forgetPassword
{

}


@end
