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
#import "CTWebViewController.h"
#import "SelectCategoryViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FBLoginManager.h"

@interface CT3_LoginViewController ()
{
    NSArray* imageArray;
    int varietyImageAnimationIndex;
    BOOL isMiddleOfRegistering;
    BOOL isMiddleOfLogin;
    BOOL isMiddleOfFacebookLogin;
    BOOL isMiddleOfInstaLogin;

}
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (nonatomic) LoginPageViewController* loginPageViewController;
@property(nonatomic)SignupPageViewController* signUpViewController;
@property (weak, nonatomic) IBOutlet UIButton *lblFacebook;
@property (weak, nonatomic) IBOutlet UIButton *lblInstagram;
@property (nonatomic)CTWebViewController* webViewController;
@property (nonatomic)SelectCategoryViewController* selectCategoryViewController;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;

@property (weak, nonatomic) IBOutlet UILabel *lblContinueWith;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@end

@implementation CT3_LoginViewController
- (IBAction)btnInstagramClicked:(id)sender {
  
    [self validateBeforeLogin];
    __weak typeof (self)weakSelf = self;
    _webViewController = nil;
    self.webViewController.title = LocalisedString(@"Instagram");
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

    if (self.continueWithoutLoginBlock) {
        self.continueWithoutLoginBlock();
    }
}

- (IBAction)btnSignupClicked:(id)sender {
    
    [self validateBeforeLogin];
    self.signUpViewController = nil;
    [self.navigationController pushViewController:self.signUpViewController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self changeLanguage];
    varietyImageAnimationIndex = 1;
    isMiddleOfRegistering = NO;
    isMiddleOfLogin = NO;
    isMiddleOfFacebookLogin = NO;
    isMiddleOfInstaLogin = NO;
    // Do any additional setup after loading the view from its nib.
}

-(void)validateBeforeLogin
{
    BOOL isProduction = [Utils getIsDevelopment];
    NSDictionary* dict = [Utils getSavedUserLocation];
    BOOL walkthrough = [[[NSUserDefaults standardUserDefaults]objectForKey:FIRST_TIME_SHOW_DEAL_WALKTHROUGH] boolValue];
    BOOL warning = [[[NSUserDefaults standardUserDefaults]objectForKey:FIRST_TIME_SHOW_DEAL_WARNING] boolValue];

    NSData* data = [Utils getParseToken];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    
    @try {
        [Utils setIsDevelopment:isProduction];
        [Utils saveUserLocation:dict[KEY_LOCATION] Longtitude:dict[KEY_LONGTITUDE] Latitude:dict[KEY_LATITUDE]PlaceID:dict[KEY_PLACE_ID] CountryID:[dict[KEY_COUNTRY_ID] intValue] SourceType:dict[KEY_SOURCE_TYPE]];
        [[NSUserDefaults standardUserDefaults]setBool:walkthrough forKey:FIRST_TIME_SHOW_DEAL_WALKTHROUGH];
        [[NSUserDefaults standardUserDefaults]setBool:warning forKey:FIRST_TIME_SHOW_DEAL_WARNING];

        [Utils setParseToken:data];
    }
    @catch (NSException *exception) {
        SLog(@"assign validateBeforeLogin fail");
    }
   
}

-(void)initSelfView
{
    

    imageArray = @[[UIImage imageNamed:@"Splash1.jpg"]];

    //self.ibImageView.image = [imageArray objectAtIndex:0];

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
    
    [self validateBeforeLogin];

    [self.navigationController pushViewController:self.loginPageViewController animated:YES];
}

