//
//  CT3_LoginViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_LoginViewController.h"

@interface CT3_LoginViewController ()

@end

@implementation CT3_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Server Request
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


@end
