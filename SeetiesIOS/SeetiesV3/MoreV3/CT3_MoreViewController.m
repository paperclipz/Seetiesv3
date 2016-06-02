//
//  CT3_MoreViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 15/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_MoreViewController.h"
#import "SettingsTableViewCell.h"
#import "CT3_FeedbackViewController.h"
#import "CTWebViewController.h"
#import "CT3_AcctSettingViewController.h"
#import "IntroCoverView.h"
#import "AppDelegate.h"
//#import "DraftAndRecommendationDelegate.h"
//#import "DoImagePickerController.h"
//#import "RecommendationViewController.h"

@interface CT3_MoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSArray* arrData;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;


//@property (nonatomic,strong)RecommendationViewController* recommendationViewController;
//@property (nonatomic,strong)DoImagePickerController* imagePickerViewController;
//@property(nonatomic)DraftAndRecommendationDelegate* recommendDelegate;
@property(nonatomic)CT3_FeedbackViewController* feedbackViewController;
@property(nonatomic)CTWebViewController* ctWebViewController;
@property(nonatomic)CT3_AcctSettingViewController* ct3_AcctSettingViewController;
@property(nonatomic)IntroCoverView* introView;

@end

@implementation CT3_MoreViewController
- (IBAction)btnTestClicked:(id)sender {
    
    _ct3_AcctSettingViewController = nil;
    [self.navigationController pushViewController:self.ct3_AcctSettingViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self changeLanguage];
    [self.ibTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSelfView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView{
    
    
    @try {
        NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
        

        if ([Utils isAppProductionBuild]) {
            self.lblVersion.text = [NSString stringWithFormat:@"app Version : %@ app Build : %@",version,build];

        }
        else{
            self.lblVersion.text = [NSString stringWithFormat:@"app Version : %@ app Build : %@ DEV",version,build];

        }

    }
    @catch (NSException *exception) {
        SLog(@"Unable to retreive app version and build");
    }
   
       self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[SettingsTableViewCell class] forCellReuseIdentifier:@"SettingsTableViewCell"];
    
    //self.recommendDelegate = [DraftAndRecommendationDelegate new];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray* tempArray = self.arrData[section];
    return tempArray.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ibTableView.frame.size.width, 44)];
    header.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, header.frame.size.width, 21)];
    [title setFont:[UIFont boldSystemFontOfSize:13]];
    title.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    
    if(section == 0)
    {
        if ([Utils isGuestMode]) {
            title.text = LocalisedString(@"Get Started");
        }
        else
        {
            title.text = LocalisedString(@"");
        }
    }
    if(section == 1)
        title.text = LocalisedString(@"Others");
    if(section == 2)
        title.text = LocalisedString(@"Sign Out");
    
    [header addSubview:title];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if ([Utils isGuestMode]) {
        return 44;

    }
    else{
        if (section == 0) {
            return 0;
        }
        else{
            return 44;

        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsTableViewCell"];
    NSArray* temArray= self.arrData[indexPath.section];
    
    
    NSString* text = temArray[indexPath.row];
    
    if ([text isEqualToString:@"Verify your phone number"]) {
        
        if ([Utils isPhoneNumberVerified]) {
            
            ProfileModel *profileModel = [[DataManager Instance] getCurrentUserProfileModel];
            cell.lblTitle.text = [LanguageManager stringForKey:@"Phone Number = {!phone number}" withPlaceHolder:@{@"{!phone number}": profileModel.contact_no?profileModel.contact_no:@""}];
            
            @try {
                cell.ibImageView.image = [self getIconImage:@"Verified"];

            }
            @catch (NSException *exception) {
                
            }
          
        }
        else {
            
            cell.lblTitle.text = LocalisedString(text);
            
            @try {
                cell.ibImageView.image = [self getIconImage:text];
                
            }
            @catch (NSException *exception) {
                
            }

        }
    
    }
    else{
        cell.lblTitle.text = LocalisedString(text);

        @try {
            cell.ibImageView.image = [self getIconImage:text];

        }
        @catch (NSException *exception) {
            
        }
       
    };
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case 0://shortcut
            
            if ([Utils isGuestMode]) {
                
                [Utils showLogin];
            }
//            else
//            {
//                switch (indexPath.row) {
//                
//                    case 0://recommend
//                        [self gotoRecommendationPage];
//                        break;
//                    case 1://draft
//                        [self gotoDraftPage];
//                        break;
//                        
//                    default:
//                        break;
//                }
//
//            }
            
            
            break;
            
        case 1://others
        {
            NSArray* temArray= self.arrData[indexPath.section];
            NSString* text = temArray[indexPath.row];
            
            SWITCH(text){
            
                CASE (@"Verify your phone number"){
                    
                    
                    if ([Utils isPhoneNumberVerified]) {
                        
                        [Utils showChangeVerifiedPhoneNumber:self];

                    }
                    else{
                        [Utils showVerifyPhoneNumber:self];

                    }
                   
                    break;
                }

                
                CASE (@"Rate Us"){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/my/app/seeties-explore-best-places/id956400552?mt=8"]];
                    break;
                }
                
                CASE (@"About Us")
                {
                    _ctWebViewController = nil;
                    [self.navigationController pushViewController:self.ctWebViewController animated:YES onCompletion:^{
                        
                        [self.ctWebViewController initDataWithURL:URL_ABOUT_US andTitle:text];
                    }];
                    
                    break;
                    
                    
                }
                CASE (@"Speak to Us")
                {
                    if ([self.feedbackViewController toResetPage]) {
                        self.feedbackViewController = nil;
                    }
                    
                    [self.navigationController pushViewController:self.feedbackViewController animated:YES];
                    break;
                    
                    
                }
                CASE (@"Account Settings")
                {
                    _ct3_AcctSettingViewController = nil;
                    [self.navigationController pushViewController:self.ct3_AcctSettingViewController animated:YES];
                    break;
                    
                }
                CASE (@"Tour Seeties App")
                {
                   
                    [self showIntroView];
                    break;
                    
                }

                
                DEFAULT
                {

                    break;

                    
                }
            }
        }
            
            break;
            
        case 2://logout
            
            switch (indexPath.row) {
                case 0:
                default:
                    
                //logout
                    
                    [self logout];
                    break;
            }
            
            break;
            
        default:
            break;
    }
    
    NSLog(@"indexPath.section IS %ld",(long)indexPath.section);
    [self.ibTableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - Declaration

-(CT3_AcctSettingViewController*)ct3_AcctSettingViewController
{
    if (!_ct3_AcctSettingViewController) {
        _ct3_AcctSettingViewController = [CT3_AcctSettingViewController new];
    }
    return _ct3_AcctSettingViewController;
}

-(CTWebViewController*)ctWebViewController
{
    if (!_ctWebViewController) {
        _ctWebViewController = [CTWebViewController new];
    }
    return _ctWebViewController;
}

-(CT3_FeedbackViewController*)feedbackViewController
{
    if (!_feedbackViewController) {
        _feedbackViewController = [CT3_FeedbackViewController new];
    }
    
    return _feedbackViewController;
}

-(NSArray*)arrData
{
    if (!_arrData) {
        
        if (![Utils isGuestMode]) {
           // NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Write a Recommendation",@"Drafts", nil];//@"Notification Settings"
            NSArray *firstItemsArray = [[NSArray alloc] initWithObjects: nil];//@"Notification Settings"

            NSArray *secondItemsArray;
            if ([ [ UIScreen mainScreen ] bounds ].size.height > 480) {
                secondItemsArray = [[NSArray alloc] initWithObjects:@"Verify your phone number",@"Account Settings",@"Tour Seeties App", @"Rate Us",@"About Us",@"Speak to Us", nil];

            }
            else{
                secondItemsArray = [[NSArray alloc] initWithObjects:@"Verify your phone number",@"Account Settings", @"Rate Us",@"About Us",@"Speak to Us", nil];

            }
           
            NSArray *threeItemsArray = [[NSArray alloc] initWithObjects:@"Sign Out", nil];
            _arrData = @[firstItemsArray,secondItemsArray,threeItemsArray];

        }
        else
        {
            NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Sign up or Log in", nil];//@"Notification Settings"
            
            NSArray *secondItemsArray;
            if ([ [ UIScreen mainScreen ] bounds ].size.height > 480) {
                
                secondItemsArray = [[NSArray alloc] initWithObjects:@"Tour Seeties App",@"Rate Us",@"About Us",@"Speak to Us", nil];
                
            }
            else{
                secondItemsArray = [[NSArray alloc] initWithObjects:@"Rate Us",@"About Us",@"Speak to Us", nil];
                
            }

            
            //NSArray *threeItemsArray = [[NSArray alloc] initWithObjects:@"Sign out", nil];
            _arrData = @[firstItemsArray,secondItemsArray];
        }
    }
    return _arrData;
}

//-(RecommendationViewController*)recommendationViewController
//{
//    if (!_recommendationViewController) {
//        _recommendationViewController = [RecommendationViewController new];
//    }
//    
//    return _recommendationViewController;
//}

-(void)gotoDraftPage
{
   // [self.recommendDelegate showDraftView:self];
    // go to draft
}

-(void)gotoRecommendationPage
{
    
//    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:self.recommendationViewController];
//    [self presentViewController:nav animated:YES completion:nil];
//    [self.recommendationViewController initData:2 sender:nav];
    
   // [self.recommendDelegate showRecommendationView:self];

}

-(void)logout
{
    
    [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Are you sure you want to sign out of Seeties?") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"Maybe not..") otherButtonTitles:@[LocalisedString(@"Yeah!!")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 0) {
            
        }
        else{
            [self serverRequestLogout];

        }
    }];
    
   
    
}