-(IBAction)btnFacebookClicked:(id)sender{
    
    [self validateBeforeLogin];
    
    __weak typeof (self)weakSelf = self;
    
    [FBLoginManager performFacebookLogin:self completionBlock:^(FBSDKLoginManagerLoginResult *result) {
       
        if (result.isCancelled) {
            return;
        }
        else {
            [FBLoginManager performFacebookGraphRequest:^(FacebookModel *model) {
                
                [ConnectionManager dataManager].facebookLoginModel = model;
                [weakSelf requestServerForFacebookLogin];
            }];
        }
    }];

    
//    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_birthday"]
//                                       allowLoginUI:YES
//                                  completionHandler:
//     ^(FBSession *session, FBSessionState state, NSError *error) {
//         
//         switch (state) {
//             case FBSessionStateOpen:{
//                 [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
//                     if (error) {
//                         
//                         NSLog(@"error:%@",error);
//                         
//                         
//                     }
//                     else
//                     {
//                         FacebookModel* model = [FacebookModel new];
//
//                         NSLog(@"Facebook Return Result : %@",user);
//
//                         NSString* fb_user_id = (NSString *)[user valueForKey:@"id"];
//                         [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
//                             if (error) {
//                                 // Handle error
//                             }else {
//                                 model.uID = fb_user_id;
//                                 model.name = [FBuser name];
//                                 model.userProfileImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", fb_user_id];
//                                 model.email = [user valueForKey:@"email"];
//                                 model.gender = [user valueForKey:@"gender"];
//                                 model.dob = [user valueForKey:@"birthday"];
//                                 model.userName = [user valueForKey:@"last_name"];
//                                 model.userFullName = [[NSString alloc]initWithFormat:@"%@%@",[user valueForKey:@"first_name"],[user valueForKey:@"last_name"]];
//                             
//                              //   NSLog(@"session is %@",session);
//                                 
//                                 model.fbToken = [FBSession activeSession].accessTokenData.accessToken;
//                                 [ConnectionManager dataManager].facebookLoginModel = model;
//                                 [self requestServerForFacebookLogin];
//                             }
//                         }];
//                         
//                     }
//                 }];
//                 break;
//             }
//             case FBSessionStateClosed:
//             case FBSessionStateClosedLoginFailed:
//                 [FBSession.activeSession closeAndClearTokenInformation];
//                 SLog(@"Facebook Login Failed");
//                 break;
//                 
//             default:
//                 break;
//         }
//         
//         // Retrieve the app delegate
//      //   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
//       //  [appDelegate sessionStateChanged:session state:state error:error];
//         
//     }];
//    //    }
    
}
#pragma mark - Declaration

-(SelectCategoryViewController*)selectCategoryViewController
{
    if (!_selectCategoryViewController) {
        _selectCategoryViewController = [SelectCategoryViewController new];
    }
    return _selectCategoryViewController;
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
        _signUpViewController.signUpClickBlock = ^(NSString* username, NSString* password,NSString* email, NSString *referralCode)
        {
            [weakSelf requestServerForRegisterWithUserName:username Password:password Email:email ReferralCode:referralCode];
            
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
            
            [weakSelf requestServerForLogin:username Password:password OnComplete:^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];

                if (weakSelf.didFinishLoginBlock) {
                    weakSelf.didFinishLoginBlock();
                }
            }];

        };

    }
    
    return _loginPageViewController;
}

#pragma mark - Server Request
-(void)requestServerForLogin:(NSString*)userName Password:(NSString*)password OnComplete:(VoidBlock)onComplete
{
 
    if (isMiddleOfLogin) {
        return;
    }
    [LoadingManager show];
    
    NSDictionary* dict = @{@"login_id" : userName,
                           @"password" : password,
                           @"device_type" : @"2"};
    
    isMiddleOfLogin = YES;
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypeLogin parameter:dict appendString:nil success:^(id object) {
        
        isMiddleOfLogin = NO;

        if (onComplete) {
            onComplete();
        }
        
        
    } failure:^(id object) {
        
        isMiddleOfLogin = NO;

    }];

    
}

