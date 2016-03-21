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
{
    CGRect searchViewFrame;

}
@property(nonatomic,strong)NSMutableArray* arrSeetiesList;

@property(nonatomic,strong)NSArray* nearbyVenues;
@property(nonatomic,strong)SearchModel* searchModel;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (nonatomic,strong)GMSPlacesClient* placesClient;
@property (nonatomic,strong)CLLocation* location;
@property (nonatomic,assign)SearchType type;
@property (nonatomic,strong)SearchManager* sManager;

@property (weak, nonatomic) IBOutlet UIView *ibSearchContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibContentSearchView;


@property (nonatomic, strong) LPGoogleFunctions *googleFunctions;

@property (nonatomic, strong) CAPSPageMenu *cAPSPageMenu;

@end

@implementation STSearchViewController

- (IBAction)btnBackClicked:(id)sender {
    
    SLog(@"btnBackClicked");
    [self.navigationController popViewControllerAnimated:YES];
      [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    self.sManager = [SearchManager Instance];

    self.location = [self.sManager getAppLocation];
    
    [self requestSearch];
}

-(void)initSelfView
{
    self.txtSearch.delegate = self;
    self.txtSearch.keyboardType = UIKeyboardTypeWebSearch;
    [self.txtSearch addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    
    [Utils setRoundBorder:self.ibContentSearchView color:[UIColor clearColor] borderRadius:5.0f];
    [self.ibSearchContentView addSubview:self.cAPSPageMenu.view];

    [self changeLanguage];

    searchViewFrame = self.cAPSPageMenu.view.frame;
}

-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Where is this?");
    self.txtSearch.placeholder = LocalisedString(@"Search for a place");
}

-(void)viewDidAppear:(BOOL)animated
{
    self.fourSquareSearchTableViewController.view.frame = CGRectMake(0, self.fourSquareSearchTableViewController.view.frame.origin.y, self.cAPSPageMenu.view.frame.size.width, self.cAPSPageMenu.view.frame.size.height- self.cAPSPageMenu.menuHeight);

    //[self setPageShowSingleView:YES];
}

-(void)setPageShowSingleView:(BOOL)isSingleView
{
    if (isSingleView) {
        self.cAPSPageMenu.controllerScrollView.scrollEnabled = NO;
        [self.cAPSPageMenu moveToPage:0];

        [UIView animateWithDuration:.3 animations:^{
            self.cAPSPageMenu.view.frame = CGRectMake(0, 0-self.cAPSPageMenu.menuHeight,  self.cAPSPageMenu.view.frame.size.width,  searchViewFrame.size.height + self.cAPSPageMenu.menuHeight);

        }completion:^(BOOL finished) {
        }];
    }
    else{
        self.cAPSPageMenu.controllerScrollView.scrollEnabled = YES;
        
        [UIView animateWithDuration:.3 animations:^{
            self.cAPSPageMenu.view.frame = CGRectMake(0, 0,  self.cAPSPageMenu.view.frame.size.width,  searchViewFrame.size.height);
            
        }completion:^(BOOL finished) {
        }];
        

    
    }
  }
-(CAPSPageMenu*)cAPSPageMenu
{
    if(!_cAPSPageMenu)
    {
        CGRect deviceFrame = [Utils getDeviceScreenSize];
        
        NSArray *controllerArray = @[self.seetiesSearchTableViewController,self.fourSquareSearchTableViewController, self.googleSearchTableViewController];
        NSDictionary *parameters = @{
                                     CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionSelectionIndicatorColor: DEVICE_COLOR,
                                     CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor],
                                     CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0],
                                     CAPSPageMenuOptionMenuHeight: @(40.0),
                                     CAPSPageMenuOptionMenuItemWidth: @(deviceFrame.size.width/3 - 20),
                                     CAPSPageMenuOptionCenterMenuItems: @(YES),
                                     CAPSPageMenuOptionUnselectedMenuItemLabelColor:TEXT_GRAY_COLOR,
                                     CAPSPageMenuOptionSelectedMenuItemLabelColor:DEVICE_COLOR,
                                         };

        _cAPSPageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.ibSearchContentView.frame.size.width, self.ibSearchContentView.frame.size.height) options:parameters];
        _cAPSPageMenu.view.backgroundColor = [UIColor whiteColor];
    }
    return _cAPSPageMenu;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setViewEdit
{
    self.placeViewType = PlaceViewTypeEdit;
}

-(void)setViewNew
{
    self.placeViewType = PlaceViewTypeNew;
}
-(void)initWithLocation:(CLLocation*)location
{
    [LoadingManager show];
   
    self.location = location;
    
}

-(void)refreshViewGoogle
{
    [self.googleSearchTableViewController.tableView reloadData];
}

-(void)refreshViewFourSquare
{
    [self.fourSquareSearchTableViewController.tableView reloadData];
}


