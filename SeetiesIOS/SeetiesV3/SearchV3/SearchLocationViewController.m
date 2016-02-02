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
@property (weak, nonatomic) IBOutlet UITableView *ibSearchTable;

@property (strong, nonatomic) NSMutableArray *arrCountries;
@property (strong, nonatomic) NSArray *cityArray;
@property (nonatomic) BOOL hasSelectedCountry;
@property (nonatomic, strong) SearchManager *searchManager;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) SearchModel *searchModel;

@property (nonatomic, strong) CountriesModel *countriesModel;

@end

@implementation SearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userLocation = [[SearchManager Instance] getAppLocation];
    [self initSelfView];
    
    //[self requestServerForCountry];
    [self requestServerForCountryPlaces:@"1"];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)initSelfView{
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

-(SearchManager*)searchManager{
    if (!_searchManager) {
        _searchManager = [[SearchManager Instance] init];
    }
    return _searchManager;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.ibCountryTable) {
        return self.arrCountries.count;
    }
    else if (tableView == self.ibAreaTable){
        return self.hasSelectedCountry? [[self.cityArray objectAtIndex:section] count]-1 : 0;
    }
    else if (tableView == self.ibSearchTable){
        return self.searchModel.predictions.count;
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
    
    if (tableView == self.ibCountryTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CountryCell"];
        }
        CountryModel* model = self.arrCountries[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }
    else if (tableView == self.ibAreaTable){
        SearchLocationAreaCell *areaCell = [tableView dequeueReusableCellWithIdentifier:@"SearchLocationAreaCell"];
        NSString *title = [[self.cityArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [areaCell setAreaTitle:title];
        
        return areaCell;
    }
    else if (tableView == self.ibSearchTable){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
        }
        SearchLocationModel *slModel = [self.searchModel.predictions objectAtIndex:indexPath.row];
        NSDictionary *term = [slModel.terms objectAtIndex:0];
        cell.textLabel.text = [term objectForKey:@"value"];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ibCountryTable) {
        
        NSString* countrID = self.arrCountries[indexPath.row];
        [self requestServerForCountryPlaces:countrID];
        self.hasSelectedCountry = YES;
        
        //[self.ibAreaTable reloadData];
    }
    else if (tableView == self.ibAreaTable){
        SLog(@"Clicked: %ld,%ld", indexPath.section, indexPath.row);
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.refreshLocation) {
                self.refreshLocation();
            }
        }];
    }
    else if (tableView == self.ibSearchTable){
        [self processDataForGoogleLocation:indexPath];
    }
}



-(void)processDataForGoogleLocation:(NSIndexPath*)indexPath
{
    SearchLocationModel* model = self.searchModel.predictions[indexPath.row];
    [self requestForGoogleMapDetails:model.place_id];
    
    NSDictionary* dict = model.terms[0];
    self.ibSearchTxtField.text = dict[@"value"];
    self.ibSearchTable.hidden = YES;
    
}

-(void)requestForGoogleMapDetails:(NSString*)placeID
{
    
    NSDictionary* dict = @{@"placeid":placeID,@"key":GOOGLE_API_KEY};
    
    [[ConnectionManager Instance] requestServerWithPost:NO customURL:GOOGLE_PLACE_DETAILS_API requestType:ServerRequestTypeGoogleSearchWithDetail param:dict completeHandler:^(id object) {
        
        SearchLocationDetailModel* googleSearchDetailModel = [[DataManager Instance] googleSearchDetailModel];
        
        RecommendationVenueModel* recommendationVenueModel  = [RecommendationVenueModel new];
        SLog(@"recommendationVenueModel == %@",recommendationVenueModel);
        [recommendationVenueModel processGoogleModel:googleSearchDetailModel];
        
        [self.ibSearchTxtField resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.refreshLocation) {
                self.refreshLocation();
            }
        }];
        
    } errorBlock:nil];
    
}


#pragma mark Action

- (IBAction)searchDidBegin:(id)sender {
    self.ibSearchTable.hidden = NO;
}

- (IBAction)searchDidEnd:(id)sender {
    self.ibSearchTable.hidden = YES;
}

- (IBAction)searchDidChange:(UITextField*)sender {
    SLog(@"Search text: %@", sender.text);
    [self getGoogleSearchPlaces];
}

#pragma mark - Declaration

-(NSMutableArray*)arrCountries
{
    if (!_arrCountries) {
        _arrCountries = [NSMutableArray new];
    }
    
    return _arrCountries;
}

#pragma mark - Request Server
-(void)getGoogleSearchPlaces
{
    [self.searchManager getSearchLocationFromGoogle:self.userLocation input:self.ibSearchTxtField.text completionBlock:^(id object) {
        if (object) {
            self.searchModel = [[DataManager Instance] googleSearchModel];
            [self.ibSearchTable reloadData];
        }
    }];
    
}
-(void)requestServerForCountry
{
    NSDictionary* dict = @{@"language_code":ENGLISH_CODE};
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetHomeCountry param:dict appendString:nil completeHandler:^(id object) {
        
        self.countriesModel = [[ConnectionManager dataManager]countriesModel];
        [self.arrCountries addObjectsFromArray:self.countriesModel.countries];
        
        [self.ibCountryTable reloadData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForCountryPlaces:(NSString*)countryID
{
    NSDictionary* dict = @{@"country_id":countryID,
                           @"offset":@"1",
                           @"limit":@"10"};
    
    NSString* appendString = [NSString stringWithFormat:@"%@/places",countryID];
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetHomeCountryPlace param:dict appendString:appendString completeHandler:^(id object) {
        
        
       // [self.arrCountries addObjectsFromArray:self.countriesModel.countries];
        
        [self.ibAreaTable reloadData];
        
    } errorBlock:^(id object) {
        
    }];
}


@end
