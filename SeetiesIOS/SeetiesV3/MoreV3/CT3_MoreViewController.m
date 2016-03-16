//
//  CT3_MoreViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 15/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_MoreViewController.h"
#import "SettingsTableViewCell.h"
#import "RecommendationViewController.h"
#import "DoImagePickerController.h"
#import "DraftAndRecommendationDelegate.h"
#import "FeedbackViewController.h"
#import "AccountSettingViewController.h"
#import "CTWebViewController.h"
#import "CT3_AcctSettingViewController.h"

@interface CT3_MoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (nonatomic,strong)RecommendationViewController* recommendationViewController;
@property (nonatomic,strong)DoImagePickerController* imagePickerViewController;
@property (nonatomic,strong)NSArray* arrData;
@property(nonatomic)DraftAndRecommendationDelegate* recommendDelegate;
@property(nonatomic)FeedbackViewController* feedbackViewController;
@property(nonatomic)AccountSettingViewController* accountSettingViewController;
@property(nonatomic)CTWebViewController* ctWebViewController;
@property(nonatomic)CT3_AcctSettingViewController* ct3_AcctSettingViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation CT3_MoreViewController
- (IBAction)btnTestClicked:(id)sender {
    
    _ct3_AcctSettingViewController = nil;
    [self.navigationController pushViewController:self.ct3_AcctSettingViewController animated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
    [self changeLanguage];
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
    
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[SettingsTableViewCell class] forCellReuseIdentifier:@"SettingsTableViewCell"];
    
    self.recommendDelegate = [DraftAndRecommendationDelegate new];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray* tempArray = self.arrData[section];
    return tempArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return LocalisedString(@"Shortcut");
    if(section == 1)
        return LocalisedString(@"Others");
    if(section == 2)
        return LocalisedString(@"Log out");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsTableViewCell"];
    NSArray* temArray= self.arrData[indexPath.section];
    NSString* text = LocalisedString(temArray[indexPath.row]);
    cell.lblTitle.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0://shortcut
            switch (indexPath.row) {
                case 0://add place
                    
                    break;
                case 1://recommend
                    [self gotoRecommendationPage];
                    break;
                    break;
                case 2://draft
                    [self gotoDraftPage];
                    break;
                    
                default:
                    break;
            }

            
            break;
            
        case 1://others
        {
            NSArray* temArray= self.arrData[indexPath.section];
            NSString* text = temArray[indexPath.row];
            
            SWITCH(text){
            
                CASE (@"Rate Us"){
                  
                    _ctWebViewController = nil;
                    
                    [self.navigationController pushViewController:self.ctWebViewController animated:YES onCompletion:^{
                        
                        [self.ctWebViewController initDataWithURL:URL_ABOUT_US andTitle:text];
                    }];

                    break;
                }
                
                CASE (@"About")
                {
                    _ctWebViewController = nil;
                    [self.navigationController pushViewController:self.ctWebViewController animated:YES onCompletion:^{
                        
                        [self.ctWebViewController initDataWithURL:URL_ABOUT_US andTitle:text];
                    }];
                    
                    break;
                    
                    
                }
                CASE (@"Feedback")
                {
                    
                    [self.navigationController pushViewController:self.feedbackViewController animated:YES];
                    break;
                    
                    
                }
                CASE (@"Account Settings")
                {
                    _ct3_AcctSettingViewController = nil;
                    [self.navigationController pushViewController:self.ct3_AcctSettingViewController animated:YES];
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

-(AccountSettingViewController*)accountSettingViewController
{
    if (!_accountSettingViewController) {
        _accountSettingViewController = [AccountSettingViewController new];
    }
    
    return _accountSettingViewController;
}

-(FeedbackViewController*)feedbackViewController
{
    if (!_feedbackViewController) {
        _feedbackViewController = [FeedbackViewController new];
    }
    
    return _feedbackViewController;
}


-(NSArray*)arrData
{
    if (!_arrData) {
        
        if (![Utils isGuestMode]) {
            NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Add Place",@"Recommend",@"Drafts", nil];//@"Notification Settings"
            NSArray *secondItemsArray = [[NSArray alloc] initWithObjects:@"Account Settings", @"Rate Us",@"About",@"Feedback", nil];
            NSArray *threeItemsArray = [[NSArray alloc] initWithObjects:@"Sign out", nil];
            _arrData = @[firstItemsArray,secondItemsArray,threeItemsArray];

        }
        else
        {
            NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Add Place",@"Recommend",@"Drafts", nil];//@"Notification Settings"
            NSArray *secondItemsArray = [[NSArray alloc] initWithObjects:@"Rate Us",@"About",@"Feedback", nil];
            //NSArray *threeItemsArray = [[NSArray alloc] initWithObjects:@"Sign out", nil];
            _arrData = @[firstItemsArray,secondItemsArray];
        }
    }
    return _arrData;
}


-(RecommendationViewController*)recommendationViewController
{
    if (!_recommendationViewController) {
        _recommendationViewController = [RecommendationViewController new];
    }
    
    return _recommendationViewController;
}

-(void)gotoDraftPage
{
    [self.recommendDelegate showDraftView:self];
    // go to draft
}

-(void)gotoRecommendationPage
{
    
//    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:self.recommendationViewController];
//    [self presentViewController:nav animated:YES completion:nil];
//    [self.recommendationViewController initData:2 sender:nav];
    
    [self.recommendDelegate showRecommendationView:self];

}

-(void)logout
{
    [self serverRequestLogout];
   
    
}

#pragma mark - Server Request

-(void)serverRequestLogout
{
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           };
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetLogout param:dict appendString:nil completeHandler:^(id object) {
        
        [Utils setLogout];
//        _arrData = nil;
//        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)reloadData
{
    //SLog(@"ggwp");
    _arrData = nil;
    [self.ibTableView reloadData];

}

-(void)changeLanguage
{
    SLog(@"%@",LocalisedString(@"More"));

    self.lblTitle.text = LocalisedString(@"More");
    [self.ibTableView reloadData];
}
@end
