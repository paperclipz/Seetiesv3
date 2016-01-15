//
//  CT3_MoreViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 15/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_MoreViewController.h"
#import "SettingsTableViewCell.h"
@interface CT3_MoreViewController ()<UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@end

@implementation CT3_MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self InitSelfView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)InitSelfView{
    
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[SettingsTableViewCell class] forCellReuseIdentifier:@"SettingsTableViewCell"];

    //Initialize the dataArray
    dataArray = [[NSMutableArray alloc] init];
    
    NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:LocalisedString(@"Add Place"), LocalisedString(@"Recommend"),LocalisedString(@"Drafts"), nil];//@"Notification Settings"
    NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
    [dataArray addObject:firstItemsArrayDict];
    
    //Second section data
    NSArray *secondItemsArray = [[NSArray alloc] initWithObjects:LocalisedString(@"Account Settings"), LocalisedString(@"Rate Us"),LocalisedString(@"About"),LocalisedString(@"Feedback"), nil];
    NSDictionary *secondItemsArrayDict = [NSDictionary dictionaryWithObject:secondItemsArray forKey:@"data"];
    [dataArray addObject:secondItemsArrayDict];
    
    //Second section data
    NSArray *threeItemsArray = [[NSArray alloc] initWithObjects:LocalisedString(@"Sign out of Seeties"), nil];
    NSDictionary *threeItemsArrayDict = [NSDictionary dictionaryWithObject:threeItemsArray forKey:@"data"];
    [dataArray addObject:threeItemsArrayDict];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
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
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        // 1. The view for the header
//        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 22)];
//        
//        
//        // 3. Add a label
//        UILabel* headerLabel = [[UILabel alloc] init];
//        headerLabel.frame = CGRectMake(15, 30, tableView.frame.size.width - 5, 22);
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.textColor = [UIColor darkGrayColor];
//        headerLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
//        headerLabel.text = LocalisedString(@"Shortcut");
//        headerLabel.textAlignment = NSTextAlignmentLeft;
//        
//        // 4. Add the label to the header view
//        [headerView addSubview:headerLabel];
//        
//        
//        // 5. Finally return
//        return headerView;
//    }
//    
//    if (section == 1) {
//        // 1. The view for the header
//        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 22)];
//        
//        
//        // 3. Add a label
//        UILabel* headerLabel = [[UILabel alloc] init];
//        headerLabel.frame = CGRectMake(15, 5, tableView.frame.size.width - 5, 30);
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.textColor = [UIColor darkGrayColor];
//        headerLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
//        headerLabel.text = LocalisedString(@"Others");
//        headerLabel.textAlignment = NSTextAlignmentLeft;
//        
//        // 4. Add the label to the header view
//        [headerView addSubview:headerLabel];
//        
//        
//        // 5. Finally return
//        return headerView;
//    }
//    if (section == 2) {
//        // 1. The view for the header
//        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 22)];
//        
//        
//        // 3. Add a label
//        UILabel* headerLabel = [[UILabel alloc] init];
//        headerLabel.frame = CGRectMake(15, 5, tableView.frame.size.width - 5, 30);
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.textColor = [UIColor darkGrayColor];
//        headerLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
//        headerLabel.text = @"";
//        headerLabel.textAlignment = NSTextAlignmentLeft;
//        
//        // 4. Add the label to the header view
//        [headerView addSubview:headerLabel];
//        
//        
//        // 5. Finally return
//        return headerView;
//    }
//    
//    return 0;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsTableViewCell"];
    NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cell.lblTitle.text = cellValue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath.section IS %ld",(long)indexPath.section);
}

@end
