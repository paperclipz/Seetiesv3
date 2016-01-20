//
//  SearchLocationViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 19/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SearchLocationViewController.h"

@interface SearchLocationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ibSearchTxtField;
@property (weak, nonatomic) IBOutlet UITableView *ibCountryTable;
@property (weak, nonatomic) IBOutlet UITableView *ibAreaTable;

@property (strong, nonatomic) NSArray *countryArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (nonatomic) BOOL hasSelectedCountry;
@end

@implementation SearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)initSelfView{
    _countryArray = @[@"Indonesia", @"Malaysia", @"Philippines", @"Singapore", @"Taiwan", @"Thailand"];
    NSArray *pj = @[@"All of Petaling Jaya", @"Damansara Jaya", @"Damansara Kim", @"Petaling Jaya"];
    NSArray *sj = @[@"All of Subang Jaya", @"SS 15", @"One City", @"Subang Jaya"];
    NSArray *other = @[@"Georgetown", @"Ipoh", @"Other Cities"];
    
    _cityArray = @[pj, sj, other];
    self.hasSelectedCountry = NO;
    
    [self.ibAreaTable registerNib:[UINib nibWithNibName:@"SearchLocationAreaCell" bundle:nil] forCellReuseIdentifier:@"SearchLocationAreaCell"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.ibCountryTable) {
        return self.countryArray.count;
    }
    else if (tableView == self.ibAreaTable){
        return self.hasSelectedCountry? [[self.cityArray objectAtIndex:section] count]-1 : 0;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.ibAreaTable){
        return self.cityArray.count;
    }
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.ibAreaTable) {
        return self.hasSelectedCountry? [[self.cityArray objectAtIndex:section] lastObject] : nil;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (tableView == self.ibCountryTable) {
        cell.textLabel.text = [self.countryArray objectAtIndex:indexPath.row];
    }
    else if (tableView == self.ibAreaTable){
        SearchLocationAreaCell *areaCell = [tableView dequeueReusableCellWithIdentifier:@"SearchLocationAreaCell"];
        NSString *title = [[self.cityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [areaCell setAreaTitle:title];
        
        return areaCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ibCountryTable) {
        self.hasSelectedCountry = YES;
        [self.ibAreaTable reloadData];
    }
    else if (tableView == self.ibAreaTable){
        SLog(@"Clicked: %ld,%ld", indexPath.section, indexPath.row);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
