//
//  SearchLocationViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 19/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SearchLocationViewController.h"
#import "CT3_EnableLocationViewController.h"

@interface SearchLocationViewController ()<CLLocationManagerDelegate>
{

    int selectedIndex;
    BOOL isMiddleOfRequesting;
    BOOL isMiddleOfRequestingCountry;

}
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
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
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIImageView *btnCloseImage;
@property(nonatomic)CT3_EnableLocationViewController* enableLocationViewController;

@property(nonatomic,readwrite)NSString* locationName;

@property (weak, nonatomic) IBOutlet UIView *ibHeaderContentView;
@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic,strong)CLLocationManager* manager;

@end

@implementation SearchLocationViewController

-(void)startSearchGPSLocation
{
    [self startBlinkGPS];

    [self.manager startUpdatingLocation];
}

#pragma mark - IBACTION
- (IBAction)btnutoDetectClicked:(id)sender {
    
    
    if ([SearchManager isDeviceGPSTurnedOn]) {
        
        if (self.userLocation) {
            
            [self stopBlinkGPS];

            [LoadingManager show];
            
            [self getGoogleGeoCode];

        }
        else{
            
            [self startSearchGPSLocation];
                
            [UIAlertView showWithTitle:LocalisedString(@"Couldn't get your location now") message:LocalisedString(@"try again later") cancelButtonTitle:LocalisedString(@"OK") otherButtonTitles:nil tapBlock:nil];
        }
        
    }
    else{
    
        [self presentViewController:self.enableLocationViewController animated:YES completion:nil];
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [self changeLanguage];
    
    if ([SearchManager isDeviceGPSTurnedOn]) {
        
        [self startSearchGPSLocation];
        
        self.lblAutoDetect.textColor = ONE_ZERO_TWO_COLOR;

        self.ibImgLocation.image = [UIImage imageNamed:@"SelectLocationAutoDetectIcon.png"];

    }
    else{
        
        [self stopBlinkGPS];

        self.lblAutoDetect.textColor = TWO_ZERO_FOUR_COLOR;
        
        self.ibImgLocation.image = [UIImage imageNamed:@"SelectLocationAutoDetectIconDeactivated.png"];
    }
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    [self requestServerForCountry];
    
}

-(void)changeLanguage{
    
    self.lblAutoDetect.text = LocalisedString(@"Auto-detect your location");
    self.ibHeaderTitle.text = LocalisedString(@"Select Location");
    self.ibSearchTxtField.placeholder = LocalisedString(@"Search for a location");
}


-(void)hideBackButton
{
    self.btnClose.hidden = YES;
    self.btnCloseImage.hidden = YES;
}

-(void)initSelfView{

    isMiddleOfRequesting = NO;
    [Utils setRoundBorder:self.ibHeaderContentView color:[UIColor clearColor] borderRadius:self.ibHeaderContentView.frame.size.height/2 borderWidth:0];
    self.hasSelectedCountry = NO;
    
    [self.ibAreaTable registerNib:[UINib nibWithNibName:@"SearchLocationAreaCell" bundle:nil] forCellReuseIdentifier:@"SearchLocationAreaCell"];
    [self.ibCountryTable registerNib:[UINib nibWithNibName:@"SearchLocationCountryCell" bundle:nil] forCellReuseIdentifier:@"SearchLocationCountryCell"];
    [self.ibSearchTable registerNib:[UINib nibWithNibName:@"SearchLocationResultCell" bundle:nil] forCellReuseIdentifier:@"SearchLocationResultCell"];
    
    self.ibSearchTable.estimatedRowHeight = [SearchLocationResultCell getHeight];
    self.ibSearchTable.rowHeight = UITableViewAutomaticDimension;
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
        
        @try {
            
            CountryModel* cModel = self.arrCountries[selectedIndex];
            PlacesModel* pModel = cModel.arrArea[section];
            return pModel.places.count;

        }
        @catch (NSException *exception) {
            
        }
      
    }
    else if (tableView == self.ibSearchTable){
        return self.searchModel.predictions.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.ibAreaTable){

        if ([Utils isArrayNull:self.arrCountries]) {
            return 0;
        }
        else{
            CountryModel* cModel = self.arrCountries[selectedIndex];
            return cModel.arrArea.count;
        }
       
        
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.ibAreaTable) {
        return 50;
    }
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.ibAreaTable) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ibAreaTable.frame.size.width, 50)];
        contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat fontHeight = 20;
        UILabel *areaLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, (contentView.frame.size.height-fontHeight)/2, contentView.frame.size.width, fontHeight)];
        areaLbl.textColor = DEVICE_COLOR;
        areaLbl.font = [UIFont boldSystemFontOfSize:15.0f];
        
        @try {

            CountryModel* cModel = self.arrCountries[selectedIndex];
            PlacesModel* pModel = cModel.arrArea[section];
            areaLbl.text = pModel.area_name;
            
            [contentView addSubview:areaLbl];
        } @catch (NSException *exception) {
            
           
        }
       
        
        return contentView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.ibCountryTable) {
        SearchLocationCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchLocationCountryCell"];
        CountryModel* model = self.arrCountries[indexPath.row];
        [cell initCellWithData:model];
        return cell;
    }
    else if (tableView == self.ibAreaTable){
        SearchLocationAreaCell *areaCell = [tableView dequeueReusableCellWithIdentifier:@"SearchLocationAreaCell"];
       
        CountryModel* cModel = self.arrCountries[selectedIndex];
        PlacesModel* psModel = cModel.arrArea[indexPath.section];
        PlaceModel* pModel = psModel.places[indexPath.row];
        [areaCell initCellWithPlace:pModel];
        
        return areaCell;
    }
    else if (tableView == self.ibSearchTable){
        SearchLocationResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchLocationResultCell"];
        
        SearchLocationModel *slModel = [self.searchModel.predictions objectAtIndex:indexPath.row];
        NSDictionary *term = [slModel.terms objectAtIndex:0];
        cell.ibPlaceLbl.text = [term objectForKey:@"value"];
        cell.ibAddressLbl.text = [slModel longDescription];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.ibCountryTable) {
        
        [self.ibAreaTable setContentOffset:self.ibAreaTable.contentOffset animated:NO];
        [self.ibAreaTable setUserInteractionEnabled:NO];
        
        if (![Utils isArrayNull:self.arrCountries]) {
         
            CountryModel* countryModel = self.arrCountries[indexPath.row];
            
            selectedIndex = (int)indexPath.row;
            
            if ([Utils isArrayNull:countryModel.arrArea]) {
                
                if (countryModel) {
                    
                    [self requestServerForCountryPlaces:countryModel];
                }
            }
            else{
                [self.ibAreaTable reloadData];
                [self.ibAreaTable setUserInteractionEnabled:YES];
            }

        }
       
    }
    else if (tableView == self.ibAreaTable){
        
        
        NSIndexPath* countrySelectedIndex = self.ibCountryTable.indexPathForSelectedRow;
        CountryModel* countryModel = self.arrCountries[countrySelectedIndex.row];

        if ([Utils isArrayNull:countryModel.arrArea]) {
            return;
        }
        
        PlacesModel* psModel = countryModel.arrArea[indexPath.section];
        PlaceModel* pModel = psModel.places[indexPath.row];
        
        self.locationName = pModel.name;

        HomeLocationModel* hModel = [HomeLocationModel new];
        hModel.timezone = @"";
        hModel.type = Type_Featured;
        hModel.latitude = pModel.latitude;
        hModel.longtitude = pModel.longtitude;
        hModel.place_id = pModel.place_id;
        hModel.locationName = pModel.name;
        hModel.countryId = countryModel.country_id;
        if (self.homeLocationRefreshBlock) {
            self.homeLocationRefreshBlock(hModel);
        }
    
    }
    else if (tableView == self.ibSearchTable){
        [self processDataForGoogleLocation:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ibSearchTable) {
        return UITableViewAutomaticDimension;
    }
    return 44;
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
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGoogleSearchWithDetail parameter:dict appendString:nil success:^(id object) {
        
        SearchLocationDetailModel* googleSearchDetailModel = [[DataManager Instance] googleSearchDetailModel];
        
        RecommendationVenueModel* recommendationVenueModel  = [RecommendationVenueModel new];
        SLog(@"recommendationVenueModel == %@",recommendationVenueModel);
        [recommendationVenueModel processGoogleModel:googleSearchDetailModel];
        
        [self.ibSearchTxtField resignFirstResponder];
        
        HomeLocationModel* hModel = [HomeLocationModel new];
        hModel.timezone = @"";
        hModel.type = Type_Current;
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
        
    } failure:nil];
    
}


