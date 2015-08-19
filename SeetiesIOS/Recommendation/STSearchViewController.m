//
//  SearchViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "STSearchViewController.h"
#import "STTableViewCell.h"


typedef enum
{
    SearchTypeGoogle = 1,
    SearchTypeFourSquare = 2
    
}SearchType;

@interface STSearchViewController ()

@property(nonatomic,strong)FourSquareModel* model;
@property (strong, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (nonatomic,strong)GMSPlacesClient* placesClient;
@property (nonatomic,strong)CLLocation* location;
@property (nonatomic,assign)SearchType type;
@property (nonatomic,strong)SearchManager* sManager;


@property(nonatomic,strong)SearchModel* searchModel;
@end

@implementation STSearchViewController
- (IBAction)btnBackClicked:(id)sender {
    
    SLog(@"btnBackClicked");
    [self.navigationController popViewControllerAnimated:YES];
    //  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
    
    
    
}


-(void)initSelfView
{
    [self initTableViewDelegate:self];
    self.txtSearch.delegate = self;
    self.txtSearch.keyboardType = UIKeyboardTypeWebSearch;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableViewDelegate:(id)delegate
{
    self.ibTableView.delegate = delegate;
    self.ibTableView.dataSource = delegate;
    [self.ibTableView registerClass:[STTableViewCell class] forCellReuseIdentifier:NSStringFromClass([STTableViewCell class])];
    
}

-(void)initWithLocation:(CLLocation*)location
{
    
    // must go throught this mark inorder to have location.
    self.sManager = [SearchManager Instance];
    self.location = location;
    
    if(!self.location)
    {
        [self.sManager getCoordinate:^(CLLocation *currentLocation) {
            
            self.location = currentLocation;
           
            [self getFourSquareSuggestionPlaces];

        } errorBlock:^(NSString *status) {
            SLog(@"cannot get Device location");
        }];
    }
    else{
        [self getFourSquareSuggestionPlaces];
        
    }
        
}


-(void)getFourSquareSuggestionPlaces
{
    SLog(@"getFourSquareSuggestionPlaces");
    self.type = SearchTypeFourSquare;
    [self.sManager getSuggestedLocationFromFoursquare:self.location completionBlock:^(id object) {
       FourSquareModel* model = [[FourSquareModel alloc]initWithDictionary:object error:nil];
        
        self.model = model;
        [self refreshView];
    }];
    
   
}


-(void)getGoogleSuggestedPlaces
{
    SLog(@"lat %f|| long %f",self.location.coordinate.latitude,self.location.coordinate.longitude);

    SLog(@"getGoogleSuggestedPlaces");
    [self.sManager getSuggestedLocationFromGoogle:self.location completionBlock:^(id object) {
        
        SearchModel* model = [[SearchModel alloc] initWithDictionary:object error:nil];
        self.searchModel = model;
        [self refreshView];
        
    }];
}

-(void)getGoogleSearchPlaces
{
    self.type = SearchTypeGoogle;

    [self.sManager getSearchLocationFromGoogle:self.location input:@"sea pa" completionBlock:^(id object) {
        
        SearchModel* model = [[SearchModel alloc] initWithDictionary:object error:nil];
        self.searchModel = model;
        [self refreshView];

    }];

}
-(void)refreshView
{
    [self.ibTableView reloadData];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    switch (self.type) {
        default:
        case SearchTypeGoogle:
            return self.searchModel.predictions.count;

            break;
        case SearchTypeFourSquare:
            return self.model.items.count;
            break;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STTableViewCell class])];
  
    switch (self.type) {
        case SearchTypeFourSquare:
        {
            VenueModel* model = self.model.items[indexPath.row];
            
            
            cell.lblSubTitle.text = model.address;
            cell.lblTitle.text = model.name;
        }
            break;

        default:
        case SearchTypeGoogle:
        {
            SearchLocationModel* model = self.searchModel.predictions[indexPath.row];
            
            NSDictionary* dict = model.terms[0];
            cell.lblSubTitle.text = [model longDescription];
            cell.lblTitle.text = dict[@"value"];
        }
            
            break;
    }

    return cell;
}
#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self placeAutocomplete];
    
    return YES;
}
- (void)placeAutocomplete {
    
    
    NSDictionary* dict = @{@"location":@"",@"input":@"",@"radius":@"5000",@"key":@"",@"type":@"address"};
    MKNetworkOperation *op = [[MKNetworkOperation alloc]initWithURLString:GOOGLE_PLACE_AUTOCOMPLETE_API params:dict httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
    }errorHandler:nil];
    
    
    
    
    
    SLog(@"google api key : %@",GOOGLE_API_KEY);
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    
    filter.type = kGMSPlacesAutocompleteTypeFilterCity;
    [[GMSPlacesClient sharedClient] autocompleteQuery:@"sky par"
                                               bounds:nil
                                               filter:filter
                                             callback:^(NSArray *results, NSError *error) {
                                                 if (error != nil) {
                                                     NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                                     return;
                                                 }
                                                 
                                                 for (GMSAutocompletePrediction* result in results) {
                                                     NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
                                                 }
                                                 
                                             }];
}

-(AddNewPlaceViewController*)addNewPlaceViewController
{
    if(!_addNewPlaceViewController)
    {
        _addNewPlaceViewController = [AddNewPlaceViewController new];
    }
    
    return _addNewPlaceViewController;
    
}

@end