-(void)refreshSeetiesSearch
{
    [self.seetiesSearchTableViewController.tableView reloadData];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int additionalCount = self.placeViewType==PlaceViewTypeNew?1:0;
    if(tableView == self.googleSearchTableViewController.tableView)
    {
        return self.searchModel.predictions.count+additionalCount;

    }
    else if (tableView == self.fourSquareSearchTableViewController.tableView){
        return self.nearbyVenues.count+additionalCount;

    }
    else{
        return self.arrSeetiesList.count+additionalCount;
    }
  }

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.googleSearchTableViewController.tableView) //==== GOOGLE ====
    {
        

        if (indexPath.row == self.searchModel.predictions.count && self.placeViewType == PlaceViewTypeNew) {
            
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
    else if (tableView == self.fourSquareSearchTableViewController.tableView){  //==== FOUR SQUARE ====
        
        STTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STTableViewCell class])];

        if (indexPath.row == self.nearbyVenues.count && self.placeViewType == PlaceViewTypeNew) {
            
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
    else{
        
        STTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STTableViewCell class])];
        
        if (indexPath.row == self.arrSeetiesList.count && self.placeViewType == PlaceViewTypeNew) {
            
            STAddNewTableViewCell *cell = (STAddNewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"STAddNewTableViewCell"];
            
            if (cell == nil) {
                cell = [[STAddNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STAddNewTableViewCell"];
                
            }
            
            return cell;
        }
        else{
            
            Location* locationModel = self.arrSeetiesList[indexPath.row];
            cell.lblSubTitle.text = locationModel.formatted_address;
            cell.lblTitle.text = locationModel.name;
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
    else if (tableView == self.seetiesSearchTableViewController.tableView){
        [self processDataForSeetiesLocation:indexPath];
    }
}

-(void)showAddNewPlaceView:(NSIndexPath*)indexPath
{
    // [self.addNewPlaceViewController initData:self.searchModel.predictions[indexPath.row]];
    //[self.navigationController pushViewController:self.addNewPlaceViewController animated:YES];
    
   // [self presentViewController:self.addNewPlaceViewController animated:YES completion:nil];

}

#pragma mark - UITextfield Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //self.cAPSPageMenu.view.frame = searchViewFrame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    _cAPSPageMenu.controllerScrollView.scrollEnabled = false;
//    if (textField.text.length>0) {
//        _cAPSPageMenu.menuScrollView.hidden = NO;
//        _cAPSPageMenu.controllerScrollView.scrollEnabled = YES;
//    }
//    else{
//        _cAPSPageMenu.menuScrollView.hidden = YES;
//        _cAPSPageMenu.controllerScrollView.scrollEnabled = false;
//    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    
   //3 [self setPageShowSingleView:textField.text.length>0?NO:YES];
    
    [self requestSearch];
    
}
#pragma mark - Declaration

-(NSMutableArray*)arrSeetiesList
{
    if (!_arrSeetiesList) {
        _arrSeetiesList = [NSMutableArray new];
    }
    
    return _arrSeetiesList;
}
-(SearchTableViewController*)seetiesSearchTableViewController
{
    if (!_seetiesSearchTableViewController) {
        _seetiesSearchTableViewController = [SearchTableViewController new];
        [_seetiesSearchTableViewController initTableViewWithDelegate:self];
        _seetiesSearchTableViewController.title = @"Seeties";
        _seetiesSearchTableViewController.type = SearchTypeSeeties;
    }
    
    return _seetiesSearchTableViewController;
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
        _fourSquareSearchTableViewController.title = @"Foursquare";
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
    
    Location* lModel = [Location new];
    
    [lModel processLocationFromVenue:model];
    lModel.type = SearchTypeFourSquare;

    if (self.didSelectOnLocationBlock) {
        self.didSelectOnLocationBlock(lModel);
    }
}

-(void)processDataForSeetiesLocation:(NSIndexPath*)indexPath
{
    Location* model = self.arrSeetiesList[indexPath.row];
    
    
    model.type = SearchTypeSeeties;
    if (self.didSelectOnLocationBlock) {
        self.didSelectOnLocationBlock(model);
    }
}


#pragma mark - Request Sever
-(void)requestForGoogleMapDetails:(NSString*)placeID
{
    
    NSDictionary* dict = @{@"placeid":placeID,@"key":GOOGLE_API_KEY};
    
    [[ConnectionManager Instance] requestServerWithPost:NO customURL:GOOGLE_PLACE_DETAILS_API requestType:ServerRequestTypeGoogleSearchWithDetail param:dict completeHandler:^(id object) {
        
        SearchLocationDetailModel* googleSearchDetailModel = [[DataManager Instance] googleSearchDetailModel];

        
        Location* lModel = [Location new];
        [lModel processLocationFromGoogleDetails:googleSearchDetailModel];
        lModel.type = SearchTypeGoogle;
        
        if (self.didSelectOnLocationBlock) {
            self.didSelectOnLocationBlock(lModel);
        }
        
    } errorBlock:nil];
    
}

-(void)getFourSquareSuggestionPlaces
{
    self.type = SearchTypeFourSquare;
    
    [self.sManager getSuggestedLocationFromFoursquare:self.location input:self.txtSearch.text completionBlock:^(id object) {
        
        self.nearbyVenues = [[[DataManager Instance]fourSquareVenueModel] items];
        
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

-(void)requestSeetiesSuggestedPlaces
{

    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"keyword" : self.txtSearch.text,
                           @"limit" : @(10),
                           };
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetPlacesSuggestion param:dict appendString:@"" completeHandler:^(id object) {
        
        
        SuggestedPlaceModel* model = [[ConnectionManager dataManager]suggestedPlaceModel];
        [self.arrSeetiesList addObjectsFromArray:model.result];
        [self refreshSeetiesSearch];
        
    } errorBlock:^(id object) {
        
    }];
}
#pragma server request
-(void)requestSearch
{
    if (![self.txtSearch.text isEqualToString:@""]) {
        [self getGoogleSearchPlaces];
    }
    [self getFourSquareSuggestionPlaces];
    [self requestSeetiesSuggestedPlaces];
}

@end
