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

@property (nonatomic, strong) CountryModel *currentSelectedCountry;

@end

@implementation SearchLocationViewController
- (IBAction)btnutoDetectClicked:(id)sender {
    
    [self getGoogleGeoCode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userLocation = [[SearchManager Instance] getAppLocation];
    [self initSelfView];
    
    [self requestServerForCountry];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)initSelfView{
//    NSArray *pj = @[@"All of Petaling Jaya", @"Damansara Jaya", @"Damansara Kim", @"Petaling Jaya"];
//    NSArray *sj = @[@"All of Subang Jaya", @"SS 15", @"One City", @"Subang Jaya"];
//    NSArray *other = @[@"Georgetown", @"Ipoh", @"Other Cities"];
    
   // _cityArray = @[pj, sj, other];
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
        
        NSIndexPath *selectedIndexPath = [self.ibCountryTable indexPathForSelectedRow];

        CountryModel* cModel = self.arrCountries[selectedIndexPath.row];
        PlacesModel* pModel = cModel.arrArea[section];
        return pModel.places.count;
    }
    else if (tableView == self.ibSearchTable){
        return self.searchModel.predictions.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.ibAreaTable){
        NSIndexPath *selectedIndexPath = [self.ibCountryTable indexPathForSelectedRow];

        if (selectedIndexPath) {
            CountryModel* cModel = self.arrCountries[selectedIndexPath.row];
            return cModel.arrArea.count;
        }
        else{
            return 0;
        }
        
    }
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.ibAreaTable) {
        
        NSIndexPath *selectedIndexPath = [self.ibCountryTable indexPathForSelectedRow];
        CountryModel* cModel = self.arrCountries[selectedIndexPath.row];
        PlacesModel* pModel = cModel.arrArea[section];
        
        return pModel.area_name;
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
       
        NSIndexPath *selectedIndexPath = [self.ibCountryTable indexPathForSelectedRow];
        CountryModel* cModel = self.arrCountries[selectedIndexPath.row];
        PlacesModel* psModel = cModel.arrArea[indexPath.section];
        PlaceModel* pModel = psModel.places[indexPath.row];
        [areaCell setAreaTitle:pModel.name];
        
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
        
        CountryModel* countryModel = self.arrCountries[indexPath.row];
        self.currentSelectedCountry = countryModel;
        
        
        if ([Utils isArrayNull:countryModel.arrArea]) {
            [self requestServerForCountryPlaces:countryModel];
        }
        else{
            [self.ibAreaTable reloadData];
        }

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
-(void)getGoogleGeoCode
{
    [self.searchManager getGoogleGeoCode:self.userLocation completionBlock:^(id object) {
       
        NSDictionary* temp = [[NSDictionary alloc]initWithDictionary:object];
        NSArray* arrayLocations = [temp valueForKey:@"results"];
        NSDictionary* tempLocation = arrayLocations[0];
        
        SearchLocationDetailModel* model = [[SearchLocationDetailModel alloc]initWithDictionary:tempLocation error:nil];
        [model process];
//        model.country;
//        model.route;
//        model.address_components;
//        SLog(@"%@",model);

    }];
}
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


-(void)processPlaces:(AreaModel*)aModel ForCountry:(CountryModel*)cModel
{
    
    
    if ([Utils isArrayNull:cModel.arrArea]) {
        [cModel.arrArea addObjectsFromArray:aModel.result];
        return;
    }
    
    NSMutableArray* arrTemp = [NSMutableArray new];
        for (int i = 0; i<aModel.result.count; i++) {
            
            PlacesModel* psaModel = aModel.result[i];
            
            BOOL isNeedAddNewArea = NO;
           
            for (int j = 0; j<cModel.arrArea.count; j++) {
                
                isNeedAddNewArea = YES;

                PlacesModel* pscModel = cModel.arrArea[j];
                if ([pscModel.area_name isEqualToString:psaModel.area_name]) {
                    
                    [pscModel.places addObjectsFromArray:psaModel.places];
                    isNeedAddNewArea = NO;
                    break;
                }
              
            }
            
            if (isNeedAddNewArea) {
                [arrTemp addObject:psaModel];

            }

        }
    
    [cModel.arrArea addObjectsFromArray:arrTemp];
        
    cModel.paging = aModel.paging;
    cModel.limit = aModel.limit;
    cModel.offset = aModel.offset;
    cModel.total_count = aModel.total_count;
}

-(void)requestServerForCountryPlaces:(CountryModel*)countryModel
{
    NSDictionary* dict = @{@"country_id":@(countryModel.country_id),
                           @"offset":@(countryModel.offset + countryModel.limit),
                           @"limit":@"10"};

    NSString* appendString = [NSString stringWithFormat:@"%i/places",countryModel.country_id];
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetHomeCountryPlace param:dict appendString:appendString completeHandler:^(id object) {
        
        NSDictionary* dict = object[@"data"];
        AreaModel* model = [[AreaModel alloc]initWithDictionary:dict error:nil];
        [self processPlaces:model ForCountry:countryModel];
      
        [self.ibAreaTable reloadData];
        
    } errorBlock:^(id object) {
        
    }];
}


- (void)scrollViewDidScroll: (UIScrollView *)scrollView {
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= self.ibAreaTable.frame.size.height/2) {

        if(![Utils isStringNull:self.currentSelectedCountry.paging.next])
        {
            [self requestServerForCountryPlaces:self.currentSelectedCountry];
        }
    }
    
//    /*for top navigation bar alpha setting*/
//    int profileBackgroundHeight = TopBarHeight;
//    
//    if (scrollView.contentOffset.y > profileBackgroundHeight)
//    {
//        ibHeaderBackgroundView.alpha = 1;
//        
//    }
//    else{
//        float adjustment = (scrollView.contentOffset.y
//                            )/(profileBackgroundHeight);
//        // SLog(@"adjustment : %f",adjustment);
//        ibHeaderBackgroundView.alpha = adjustment;
//    }
    
}


@end