#pragma mark - Server Request

-(void)serverRequestLogout
{
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           };
    
    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetLogout parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];

        [Utils setLogout];
//        _arrData = nil;
//        [self.ibTableView reloadData];
        
    } failure:^(id object) {
        [LoadingManager hide];

    }];
}

-(void)reloadData
{
    //SLog(@"ggwp");
    _arrData = nil;
    [self.ibTableView reloadData];

}
-(UIImage*)getIconImage:(NSString*)str
{
    UIImage* image;
    NSString* imageName;
    
    SWITCH(str)
    {
        
        CASE(@"Suggest a Place")
        {
            imageName = @"MoreSuggestAPlaceIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }
       
        CASE(@"Write a Recommendation")
        {
            imageName = @"MoreWriteARecommendationIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }
        CASE(@"Drafts")
        {
            imageName = @"MoreDraftsIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }
       
        CASE(@"Verify your phone number")
        {
            imageName = @"MoreVerifyPhoneNumberIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
            
        }
        
        CASE(@"Account Settings")
        {
            imageName = @"MoreAccountSettingsIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }
        
        CASE(@"Rate Us")
        {
            imageName = @"MoreRateUsIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }
       
        CASE(@"About Us")
        {
            imageName = @"MoreAboutIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }
        
        CASE(@"Speak to Us")
        {
            imageName = @"MoreFeedbackIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
            
        }
           CASE(@"Sign up or Log in")
        {
            imageName = @"MoreSignUpOrLogInIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }
       
        CASE(@"Verified")
        {
            imageName = @"MoreVerifiedPhoneNumberIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }
        CASE(@"Sign Out")
        {
            imageName = @"MoreLogoutIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }
        CASE(@"Tour Seeties App")
        {
            imageName = @"MoreTourGuideIcon";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }

        DEFAULT
        {
            imageName = @"NoImage";
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
            return image;
            break;
        }
    }
   
}
-(void)showIntroView
{
    
    
    AppDelegate *appdelegate;
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appdelegate.landingViewController showIntroView];
    
    
}

-(void)changeLanguage
{
    SLog(@"%@",LocalisedString(@"More"));

    self.lblTitle.text = LocalisedString(@"More");
    [self.ibTableView reloadData];
}
@end
