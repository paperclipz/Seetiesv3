//
//  SearchViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "STSearchViewController.h"
#import "STTableViewCell.h"
#import "STAddNewTableViewCell.h"


@interface STSearchViewController ()

@property(nonatomic,strong)NSArray* nearbyVenues;
@property(nonatomic,strong)SearchModel* searchModel;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (nonatomic,strong)GMSPlacesClient* placesClient;
@property (nonatomic,strong)CLLocation* location;
@property (nonatomic,assign)SearchType type;
@property (nonatomic,strong)SearchManager* sManager;

@property (weak, nonatomic) IBOutlet UIView *ibSearchContentView;


@property (nonatomic, strong) LPGoogleFunctions *googleFunctions;

@property (nonatomic, strong) CAPSPageMenu *cAPSPageMenu;

@end

@implementation STSearchViewController
- (IBAction)btnAddNewPlaceClicked:(id)sender {
    
    if(self.btnAddNewPlaceBlock)
    {
        self.btnAddNewPlaceBlock(nil);
    }
}

- (IBAction)btnBackClicked:(id)sender {
    
    SLog(@"btnBackClicked");
    [self.navigationController popViewControllerAnimated:YES];
      [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    
    
}

-(void)initSelfView
{
    self.txtSearch.delegate = self;
    self.txtSearch.keyboardType = UIKeyboardTypeWebSearch;
    [self.txtSearch addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    
    
    [self.ibSearchContentView addSubview:self.cAPSPageMenu.view];


}

-(CAPSPageMenu*)cAPSPageMenu
{
    if(!_cAPSPageMenu)
    {
        CGRect deviceFrame = [Utils getDeviceScreenSize];
        
        NSArray *controllerArray = @[self.googleSearchTableViewController, self.fourSquareSearchTableViewController];
        NSDictionary *parameters = @{
                                     CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionSelectionIndicatorColor: [UIColor orangeColor],
                                     CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:13.0],
                                     CAPSPageMenuOptionMenuHeight: @(40.0),
                                     CAPSPageMenuOptionMenuItemWidth: @(deviceFrame.size.width/2),
                                     CAPSPageMenuOptionCenterMenuItems: @(YES)
                                     };

        _cAPSPageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.ibSearchContentView.frame.size.width, self.ibSearchContentView.frame.size.height) options:parameters];

    }
    return _cAPSPageMenu;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWithLocation:(CLLocation*)location
{
    
    // must go throught this mark inorder to have location.
    self.sManager = [SearchManager Instance];
    self.location = location;
    
    if(!self.location)
    {
        
        SLog(@"NO COORDINATE FOUND FOR IMAGE");

        [self.sManager getCoordinate:^(CLLocation *currentLocation) {
            
            self.location = currentLocation;
            [self requestSearch];

            
        } errorBlock:^(NSString *status) {
            SLog(@"NO COORDINATE FOUND FOR DEVICE GPS");
            
            [self.sManager getCoordinateFromWifi:^(CLLocation *currentLocation) {
                self.location = currentLocation;
                [self requestSearch];
            } errorBlock:^(NSString *status) {
                [self requestSearch];
            }];

        }];
    }
    else{
        [self requestSearch];
    }
        
}


-(void)getFourSquareSuggestionPlaces
{
  //  SLog(@"getFourSquareSuggestionPlaces");
    self.type = SearchTypeFourSquare;

#warning delete bottom 2 line for real time publish || this is for malaysia coordinate testing only
    CLLocation *locloc = [[CLLocation alloc] initWithLatitude:3.1333 longitude:101.7000];
    self.location = locloc;
        
    [self.sManager getSuggestedLocationFromFoursquare:self.location input:self.txtSearch.text completionBlock:^(id object) {

        self.nearbyVenues = [[[DataManager Instance]fourSquareVenueModel] items];
      //  self.nearbyVenues = [[DataManager Instance] fourSqureVenueList];

        [self refreshViewFourSquare];
    }];
    
   
}


-(void)getGoogleSearchPlaces
{
    self.type = SearchTypeGoogle;

    [self.sManager getSearchLocationFromGoogle:self.location input:self.txtSearch.text completionBlock:^(id object) {
        
        if (object) {
            self.searchModel = [[DataManager Instance]googleSearchModel];
            [self refreshViewGoogle];
        }
       

    }];

}
-(void)refreshViewGoogle
{
    
    [self.googleSearchTableViewController.tableView reloadData];
}