-(void)requestServerForFacebookLogin{

    if (isMiddleOfFacebookLogin) {
        return;
    }
    
    [LoadingManager show];
    
    
    FacebookModel* model = [[ConnectionManager dataManager]facebookLoginModel];
  
    NSDictionary* dict = @{@"fb_id" : model.uID,
                           @"fb_token" : model.fbToken,
                           @"role" : @"user",
                           @"device_type" : @(DEVICE_TYPE)};
    
    
    isMiddleOfFacebookLogin = YES;
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypeLoginFacebook parameter:dict appendString:nil success:^(id object) {
        
        isMiddleOfFacebookLogin = NO;


        if (self.didFinishLoginBlock) {
            self.didFinishLoginBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];

    } failure:^(id object) {
        isMiddleOfFacebookLogin = NO;
    }];
    
}


-(void)requestServerForRegisterWithUserName:(NSString*)username Password:(NSString*)password Email:(NSString*)email ReferralCode:(NSString*)referralCode
{

    if (isMiddleOfRegistering) {
        return;
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"email" : email,
                                                                                  @"username" : username,
                                                                                  @"password" : password,
                                                                                  @"role" : @"user",
                                                                                  @"device_type" : @(DEVICE_TYPE),
                                                                                  }];
    
    if (![Utils isStringNull:referralCode]) {
        [dict setObject:referralCode forKey:@"referral_code"];
    }

    isMiddleOfRegistering = YES;
    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypeRegister parameter:dict appendString:nil success:^(id object) {
        
        isMiddleOfRegistering = NO;
        [LoadingManager hide];
        
        NSDictionary* dict = [[NSDictionary alloc]initWithDictionary:object];
        if ([dict[@"status"] isEqualToString:@"ok"]) {
            [self requestServerForLogin:username Password:password OnComplete:^{
                
                [self showSelectCategoryView];
            }];
        }
        else{
        
            SLog(@"error : %@",dict[@"message"]);
//            [TSMessage showNotificationInViewController:self.navigationController title:LocalisedString(@"system") subtitle:dict[@"message"] type:TSMessageNotificationTyperror];
            [MessageManager showMessage:dict[@"message"] Type:STAlertError];
         //   [MessageManager showMessage:LocalisedString(@"system") SubTitle:dict[@"message"] Type:TSMessageNotificationTypeError];
            
        }
        
    } failure:^(id object) {
        
        isMiddleOfRegistering = NO;
        [LoadingManager hide];

    }];
    
}

-(void)requestServerForInstagramLogin
{
    
    
    if (isMiddleOfInstaLogin) {
        return;
    }
    InstagramUser* model = [[ConnectionManager dataManager]instagramUserModel];

    NSDictionary* dict = @{@"insta_id" : model.Id,
                           @"insta_token" : [[InstagramEngine sharedEngine]accessToken]?[[InstagramEngine sharedEngine] accessToken]:@"",
                           @"device_type" : @(DEVICE_TYPE),
                           };
    
    isMiddleOfInstaLogin = YES;
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypeLoginInstagram parameter:dict appendString:nil success:^(id object) {
        
        isMiddleOfInstaLogin = NO;
        
        if (self.didFinishLoginBlock) {
            self.didFinishLoginBlock();
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(id object) {
        
        isMiddleOfInstaLogin = NO;

    }];
}

-(void)showSelectCategoryView
{
    _selectCategoryViewController = nil;
    self.selectCategoryViewController.didFinishProvisioningBlock = self.didFinishSignupBlock;
    [self.navigationController pushViewController:self.selectCategoryViewController animated:YES];
    
}

-(void)forgetPassword
{

}


-(void)changeLanguage
{
    //self.lblTitle.text = LocalisedString(@"City Deal & Places");
    
    [self.lblFacebook setTitle:LocalisedString(@"Facebook") forState:UIControlStateNormal];
    [self.lblInstagram setTitle:LocalisedString(@"Instagram") forState:UIControlStateNormal];
    
    [self.btnLogin setTitle:LocalisedString(@"Log in") forState:UIControlStateNormal];
    [self.btnContinue setTitle:LocalisedString(@"Continue as guest") forState:UIControlStateNormal];
    [self.btnSignup setTitle:LocalisedString(@"Sign up") forState:UIControlStateNormal];

    self.lblContinueWith.text = LocalisedString(@"Continue with");

}

@end
