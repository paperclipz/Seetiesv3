//
//  CT3_AcctSettingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_AcctSettingViewController.h"
#import "AccountSettingTableViewCell.h"
#import "DealHeaderView.h"
#import "ActionSheetPicker.h"
#import "CTWebViewController.h"
#import "ChangePasswordViewController.h"
#import "FBLoginManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface CT3_AcctSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic)CTWebViewController* webViewController;
@property (nonatomic)ChangePasswordViewController* changePasswordViewController;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (nonatomic)NSArray* arrLanguage;
@property (nonatomic)NSArray* arrAccount;
@property (nonatomic)NSArray* arrOthers;
@property (nonatomic)NSArray* arrDisplayLanguages;

@property (nonatomic,assign)BOOL isConnectedFacebook;
@property (nonatomic,assign)BOOL isConnectedInstagram;



@property (nonatomic)InstagramUser* instaUser;
@property (nonatomic)ProfileModel* profileModel;

@property(nonatomic)BOOL isLoadingFacebookDetails;
@property(nonatomic)BOOL isLoadingInstaDetails;

@end

@implementation CT3_AcctSettingViewController
- (IBAction)btnUpdateInfoClicked:(id)sender {
    
  //  [self requestServerToUpdateUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];

}

-(void)initSelfView
{
    
    [self changeLanguage];
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    self.profileModel = [[ConnectionManager dataManager]getCurrentUserProfileModel];
    
    if ([Utils isStringNull:self.profileModel.fb_id]) {
        
        self.isConnectedFacebook = NO;
    }
    else{
        self.isConnectedFacebook = YES;
        
    }
    
    
    if ([Utils isStringNull:self.profileModel.insta_id]) {
        
        self.isConnectedInstagram = NO;
    }
    else{
        self.isConnectedInstagram = YES;
        
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ibTableView.frame.size.width, 44)];
    header.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, header.frame.size.width, 21)];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    label.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    
    NSString* title;
    
    switch (section) {
        case 0:
            
            title = LocalisedString(@"Language");
            break;
        case 1:
            title = LocalisedString(@"Account");

            break;
        case 2:
            title = LocalisedString(@"Others");

            break;
            
        default:
            break;
    }
    
    label.text = title;
    [header addSubview:label];
    return header;
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        default:

        case 0:
            
            return self.arrLanguage.count;
            break;
            
        case 1:
            return self.arrAccount.count;

            break;
            
        case 2:
            return self.arrOthers.count;

            break;
    }
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AccountSettingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AccountSettingTableViewCell"];
    
    
    switch (indexPath.section) {
        default:

        case 0:
        {
            
            @try {
                
                if (!cell) {
                    cell = [[AccountSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingTableViewCell" withType:1001];
                }
                
                NSString* desc = self.arrLanguage[indexPath.row];
                
                cell.lblTitle.text = LocalisedString(desc);
                
                
                cell.lblDesc.text = [Utils getLanguageName:[LanguageManager getDeviceAppLanguageCode]];
            }
            @catch (NSException *exception) {
                
            }
           
           
        }
           
            break;
        case 1:
        {
            
            @try {
                
              
                
               
                if (indexPath.row == 0) {// email address
                    
                    
                    if (!cell) {
                        cell = [[AccountSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingTableViewCell" withType:2001];
                    }

                   
                    cell.lblDesc.text = @"";

                    ProfileModel*pModel = [[ConnectionManager dataManager] getCurrentUserProfileModel];
                    cell.lblDesc.text = pModel.email;
                }
                else if(indexPath.row == 1)//change password
                {
                    
                    if (!cell) {
                        cell = [[AccountSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingTableViewCell" withType:4001];
                    }
                }
                
                else if(indexPath.row == 2)//connect facebook
                {
                    
                    if (!cell) {
                        cell = [[AccountSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingTableViewCell" withType:3001];
                    }
                    cell.ibSwitch.on = self.isConnectedFacebook;

                    
                    cell.didChangeSettingBlock = ^(BOOL flag)
                    {
                        self.isConnectedFacebook = flag;
                        
                        if (flag) {
                            [self requestServerForFacebookInfo];
                        }
                        else{
                            [self requestServerToUpdateUserInfoFacebook:@"" facebookToken:@""];

                        }
                    };
                }
                
                else if(indexPath.row == 3)//connect instagram
                {
                    if (!cell) {
                        cell = [[AccountSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingTableViewCell" withType:3001];
                    }
                    cell.ibSwitch.on = self.isConnectedInstagram;
                    
                    cell.didChangeSettingBlock = ^(BOOL flag)
                    {
                       // self.isConnectedInstagram = flag;
                        
                        if (flag) {
                            [self requestServerToGetInstagramInfo];
                        }
                        else
                        {
                            [self requestServerToUpdateUserInfoInstagram:@"" Token:@""];
                        }
                    };

                }
                else if(indexPath.row == 4)//notifications settings
                {
                    
                    if (!cell) {
                        cell = [[AccountSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingTableViewCell" withType:4001];
                    }


                }

                NSString* desc = self.arrAccount[indexPath.row];
                
                cell.lblTitle.text = LocalisedString(desc);

            }
            @catch (NSException *exception) {
                
            }
            
        }

            break;
            
        case 2:
        {
            @try {
                
                if (!cell) {
                    cell = [[AccountSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingTableViewCell" withType:4001];
                }
                NSString* desc = self.arrOthers[indexPath.row];
                
                cell.lblTitle.text = LocalisedString(desc);
                

            }
            @catch (NSException *exception) {
                
            }

          
        }

            break;

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.section) {
       default:
        case 0:
            
            [self showPickerView];

            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self showChangeEmail];
                    break;
                    
                case 1:
                    [self showChangePasswordView];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2:
            
            break;
            
    }
}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    [tableView sizeToFit];
//}

#pragma mark - Declaration

-(ChangePasswordViewController*)changePasswordViewController
{
    if (!_changePasswordViewController) {
        _changePasswordViewController = [ChangePasswordViewController new];
    }
    
    return _changePasswordViewController;
}

-(CTWebViewController*)webViewController
{
    
    if(!_webViewController)
    {
        _webViewController = [CTWebViewController new];
        
    }
    
    return _webViewController;
}

-(NSArray*)arrLanguage
{
    if (!_arrLanguage) {
        _arrLanguage = @[@"Language"];
    }
    
    return _arrLanguage;
}

-(NSArray*)arrAccount
{
    if (!_arrAccount) {
        _arrAccount = @[@"Email Address",@"Change Password",@"Connect to Facebook",@"Connect to Instagram"];
    }
    
    return _arrAccount;
}

-(NSArray*)arrOthers
{
    if (!_arrOthers) {
        _arrOthers = @[@"Delete Account"];
    }
    
    return _arrOthers;
}


-(NSArray*)arrDisplayLanguages
{
    if (!_arrDisplayLanguages) {
        
        
        NSMutableArray* array = [NSMutableArray new];
        LanguageModels* models = [[ConnectionManager dataManager]languageModels];
        
        for (int i = 0; i<models.languages.count; i++) {
            
            LanguageModel* language = models.languages[i];
            
            [array addObject:language.caption];
        }
        _arrDisplayLanguages = array;
    }
    
    return _arrDisplayLanguages;
}


-(void)showChangePasswordView
{
    _changePasswordViewController = nil;
    [self.navigationController pushViewController:self.changePasswordViewController animated:YES];
}

-(void)showPickerView
{
    
    [ActionSheetStringPicker showPickerWithTitle:LocalisedString(@"Select Language")
                                            rows:self.arrDisplayLanguages
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@", picker);
                                           NSLog(@"Selected Index: %ld", (long)selectedIndex);
                                           NSLog(@"Selected Value: %@", selectedValue);
                                           
                                           @try {
                                               LanguageModels* models = [[ConnectionManager dataManager]languageModels];
                                               
                                               LanguageModel* lModel = models.languages[selectedIndex];
                                               
                                               [LanguageManager setDeviceAppLanguage:lModel.language_code];
                                               
                                               [self.ibTableView reloadData];
                                               
                                               [self requestServerToUpdateUserInfoLanguage];
                                               
                                               [self changeLanguage];


                                           }
                                           @catch (NSException *exception) {
                                               SLog(@"Assign Langauge Fail");
                                           }
                                         
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:self.view];
}

-(void)showChangeEmail{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalisedString(@"Email Address") message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *currentEmail = [[DataManager Instance] currentUserProfileModel].email;
        textField.text = currentEmail;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalisedString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:LocalisedString(@"Ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newEmail = alert.textFields[0].text;
        if ([self validateEmail:newEmail]) {
            [self requestServerToChangeEmail:newEmail];
        }
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:doneAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(BOOL)validateEmail:(NSString *)email
{
    if ([Utils isStringNull:email]) {
//        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Email cannot be empty.") Type:TSMessageNotificationTypeError];
        [MessageManager showMessage:LocalisedString(@"Email cannot be empty.") Type:STAlertError];
        return NO;
    }
    
    NSString *emailRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL validEmail = [emailTest evaluateWithObject:email];

    if (!validEmail) {
//        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Please enter correct email id") Type:TSMessageNotificationTypeError];
        [MessageManager showMessage:LocalisedString(@"Please enter correct email id") Type:STAlertError];
    }
    
    return validEmail;
}

#pragma mark - Request Server
-(void)requestServerToUpdateUserInfoFacebook:(NSString*)fbID facebookToken:(NSString*)fbToken
{
    
    NSDictionary* dict;
    @try {
        
//        dict = @{@"uid" : [Utils getUserID],
//                 @"system_language" : [Utils getDeviceAppLanguageCode],
//                 @"token":[Utils getAppToken],
//                 
//                 @"insta_id" : self.instaUser.Id,
//                 @"insta_token" : [[InstagramEngine sharedEngine]accessToken]?[[InstagramEngine sharedEngine]accessToken]:@"",
//                 };

        dict = @{@"uid" : [Utils getUserID],
                 @"token":[Utils getAppToken],
                 @"fb_id" : fbID?fbID:@"",
                 @"fb_token" : fbToken?fbToken:@""
                 };

    }
    @catch (NSException *exception) {
        SLog(@"fail to get dictionary");
    }
    
    NSString* appendString = [NSString stringWithFormat:@"%@",[Utils getUserID]];
    
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUpdateUser parameter:dict appendString:appendString success:^(id object) {
        
        self.profileModel = [[ConnectionManager dataManager]getCurrentUserProfileModel];

    } failure:^(id object) {
        
        self.isConnectedFacebook = NO;
        [self.ibTableView reloadData];

    }];
    
}

-(void)requestServerToUpdateUserInfoInstagram:(NSString*)ID Token:(NSString*)Token
{
    
    NSDictionary* dict;
    @try {

        
        dict = @{@"uid" : [Utils getUserID],
                 @"token":[Utils getAppToken],
                 @"insta_id" : ID?ID:@"",
                 @"insta_token" : Token?Token:@"",
                 };
        
    }
    @catch (NSException *exception) {
        SLog(@"fail to get dictionary");
    }
    
    NSString* appendString = [NSString stringWithFormat:@"%@",[Utils getUserID]];
    
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUpdateUser parameter:dict appendString:appendString success:^(id object) {

        
        self.profileModel = [[ConnectionManager dataManager]getCurrentUserProfileModel];
        
       
    } failure:^(id object) {
        self.isConnectedInstagram = NO;
        [self.ibTableView reloadData];

    }];
    
}

-(void)requestServerToUpdateUserInfoLanguage
{
    
    NSDictionary* dict;
    @try {
        
        
        dict = @{@"uid" : [Utils getUserID],
                 @"token":[Utils getAppToken],
                 @"system_language" : [LanguageManager getDeviceAppLanguageCode],
                 };
        
    }
    @catch (NSException *exception) {
        SLog(@"fail to get dictionary");
    }
    
    NSString* appendString = [NSString stringWithFormat:@"%@",[Utils getUserID]];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUpdateUser parameter:dict appendString:appendString success:^(id object) {
        
        [self.ibTableView reloadData];
        
        [Utils reloadAppView:NO];
        [Utils reloadTabbar];
        
    } failure:^(id object) {
        
    }];
    
}

-(IBAction)requestServerForFacebookInfo{
    
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
//                     }
//                     else
//                     {                         
//                         NSLog(@"Facebook Return Result : %@",user);
//                         
//                         NSString* fb_user_id = (NSString *)[user valueForKey:@"id"];
//                         
//                         NSString* fb_token =[FBSession activeSession].accessTokenData.accessToken;
//                         
//                         if (![Utils isStringNull:fb_user_id]) {
//                             [self requestServerToUpdateUserInfoFacebook:fb_user_id facebookToken:fb_token];
//                         }
//                     }
//                 }];
//                 break;
//             }
//             case FBSessionStateClosed:
//                 [FBSession.activeSession closeAndClearTokenInformation];
//                 
//                 break;
//             case FBSessionStateClosedLoginFailed:
//                 
//                 [MessageManager showMessage:LocalisedString(@"sysem") SubTitle:LocalisedString(@"Cant Retrieve Data From Facebook") Type:TSMessageNotificationTypeError];
//                 break;
//                 
//             default:
//                 break;
//         }
//         
//         
//     }];
    
    __weak typeof (self)weakSelf = self;
    
    [FBLoginManager performFacebookLogin:self completionBlock:^(FBSDKLoginManagerLoginResult *result) {
        
        if (result.isCancelled) {
            weakSelf.isConnectedFacebook = NO;
            [weakSelf.ibTableView reloadData];
        }
        else {
            
            [FBLoginManager performFacebookGraphRequest:^(FacebookModel *model) {
                
                if (![Utils isStringNull:model.uID]) {
                    [weakSelf requestServerToUpdateUserInfoFacebook:model.uID facebookToken:model.fbToken];
                }
            }];
        }
    }];
}

-(void)requestServerToGetInstagramInfo
{
    
    
    _webViewController = nil;
    
    __weak typeof (self)weakSelf = self;
    self.webViewController.didFinishLoadConnectionBlock = ^(void)
    {
        
        weakSelf.instaUser = [[ConnectionManager dataManager]instagramUserModel];
        NSString* token = [[InstagramEngine sharedEngine] accessToken];
        [weakSelf requestServerToUpdateUserInfoInstagram:weakSelf.instaUser.Id Token:token];
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    };
    
    [self.navigationController pushViewController:self.webViewController animated:YES onCompletion:^{
        [self.webViewController initDataForInstagram];
        
        
    }];
}

-(void)requestServerToChangeEmail:(NSString*)email{
    NSString *userId = [Utils getUserID];
    NSDictionary *dict = @{@"uid": userId,
                           @"token": [Utils getAppToken],
                           @"email": email? email : @""};
    
    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUpdateUser parameter:dict appendString:userId success:^(id object) {
        [LoadingManager hide];
        [self.ibTableView reloadData];
    } failure:^(id object) {
        [LoadingManager hide];
    }];
    
}

-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Account Settings");
}
@end