#pragma mark Action


- (IBAction)searchDidBegin:(id)sender {
    self.ibSearchTable.hidden = NO;
    self.ibHeaderTitle.text = LocalisedString(@"Search for a location");
}

- (IBAction)searchDidEnd:(id)sender {
    self.ibSearchTable.hidden = YES;
    self.ibHeaderTitle.text = LocalisedString(@"Select Location");
}

- (IBAction)searchDidChange:(UITextField*)sender {
    SLog(@"Search text: %@", sender.text);
    [self getGoogleSearchPlaces];
}

#pragma mark - Declaration

-(CLLocationManager*)manager
{
    if (!_manager) {
        _manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionAlways];
        _manager.delegate = self;
        [_manager requestWhenInUseAuthorization];
    }
    return _manager;
}

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
            hModel.type = Type_Current;
            hModel.latitude = model.lat;
            hModel.longtitude = model.lng;
            hModel.place_id = @"";
            hModel.locationName = [model locationNameWithCustomKey:self.countriesModel.current_country.place_display_fields];

            [UIAlertView showWithTitle:[LanguageManager stringForKey:@"Are you in {!location name}?" withPlaceHolder:@{@"{!location name}":hModel.locationName?hModel.locationName:@""}]  message:LocalisedString(@"Would you like to set this as your current location?") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"No") otherButtonTitles:@[LocalisedString(@"Yes")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    if (self.homeLocationRefreshBlock) {
                        self.homeLocationRefreshBlock(hModel);
                    }
                }
            }];
           
        }

    }Error:nil];
}
-(void)getGoogleSearchPlaces
{
    self.userLocation = [self.searchManager getAppLocation];

    CountryModel* model = self.countriesModel.current_country;
    [self.searchManager getSearchLocationFromGoogle:self.userLocation Country:model.country_code input:self.ibSearchTxtField.text completionBlock:^(id object) {
        if (object) {
            self.searchModel = [[DataManager Instance] googleSearchModel];
            [self.ibSearchTable reloadData];
        }
    }];
    
}

