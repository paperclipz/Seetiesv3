//
//  SearchLocationViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 19/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SearchLocationViewController.h"
#import "CT3_EnableLocationViewController.h"

@interface SearchLocationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblAutoDetect;
@property (weak, nonatomic) IBOutlet UITextField *ibSearchTxtField;
@property (weak, nonatomic) IBOutlet UITableView *ibCountryTable;
@property (weak, nonatomic) IBOutlet UITableView *ibAreaTable;
@property (weak, nonatomic) IBOutlet UITableView *ibSearchTable;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgLocation;

@property (strong, nonatomic) NSMutableArray *arrCountries;
@property (strong, nonatomic) NSArray *cityArray;
@property (nonatomic) BOOL hasSelectedCountry;
@property (nonatomic, strong) SearchManager *searchManager;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) SearchModel *searchModel;

@property (nonatomic, strong) CountriesModel *countriesModel;

@property (nonatomic, strong) CountryModel *currentSelectedCountry;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIImageView *btnCloseImage;
@property(nonatomic)CT3_EnableLocationViewController* enableLocationViewController;

@property(nonatomic,readwrite)NSString* locationName;

@property (weak, nonatomic) IBOutlet UIView *ibHeaderContentView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SearchLocationViewController

#pragma mark - IBACTION
- (IBAction)btnutoDetectClicked:(id)sender {
    
    
    if ([SearchManager isDeviceGPSTurnedOn]) {
        
        if (self.userLocation) {
            
            [self stopBlinkGPS];

            [self getGoogleGeoCode];

        }
        else{
            
            [LoadingManager show];
            
            [self startBlinkGPS];

            [self.searchManager startSearchGPSLocation:^(CLLocation *location) {
                
                [self stopBlinkGPS];

                self.userLocation = location;
               
                [self getGoogleGeoCode];
                
                [LoadingManager hide];
                
            }];

        }
        

    }
    else{
        
        [self presentViewController:self.enableLocationViewController animated:YES completion:nil];
       // [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Please Enable Location Service") Type:TSMessageNotificationTypeError];
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    if ([SearchManager isDeviceGPSTurnedOn]) {
        
        if (!self.userLocation) {
            [self.searchManager startSearchGPSLocation:^(CLLocation *location) {
                self.userLocation = location;
                [self stopBlinkGPS];

            }];
        }
        
        self.lblAutoDetect.textColor = ONE_ZERO_TWO_COLOR;

        self.ibImgLocation.image = [UIImage imageNamed:@"SelectLocationAutoDetectIcon.png"];
        [self startBlinkGPS];

    }
    else{
        self.lblAutoDetect.textColor = TWO_ZERO_FOUR_COLOR;

        self.ibImgLocation.image = [UIImage imageNamed:@"SelectLocationAutoDetectIconDeactivated.png"];
        [self stopBlinkGPS];
    }
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userLocation = [[SearchManager Instance] getAppLocation];
    [self initSelfView];
    
    [self requestServerForCountry];
    // Do any additional setup after loading the view from its nib.
    
}


-(void)hideBackButton
{
    self.btnClose.hidden = YES;
    self.btnCloseImage.hidden = YES;
}

-(void)initSelfView{
//    NSArray *pj = @[@"All of Petaling Jaya", @"Damansara Jaya", @"Damansara Kim", @"Petaling Jaya"];
//    NSArray *sj = @[@"All of Subang Jaya", @"SS 15", @"One City", @"Subang Jaya"];
//    NSArray *other = @[@"Georgetown", @"Ipoh", @"Other Cities"];
    
   // _cityArray = @[pj, sj, other];
    
    [Utils setRoundBorder:self.ibHeaderContentView color:[UIColor clearColor] borderRadius:self.ibHeaderContentView.frame.size.height/2 borderWidth:0];
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
        
        cell.backgroundColor = TWO_FOUR_FIVE_COLOR;
        CountryModel* model = self.arrCountries[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.font = [UIFont fontWithName:CustomFontNameBold size:15];
        cell.textLabel.textColor = TEXT_GRAY_COLOR;
        
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchCell"];
        }
        SearchLocationModel *slModel = [self.searchModel.predictions objectAtIndex:indexPath.row];
        NSDictionary *term = [slModel.terms objectAtIndex:0];
        cell.textLabel.text = [term objectForKey:@"value"];
        cell.detailTextLabel.text = [slModel longDescription];

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
        
        PlacesModel* psModel = self.currentSelectedCountry.arrArea[indexPath.section];
        PlaceModel* pModel = psModel.places[indexPath.row];
        
        
        self.locationName = pModel.name;

        
        HomeLocationModel* hModel = [HomeLocationModel new];
        hModel.timezone = @"";
        hModel.type = @"none";
        hModel.latitude = pModel.latitude;
        hModel.longtitude = pModel.longtitude;
        hModel.place_id = pModel.place_id;
        hModel.locationName = pModel.name;

        if (self.homeLocationRefreshBlock) {
            self.homeLocationRefreshBlock(hModel);
        }
    
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
    self.locationName = dict[@"value"];
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
        
        HomeLocationModel* hModel = [HomeLocationModel new];
        hModel.timezone = @"";
        hModel.type = @"current";
        hModel.latitude = recommendationVenueModel.lat;
        hModel.longtitude = recommendationVenueModel.lng;
        hModel.place_id = recommendationVenueModel.place_id;
        hModel.address_components.country = recommendationVenueModel.country;
        hModel.address_components.route = recommendationVenueModel.route;
        hModel.address_components.locality = recommendationVenueModel.city;
        hModel.address_components.administrative_area_level_1 = recommendationVenueModel.state;
        hModel.locationName = recommendationVenueModel.name;
        
        if (self.homeLocationRefreshBlock) {
            self.homeLocationRefreshBlock(hModel);
        }
        
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

-(CT3_EnableLocationViewController*)enableLocationViewController
{
    if (!_enableLocationViewController) {
        _enableLocationViewController = [CT3_EnableLocationViewController new];
    }
    
    return _enableLocationViewController;
}
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
        
        if (![Utils isArrayNull:arrayLocations]) {
            NSDictionary* tempLocation = arrayLocations[0];
            
            SearchLocationDetailModel* model = [[SearchLocationDetailModel alloc]initWithDictionary:tempLocation error:nil];
            [model process];
            
            HomeLocationModel* hModel = [HomeLocationModel new];
            hModel.timezone = @"";
            hModel.type = @"current";
            hModel.latitude = model.lat;
            hModel.longtitude = model.lng;
            hModel.place_id = @"";
            hModel.address_components.country = model.country;
            hModel.address_components.route = model.route;
            hModel.address_components.locality = model.city;
            hModel.address_components.administrative_area_level_1 = model.state;
            hModel.address_components.political = model.political;
           
            if (![Utils isStringNull:model.subLocality]) {
                hModel.locationName = model.subLocality;
                
            }
            else{
                hModel.locationName = model.subLocality_lvl_1;
                
            }

            if (self.homeLocationRefreshBlock) {
                self.homeLocationRefreshBlock(hModel);
            }
        }

    }];
}
-(void)getGoogleSearchPlaces
{
    self.userLocation = [self.searchManager getAppLocation];

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
        
        @try {
            
            NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:1 inSection:0];

            [self.ibCountryTable selectRowAtIndexPath:selectedCellIndexPath
                                             animated:NO
                                       scrollPosition:UITableViewScrollPositionNone];
            
            
            CountryModel* countryModel = self.arrCountries[selectedCellIndexPath.row];
            self.currentSelectedCountry = countryModel;
            
            
            if ([Utils isArrayNull:countryModel.arrArea]) {
                [self requestServerForCountryPlaces:countryModel];
            }
            else{
                [self.ibAreaTable reloadData];
            }


        }
        @catch (NSException *exception) {
            
        }
        
        
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

- (void)onTimerEvent:(NSTimer*)timer
{
    self.ibImgLocation.alpha = 0;

    [UIView animateWithDuration:0.5 animations:^{
        self.ibImgLocation.alpha = 1;

    }];
}


-(void)startBlinkGPS
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimerEvent:) userInfo:nil repeats:YES];

}

-(void)stopBlinkGPS
{
    [self.timer invalidate];
}

@end
