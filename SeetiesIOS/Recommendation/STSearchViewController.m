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
#import "HMSegmentedControl.h"


@interface STSearchViewController ()
{
    CGRect searchViewFrame;
    
    BOOL isMiddleLoadingServer;

}

// for segmented control

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray* arrViewControllers;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
// for segmented control

@property(nonatomic,strong)NSMutableArray* arrSeetiesList;
@property(nonatomic,strong)NSArray* nearbyVenues;
@property(nonatomic,strong)SearchModel* searchModel;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (nonatomic,strong)CLLocation* location;
@property (nonatomic,assign)SearchType type;
@property (nonatomic,strong)SearchManager* sManager;


// IBOUTLET
@property (weak, nonatomic) IBOutlet UIView *ibSearchContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibContentSearchView;
@property (nonatomic, strong) LPGoogleFunctions *googleFunctions;
@property (nonatomic, strong) SuggestedPlaceModel *suggestedPlaceModel;
// IBOUTLET


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
    
    isMiddleLoadingServer = NO;
    self.sManager = [SearchManager Instance];

    self.location = [self.sManager getAppLocation];
    
    [self requestSearch];
}

-(void)initSelfView
{

    // add segmented controls
    self.arrViewControllers = @[self.seetiesSearchTableViewController,self.googleSearchTableViewController,self.fourSquareSearchTableViewController];
    [self initSegmentedControlViewInView:self.ibScrollView ContentView:self.ibSearchContentView ViewControllers:self.arrViewControllers];
    
    self.txtSearch.delegate = self;
    self.txtSearch.keyboardType = UIKeyboardTypeWebSearch;
    [self.txtSearch addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    
    [Utils setRoundBorder:self.ibContentSearchView color:[UIColor clearColor] borderRadius:5.0f];

    [self changeLanguage];
}

-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Where is this?");
    self.txtSearch.placeholder = LocalisedString(@"Search for a place");
}

-(void)initSegmentedControlViewInView:(UIScrollView*)view ContentView:(UIView*)contentView ViewControllers:(NSArray*)arryViewControllers
{
    
    CGRect frame = [Utils getDeviceScreenSize];
    view.delegate = self;
    
    
    NSMutableArray* arrTitles = [NSMutableArray new];
    
    for (int i = 0; i<arryViewControllers.count; i++) {
        
        UIViewController* vc = arryViewControllers[i];
        [view addSubview:vc.view];
        [arrTitles addObject:vc.title];
        vc.view.frame = CGRectMake(i*frame.size.width, 0, view.frame.size.width, view.frame.size.height);
    }
    
    view.contentSize = CGSizeMake(frame.size.width*arryViewControllers.count , view.frame.size.height);
    
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : TEXT_GRAY_COLOR,
                                                  NSFontAttributeName : [UIFont fontWithName:CustomFontNameBold size:14.0f]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ONE_ZERO_TWO_COLOR,
                                                          NSFontAttributeName : [UIFont fontWithName:CustomFontNameBold size:14.0f]};
    
    self.segmentedControl.sectionTitles = arrTitles;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.selectionIndicatorColor = DEVICE_COLOR;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    [contentView addSubview:self.segmentedControl];
    
    
    //__weak typeof(self) weakSelf = view;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [view scrollRectToVisible:CGRectMake(view.frame.size.width * index, 0, view.frame.size.width, view.frame.size.height) animated:YES];
    }];
    
    
    
    
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
            
            cell.ibImgVerified.hidden = YES;
            SearchLocationModel* model = self.searchModel.predictions[indexPath.row];
            
            NSDictionary* dict = model.terms[0];
            cell.lblSubTitle.text = [model longDescription];
            cell.lblTitle.text = dict[@"value"];
            return cell;

        }
        
        
       
    }
    else if (tableView == self.fourSquareSearchTableViewController.tableView){  //==== FOUR SQUARE ====
        

        if (indexPath.row == self.nearbyVenues.count && self.placeViewType == PlaceViewTypeNew) {
            
            STAddNewTableViewCell *cell = (STAddNewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"STAddNewTableViewCell"];
            
            if (cell == nil) {
                cell = [[STAddNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STAddNewTableViewCell"];
                
            }
            
            return cell;
        }
        else{
            STTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STTableViewCell class])];

            cell.ibImgVerified.hidden = YES;

            VenueModel* model = self.nearbyVenues[indexPath.row];
            
            cell.lblSubTitle.text = model.address;
            cell.lblTitle.text = model.name;
            return cell;

        }

       
    }
    else{
        
        
        if (indexPath.row == self.arrSeetiesList.count && self.placeViewType == PlaceViewTypeNew) {
            
            STAddNewTableViewCell *cell = (STAddNewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"STAddNewTableViewCell"];
            
            if (cell == nil) {
                cell = [[STAddNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STAddNewTableViewCell"];
                
            }
            
            return cell;
        }
        else{
            
            STTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STTableViewCell class])];

            Location* locationModel = self.arrSeetiesList[indexPath.row];
            cell.lblSubTitle.text = locationModel.formatted_address;
            cell.lblTitle.text = locationModel.name;
            
            cell.ibImgVerified.hidden = !locationModel.is_collaborate;

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

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    _cAPSPageMenu.controllerScrollView.scrollEnabled = false;
////    if (textField.text.length>0) {
////        _cAPSPageMenu.menuScrollView.hidden = NO;
////        _cAPSPageMenu.controllerScrollView.scrollEnabled = YES;
////    }
////    else{
////        _cAPSPageMenu.menuScrollView.hidden = YES;
////        _cAPSPageMenu.controllerScrollView.scrollEnabled = false;
////    }
//    return YES;
//}

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
    
    [self requestForSeetishopDetails:model.location_id];
   }


#pragma mark - Request Sever for location Details
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
-(void)requestForSeetishopDetails:(NSString*)locationID
{
    
    NSDictionary* dict = @{@"seetishop_id":locationID,
                           @"token" : [Utils getAppToken]
                           };
    
    NSString* appendString = locationID;

    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetiShopDetail param:dict appendString:appendString completeHandler:^(id object) {
        
        SeShopDetailModel* model = [[ConnectionManager dataManager] seShopDetailModel];
        model.location.type = SearchTypeSeeties;
        
        if (self.didSelectOnLocationBlock) {
            self.didSelectOnLocationBlock(model.location);
        }

    } errorBlock:^(id object) {
        
        
    }];

    
}

#pragma mark - Reauest Server for location list
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
                           @"limit" : @(30),
                           };
    
  //  isMiddleLoadingServer = YES;
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetPlacesSuggestion param:dict appendString:@"" completeHandler:^(id object) {
        
        SuggestedPlaceModel* model = [[ConnectionManager dataManager]suggestedPlaceModel];
        self.suggestedPlaceModel = model;
        self.arrSeetiesList = nil;
        [self.arrSeetiesList addObjectsFromArray:model.result];
        [self refreshSeetiesSearch];
     //   isMiddleLoadingServer = NO;

    } errorBlock:^(id object) {
     //   isMiddleLoadingServer = NO;

    }];
}
#pragma server request

-(void)requestSearch
{
    _arrSeetiesList = nil;
    [self.seetiesSearchTableViewController.tableView reloadData];
    
    if (![self.txtSearch.text isEqualToString:@""]) {
        [self getGoogleSearchPlaces];
    }
    [self getFourSquareSuggestionPlaces];
    [self requestSeetiesSuggestedPlaces];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}



@end