-(void)requestServerForCountry
{
    if (isMiddleOfRequestingCountry) {
        return;
    }
    
    NSDictionary* dict = @{@"language_code":ENGLISH_CODE};
    
    isMiddleOfRequestingCountry = YES;
    
    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetHomeCountry parameter:dict appendString:nil success:^(id object) {
        isMiddleOfRequestingCountry = NO;

        self.countriesModel = [[ConnectionManager dataManager]countriesModel];
        [self.arrCountries addObjectsFromArray:self.countriesModel.countries];
        
        [self.ibCountryTable reloadData];
        
        @try {
            
            CountryModel* currentCountry = self.countriesModel.current_country;
            CountryModel* currentCountryFromList;

            for (int i = 0 ;i <self.arrCountries.count ;i++) {
                
                CountryModel* country = self.arrCountries[i];
                
                if (country.country_id == currentCountry.country_id) {
                    
                    currentCountryFromList = country;
                    
                    selectedIndex = i;
                    NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:i inSection:0];
                    
                    [self.ibCountryTable selectRowAtIndexPath:selectedCellIndexPath
                                                     animated:NO
                                               scrollPosition:UITableViewScrollPositionNone];
                    

                    break;

                }
            }
            
            if (!currentCountryFromList) {
                currentCountryFromList = self.arrCountries[0];
                selectedIndex = 0;
                NSIndexPath* selectedCellIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                
                [self.ibCountryTable selectRowAtIndexPath:selectedCellIndexPath
                                                 animated:NO
                                           scrollPosition:UITableViewScrollPositionNone];
            }
            
            if ([Utils isArrayNull:currentCountryFromList.arrArea]) {
                [LoadingManager show];

                [self requestServerForCountryPlaces:currentCountryFromList];
            }
            else{
                [self.ibAreaTable reloadData];
            }

        }
        @catch (NSException *exception) {
            
        }
        
        
    } failure:^(id object) {
        isMiddleOfRequestingCountry = NO;

    }];
}