-(void)refreshViewFourSquare
{
    [self.fourSquareSearchTableViewController.tableView reloadData];
}
#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.googleSearchTableViewController.tableView)
    {
        return self.searchModel.predictions.count+1;

    }
    else{
        return self.nearbyVenues.count+1;

    }
  }

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.googleSearchTableViewController.tableView) //==== GOOGLE ====
    {
        

        if (indexPath.row == self.searchModel.predictions.count) {
            
            STAddNewTableViewCell *cell = (STAddNewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"STAddNewTableViewCell"];
            
            if (cell == nil) {
                cell = [[STAddNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STAddNewTableViewCell"];
            
            }
            
            return cell;
        }

        else
        {
            STTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STTableViewCell class])];
            
            SearchLocationModel* model = self.searchModel.predictions[indexPath.row];
            
            NSDictionary* dict = model.terms[0];
            cell.lblSubTitle.text = [model longDescription];
            cell.lblTitle.text = dict[@"value"];
            return cell;

        }
        
        
       
    }
    else{  //==== FOUR SQUARE ====
        
        STTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STTableViewCell class])];

        
        if (indexPath.row == self.nearbyVenues.count) {
            
            STAddNewTableViewCell *cell = (STAddNewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"STAddNewTableViewCell"];
            
            if (cell == nil) {
                cell = [[STAddNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STAddNewTableViewCell"];
                
            }
            
            return cell;
        }
        else{
        
            VenueModel* model = self.nearbyVenues[indexPath.row];
            
            cell.lblSubTitle.text = model.address;
            cell.lblTitle.text = model.name;
            return cell;

            
        }

        
       
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger numberOfRows = [tableView numberOfRowsInSection:[indexPath section]];
    if(indexPath.row+1 == numberOfRows)
    {
        self.btnAddNewPlaceBlock(nil);        
    }
    else if (self.googleSearchTableViewController.tableView==tableView) {
        [self processDataForGoogleLocation:indexPath];
    }
    else if (tableView == self.fourSquareSearchTableViewController.tableView){
        [self processDataForFourSquareVenue:indexPath];
    }
   
}

-(void)showAddNewPlaceView:(NSIndexPath*)indexPath
{
    // [self.addNewPlaceViewController initData:self.searchModel.predictions[indexPath.row]];
    //[self.navigationController pushViewController:self.addNewPlaceViewController animated:YES];
    
   // [self presentViewController:self.addNewPlaceViewController animated:YES completion:nil];

}

#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    

    [self requestSearch];
    
}

#pragma server request
-(void)requestSearch
{
    [self getGoogleSearchPlaces];
    [self getFourSquareSuggestionPlaces];
}

-(SearchTableViewController*)googleSearchTableViewController
{
    if(!_googleSearchTableViewController)
    {
        _googleSearchTableViewController = [SearchTableViewController new];
        [_googleSearchTableViewController initTableViewWithDelegate:self];
        _googleSearchTableViewController.title = @"Google";
        _googleSearchTableViewController.type = SearchTypeGoogle;
    }
    return _googleSearchTableViewController;
}

-(SearchTableViewController*)fourSquareSearchTableViewController
{
    if(!_fourSquareSearchTableViewController)
    {
        _fourSquareSearchTableViewController = [SearchTableViewController new];
        [_fourSquareSearchTableViewController initTableViewWithDelegate:self];
        _fourSquareSearchTableViewController.title = @"Four Square";
        _fourSquareSearchTableViewController.type = SearchTypeFourSquare;

    }
    return _fourSquareSearchTableViewController;
}

#pragma mark - location API
-(void)processDataForGoogleLocation:(NSIndexPath*)indexPath
{
   
    DataManager* manager = [DataManager Instance];
    SearchLocationModel* model = manager.googleSearchModel.predictions[indexPath.row];
    [self requestForGoogleMapDetails:model.place_id];
    
}


-(void)processDataForFourSquareVenue:(NSIndexPath*)indexPath
{
    
    VenueModel* model = [[DataManager Instance] fourSquareVenueModel].items[indexPath.row];
    RecommendationVenueModel* recommendationVenueModel = [RecommendationVenueModel new];
    [recommendationVenueModel processFourSquareModel:model];
    
    if (self.didSelectOnLocationBlock) {
        self.didSelectOnLocationBlock(recommendationVenueModel);
    }
}


#pragma mark - Request Sever
-(void)requestForGoogleMapDetails:(NSString*)placeID
{
    
    NSDictionary* dict = @{@"placeid":placeID,@"key":GOOGLE_API_KEY};
    
    [[ConnectionManager Instance] requestServerWithPost:NO customURL:GOOGLE_PLACE_DETAILS_API requestType:ServerRequestTypeGoogleSearchWithDetail param:dict completeHandler:^(id object) {
        
        
        SearchLocationDetailModel* googleSearchDetailModel = [[DataManager Instance] googleSearchDetailModel];

        RecommendationVenueModel* recommendationVenueModel  = [RecommendationVenueModel new];
        
        [recommendationVenueModel processGoogleModel:googleSearchDetailModel];

        if (self.didSelectOnLocationBlock) {
            self.didSelectOnLocationBlock(recommendationVenueModel);
        }
        
    } errorBlock:nil];
    
}
@end
