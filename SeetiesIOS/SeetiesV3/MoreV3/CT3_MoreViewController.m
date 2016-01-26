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

@interface CT3_MoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (nonatomic,strong)RecommendationViewController* recommendationViewController;
@property (nonatomic,strong)DoImagePickerController* imagePickerViewController;
@property (nonatomic,strong)NSArray* arrData;
@property(nonatomic)DraftAndRecommendationDelegate* recommendDelegate;
@end

@implementation CT3_MoreViewController

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
    NSString* text = temArray[indexPath.row];
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
            
        }
            
            break;
            
        case 2://logout
            
            
            break;
            
        default:
            break;
    }
    
    NSLog(@"indexPath.section IS %ld",(long)indexPath.section);
    [self.ibTableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark - Declaration

-(NSArray*)arrData
{
    if (!_arrData) {
        NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Add Place",@"Recommend",@"Drafts", nil];//@"Notification Settings"
        NSArray *secondItemsArray = [[NSArray alloc] initWithObjects:@"Account Settings", @"Rate Us",@"About",@"Feedback", nil];
        NSArray *threeItemsArray = [[NSArray alloc] initWithObjects:@"Sign out of Seeties", nil];

        _arrData = @[firstItemsArray,secondItemsArray,threeItemsArray];
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
//    
//    [self presentViewController:nav animated:YES completion:nil];
//    [self.recommendationViewController initData:2 sender:nav];
    
    [self.recommendDelegate showRecommendationView:self];

}
@end