-(void)processPlaces:(AreaModel*)aModel ForCountry:(CountryModel*)cModel
{
    
    cModel.paging = aModel.paging;
    cModel.offset = aModel.offset;
    cModel.limit = aModel.limit;
    cModel.total_count = aModel.total_count;
    
    if (![Utils isArrayNull:aModel.result]) {
 
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
    }
    
}

-(void)requestServerForCountryPlaces:(CountryModel*)countryModel
{
    
    if (isMiddleOfRequesting) {
        return;
    }
    NSDictionary* dict = @{@"country_id":@(countryModel.country_id),
                           @"offset":@(countryModel.offset + countryModel.limit),
                           @"limit":@"10"};

    NSString* appendString = [NSString stringWithFormat:@"%i/places",countryModel.country_id];
    
    isMiddleOfRequesting = YES;
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetHomeCountryPlace parameter:dict appendString:appendString success:^(id object) {
        
        isMiddleOfRequesting = NO;
        NSDictionary* dict = object[@"data"];
       
        AreaModel* model = [[AreaModel alloc]initWithDictionary:dict error:nil];
        
        if (model) {
            [self processPlaces:model ForCountry:countryModel];
        }
        
        //[CrashlyticsKit setObjectValue:model forKey:@"AreaModel.object"];
        //[CrashlyticsKit setObjectValue:dict forKey:@"AreaModel.dict"];

      
        [self.ibAreaTable reloadData];
        [self.ibAreaTable setUserInteractionEnabled:YES];
        
    } failure:^(id object) {
        
    }];
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView {
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    
    if (self.ibAreaTable == scrollView) {
        
        if (isMiddleOfRequesting) {
            return;
        }
        
        if (maximumOffset - currentOffset <= self.ibAreaTable.frame.size.height/2) {
            
            NSIndexPath* countryIndexPath = self.ibCountryTable.indexPathForSelectedRow;
            
            CountryModel* model;
            @try {
                
                model = self.arrCountries[countryIndexPath.row];

            } @catch (NSException *exception) {
                
            }
            if(![Utils isStringNull:model.paging.next])
            {
                
                if (model) {
                    [self requestServerForCountryPlaces:model];

                }
            }
        }

    }

}

- (void)onTimerEvent:(NSTimer*)timer
{
    self.ibImgLocation.alpha = 0;

    [UIView animateWithDuration:1 animations:^{
        self.ibImgLocation.alpha = 1;

    }completion:^(BOOL finished){
        
        [UIView animateWithDuration:1 animations:^{
            self.ibImgLocation.alpha = 0;
            
        }];
         
    }];
    
}


-(void)startBlinkGPS
{
    [self.timer invalidate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onTimerEvent:) userInfo:nil repeats:YES];

}

-(void)stopBlinkGPS
{
    [self.timer invalidate];
    self.ibImgLocation.alpha = 1;

}


#pragma mark - Location Delegate

#pragma mark - CLLocation Delegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking granting location access!");
            [self startSearchGPSLocation];
            
            // this will access location automatically if user granted access manually. and will not show apple's request alert twice. (Tested)
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User denied location access request!!");
            NSLog(@"To re-enable, please go to Settings and turn on Location Service for this app.");
            
            self.lblAutoDetect.textColor = TWO_ZERO_FOUR_COLOR;
            self.ibImgLocation.image = [UIImage imageNamed:@"SelectLocationAutoDetectIconDeactivated.png"];
            [self stopBlinkGPS];

            [self.manager stopUpdatingLocation];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            // clear text
            NSLog(@"Got Location");
            [self stopBlinkGPS];
            self.lblAutoDetect.textColor = ONE_ZERO_TWO_COLOR;
            self.ibImgLocation.image = [UIImage imageNamed:@"SelectLocationAutoDetectIcon.png"];
            [self.manager startUpdatingLocation]; //Will update location immediately
            

            if (_enableLocationViewController) {
                [self.enableLocationViewController dismissViewControllerAnimated:YES completion:nil];
                _enableLocationViewController = nil;
            }
        } break;
            
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.userLocation = locations[0];
    self.searchManager.GPSLocation = self.userLocation;
    [self stopBlinkGPS];
}

@end
