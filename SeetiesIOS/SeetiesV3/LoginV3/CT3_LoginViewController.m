//
//  CT3_LoginViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_LoginViewController.h"
#import "LoginPageViewController.h"
#import "SignupPageViewController.h"
#import "PInterestV2ViewController.h"
#import "CTWebViewController.h"
#import "PInterestV2ViewController.h"

@interface CT3_LoginViewController ()
{
    NSArray* imageArray;
    int varietyImageAnimationIndex;

}
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (nonatomic) LoginPageViewController* loginPageViewController;
@property(nonatomic)SignupPageViewController* signUpViewController;
@property(nonatomic)PInterestV2ViewController* pInterestV2ViewController;
@property (weak, nonatomic) IBOutlet UIButton *lblFacebook;
@property (weak, nonatomic) IBOutlet UIButton *lblInstagram;
@property (nonatomic)CTWebViewController* webViewController;

@end

@implementation CT3_LoginViewController
- (IBAction)btnInstagramClicked:(id)sender {
    
    __weak typeof (self)weakSelf = self;
    self.webViewController.didFinishLoadConnectionBlock = ^(void)
    {
        [weakSelf requestServerForInstagramLogin];
    };

    
    [self.navigationController pushViewController:self.webViewController animated:YES onCompletion:^{
        [self.webViewController initDataForInstagram];
       
        
    }];

}
- (IBAction)btnContinueWithoutLoginClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSignupClicked:(id)sender {
    
    [self.navigationController pushViewController:self.signUpViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    varietyImageAnimationIndex = 1;
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    

    imageArray = @[[UIImage imageNamed:@"Walkthrough1.png"],[UIImage imageNamed:@"Walkthrough2.png"],[UIImage imageNamed:@"Walkthrough3.png"],[UIImage imageNamed:@"Walkthrough4.png"]];

    [self animateImages];

    [Utils setRoundBorder:self.lblFacebook color:[UIColor whiteColor] borderRadius:5.0f borderWidth:1.0f];
    [Utils setRoundBorder:self.lblInstagram color:[UIColor whiteColor] borderRadius:5.0f borderWidth:1.0f];

    
}

-(void)animateImages
{
    varietyImageAnimationIndex++;
    
    [UIView transitionWithView:self.ibImageView
                      duration:3.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.ibImageView.image = [imageArray objectAtIndex:varietyImageAnimationIndex % [imageArray count]];
                    } completion:^(BOOL finished) {
                        [self animateImages];
                    }];
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
-(CTWebViewController*)webViewController
{
    
    if(!_webViewController)
    {
        _webViewController = [CTWebViewController new];
        
    }
    
    return _webViewController;
}

-(SignupPageViewController*)signUpViewController
{
    if (!_signUpViewController) {
        _signUpViewController = [SignupPageViewController new];
        
        __weak typeof (self)weakSelf = self;
        _signUpViewController.signUpClickBlock = ^(NSString* username, NSString* password,NSString* email)
        {
            [weakSelf requestServerForRegisterWithUserName:username Password:password Email:email];
            
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
            
            [weakSelf requestServerForLogin:username Password:password OnComplete:nil];

        };

    }
    
    return _loginPageViewController;
}

#pragma mark - Server Request
-(void)requestServerForLogin:(NSString*)userName Password:(NSString*)password OnComplete:(VoidBlock)onComplete
{
 
    [LoadingManager show];
    
    NSDictionary* dict = @{@"login_id" : userName,
                           @"password" : password,
                           @"device_type" : @"2"};
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypeLogin param:dict completeHandler:^(id object) {
        
        if (self.didFinishLoginBlock) {
            self.didFinishLoginBlock();
        }
        
        if (onComplete) {
            onComplete();
            
            return;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } errorBlock:^(id object) {
        
    }];

    
}

-(void)requestServerForFacebookLogin{

    [LoadingManager show];
    FacebookModel* model = [[ConnectionManager dataManager]facebookLoginModel];
  
    NSDictionary* dict = @{@"fb_id" : model.uID,
                           @"fb_token" : model.fbToken,
                           @"role" : @"user",
                           @"device_type" : @(DEVICE_TYPE)};
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypeLoginFacebook param:dict completeHandler:^(id object) {
        

        if (self.didFinishLoginBlock) {
            self.didFinishLoginBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];

    } errorBlock:^(id object) {
        
    }];
    
}


-(void)requestServerForRegisterWithUserName:(NSString*)username Password:(NSString*)password Email:(NSString*)email
{
    NSDictionary* dict = @{@"email" : email,
                           @"username" : username,
                           @"password" : password,
                           @"role" : @"user",
                           @"device_type" : @(DEVICE_TYPE),
                           
                           };
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypeRegister param:dict completeHandler:^(id object) {
        
        NSDictionary* dict = [[NSDictionary alloc]initWithDictionary:object];
        if ([dict[@"status"] isEqualToString:@"ok"]) {
            [self requestServerForLogin:username Password:password OnComplete:^{
                
                [self showUserInterestPage];
            }];
        }
        else{
        
            SLog(@"error : %@",dict[@"message"]);
            
        }
        
    } errorBlock:^(id object) {
        
    }];
    
}

-(void)requestServerForInstagramLogin
{
    
    InstagramModel* model = [[ConnectionManager dataManager]instagramModel];

    NSDictionary* dict = @{@"insta_id" : model.userID,
                           @"insta_token" : model.access_token,
                           @"device_type" : @(DEVICE_TYPE),
                           };
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypeLoginInstagram param:dict completeHandler:^(id object) {
        
        if (self.didFinishLoginBlock) {
            self.didFinishLoginBlock();
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)showUserInterestPage
{
    [self.navigationController pushViewController:self.pInterestV2ViewController animated:YES];
}
-(void)forgetPassword
{

}


@end
