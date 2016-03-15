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

@interface CT3_AcctSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic)CTWebViewController* webViewController;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (nonatomic)NSArray* arrLanguage;
@property (nonatomic)NSArray* arrAccount;
@property (nonatomic)NSArray* arrOthers;
@property (nonatomic)NSArray* arrDisplayLanguages;


@property (strong,nonatomic)UIPickerView* ibPickerView;
@property (nonatomic,assign)BOOL isConnectedFacebook;
@property (nonatomic,assign)BOOL isConnectedInstagram;


@property (nonatomic)NSString* fb_id;
@property (nonatomic)NSString* insta_id;

@property(nonatomic)BOOL isLoadingFacebookDetails;
@property(nonatomic)BOOL isLoadingInstaDetails;

@end

@implementation CT3_AcctSettingViewController
- (IBAction)btnUpdateInfoClicked:(id)sender {
    
    [self requestServerToUpdateUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];

}

-(void)initSelfView
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    [self.view addSubview:self.ibPickerView];
    
    
    ProfileModel* pModel = [[ConnectionManager dataManager]userProfileModel];
    
    if ([Utils isStringNull:pModel.fb_id]) {
        
        self.isConnectedFacebook = NO;
    }
    else{
        self.isConnectedFacebook = YES;
        
    }
    
    
    if ([Utils isStringNull:pModel.insta_id]) {
        
        self.isConnectedInstagram = NO;
    }
    else{
        self.isConnectedInstagram = YES;
        
    }


  //  self.ibPickerView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DealHeaderView* view = [DealHeaderView initializeCustomView];
    view.backgroundColor = LINE_COLOR;
    view.btnSeeMore.hidden = YES;
    
    NSString* title;
    
    switch (section) {
        case 0:
            
            title = @"Language";
            break;
        case 1:
            title = @"Account";

            break;
        case 2:
            title = @"Others";

            break;
            
        default:
            break;
    }
    
    [view.btnDeals setTitle:LocalisedString(title) forState:UIControlStateNormal];
    
    return view;
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
                
                
                cell.lblDesc.text = [Utils getLanguageName:[Utils getDeviceAppLanguageCode]];
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

                    ProfileModel*pModel = [[ConnectionManager dataManager] userProfileModel];
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
                        self.isConnectedInstagram = flag;
                        
                        if (flag) {
                            [self requestServerToGetInstagramInfo];
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
            
            break;
        case 2:
            
            break;
            
    }
}


#pragma mark - Declaration

-(CTWebViewController*)webViewController
{
    
    if(!_webViewController)
    {
        _webViewController = [CTWebViewController new];
        
    }
    
    return _webViewController;
}

-(UIPickerView*)ibPickerView
{
    if (!_ibPickerView) {
        
        CGRect frame = [Utils getDeviceScreenSize];
        
        float viewHeight = 200;
        _ibPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, frame.size.height - viewHeight, self.view.frame.size.width, viewHeight)];
    }
    
    return _ibPickerView;
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
                                               
                                               [Utils setDeviceAppLanguage:lModel.caption];
                                               
                                               [self.ibTableView reloadData];

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


#pragma mark - Request Server
-(void)requestServerToUpdateUserInfo
{
    
    NSDictionary* dict;
    @try {
        
        dict = @{@"uid" : [Utils getUserID],
                 @"system_language" : [Utils getDeviceAppLanguageCode],
                 @"token":[Utils getAppToken],
                 };
    }
    @catch (NSException *exception) {
        SLog(@"fail to get dictionary");
    }
    
    NSString* appendString = [NSString stringWithFormat:@"%@/provisioning",[Utils getUserID]];
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostProvisioning param:dict appendString:appendString completeHandler:^(id object) {
        
        
    } errorBlock:^(id object) {
        
    }];
    
}

-(IBAction)requestServerForFacebookInfo{
    
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
                         NSLog(@"Facebook Return Result : %@",user);
                         
                         NSString* fb_user_id = (NSString *)[user valueForKey:@"id"];
                         
                         self.fb_id = fb_user_id;

                     }
                 }];
                 break;
             }
             case FBSessionStateClosed:
                 [FBSession.activeSession closeAndClearTokenInformation];
                 
                 break;
             case FBSessionStateClosedLoginFailed:
                 
                 [MessageManager showMessage:LocalisedString(@"sysem") SubTitle:LocalisedString(@"Cant Retrieve Data From Facebook") Type:TSMessageNotificationTypeError];
                 break;
                 
             default:
                 break;
         }
         
         
     }];
    
}

-(void)requestServerToGetInstagramInfo
{
    
    _webViewController = nil;
    
    __weak typeof (self)weakSelf = self;
    self.webViewController.didFinishLoadConnectionBlock = ^(void)
    {
        InstagramModel* model;
        model = [ConnectionManager dataManager].instagramModel;

        weakSelf.insta_id = model.userID;
        
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    };
    
    
    [self.navigationController pushViewController:self.webViewController animated:YES onCompletion:^{
        [self.webViewController initDataForInstagram];
        
        
    }];
}

@end
