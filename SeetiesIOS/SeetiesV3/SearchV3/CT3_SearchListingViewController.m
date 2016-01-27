//
//  CT3_SearchListingViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_SearchListingViewController.h"
@interface CT3_SearchListingViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

}
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (weak, nonatomic) IBOutlet UIView *ibLocationView;
@property (weak, nonatomic) IBOutlet UITableView *ibLocationTableView;
@property (weak, nonatomic) IBOutlet UITextField *ibSearchText;
@property (weak, nonatomic) IBOutlet UITextField *ibLocationText;

@property(nonatomic,strong)SearchModel* searchModel;
@property (nonatomic,strong)CLLocation* location;
@property (nonatomic,strong)SearchManager* sManager;


@end

@implementation CT3_SearchListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self InitSelfView];
    self.sManager = [SearchManager Instance];
    [self performSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)InitSelfView{
    //self.ibScrollView.contentSize = CGSizeMake(850, 50);
    
    self.ibLocationText.delegate = self;
    self.ibSearchText.delegate = self;
    self.ibSearchText.placeholder = LocalisedString(@"Search");
    self.ibLocationText.placeholder = LocalisedString(@"Add a location?");
    self.ibSearchText.text = self.SearchText;
    self.ibLocationText.text = self.LocationName;
    
    CGRect frame = [Utils getDeviceScreenSize];
    [self.ibScrollView setWidth:frame.size.width];
    [self.shopListingTableViewController.view setWidth:frame.size.width];
    [self.shopListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.shopListingTableViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width, self.ibScrollView.frame.size.height);
    
    [self.collectionListingTableViewController.view setWidth:frame.size.width];
    [self.collectionListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.collectionListingTableViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*2, self.ibScrollView.frame.size.height);
    self.ibScrollView.pagingEnabled = YES;
    [self.collectionListingTableViewController.view setX:self.shopListingTableViewController.view.frame.size.width];

    [self.PostsListingTableViewController.view setWidth:frame.size.width];
    [self.PostsListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.PostsListingTableViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*3, self.ibScrollView.frame.size.height);
    self.ibScrollView.pagingEnabled = YES;
    [self.PostsListingTableViewController.view setX:self.collectionListingTableViewController.view.frame.size.width*2];
    
    [self.SeetizensListingTableViewController.view setWidth:frame.size.width];
    [self.SeetizensListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.SeetizensListingTableViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*4, self.ibScrollView.frame.size.height);
    self.ibScrollView.pagingEnabled = YES;
    [self.SeetizensListingTableViewController.view setX:self.PostsListingTableViewController.view.frame.size.width*3];
    
}
- (IBAction)searchSegmentedControl:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            NSLog(@"Shops was selected");
            [self.ibScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 1:
            NSLog(@"Collection was selected");
            [self.ibScrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
            break;
        case 2:
            NSLog(@"Posts was selected");
            [self.ibScrollView setContentOffset:CGPointMake(self.view.frame.size.width * 2, 0) animated:YES];
            break;
        case 3:
            NSLog(@"Seetizens was selected");
            [self.ibScrollView setContentOffset:CGPointMake(self.view.frame.size.width * 3, 0) animated:YES];
            break;
        default:
            break;
    }
}
-(SearchLTabViewController*)shopListingTableViewController{
    if(!_shopListingTableViewController)
    {
        _shopListingTableViewController = [SearchLTabViewController new];
        _shopListingTableViewController.searchListingType = SearchListingTypeShop;
    }
    return _shopListingTableViewController;
}
-(SearchLTabViewController*)collectionListingTableViewController{
    if(!_collectionListingTableViewController)
    {
        _collectionListingTableViewController = [SearchLTabViewController new];
        _collectionListingTableViewController.searchListingType = SearchsListingTypeCollections;
    }
    return _collectionListingTableViewController;
}
-(SearchLTabViewController*)PostsListingTableViewController{
    if(!_PostsListingTableViewController)
    {
        _PostsListingTableViewController = [SearchLTabViewController new];
        _PostsListingTableViewController.searchListingType = SearchsListingTypePosts;
    }
    return _PostsListingTableViewController;
}
-(SearchLTabViewController*)SeetizensListingTableViewController{
    if(!_SeetizensListingTableViewController)
    {
        _SeetizensListingTableViewController = [SearchLTabViewController new];
        _SeetizensListingTableViewController.searchListingType = SearchsListingTypeSeetizens;
        __weak typeof (self)weakSelf = self;
        
        _SeetizensListingTableViewController.didSelectUserRowBlock = ^(NSString* userid)
        {
            _profileViewController = nil;
            [weakSelf.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:userid];
            [weakSelf.navigationController pushViewController:weakSelf.profileViewController animated:YES];
            
        };
    }
    return _SeetizensListingTableViewController;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.ibLocationText) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"newString is %@",newString);
        NSLog(@"found");
        if ([newString length] >= 2) {
           [self getGoogleSearchPlaces];
        }else{
            
        }
    }else if(textField == self.ibSearchText){
    }
    
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"The did begin edit method was called");
    if(textField == self.ibSearchText){
        NSLog(@"SearchTextField begin");
        self.ibLocationView.hidden = YES;
    }
    if (textField == self.ibLocationText) {
        NSLog(@"SearchAddressField begin");
        self.ibLocationView.hidden = NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [self.ibSearchText resignFirstResponder];
    [self.ibLocationText resignFirstResponder];
    self.ibLocationView.hidden = YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    
    [textField resignFirstResponder];
    if (textField == self.ibSearchText) {
        self.ibLocationView.hidden = YES;
        
        if ([self.ibSearchText.text length] == 0) {

        }else{
          //  [self requestServerForSearch];
 
        }
    }else if(textField == self.ibLocationText){
        if (![self.ibLocationText.text isEqualToString:@""]) {
            [self getGoogleSearchPlaces];
        }
    }

    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
     return self.searchModel.predictions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
//    
//    UILabel *ShowName = (UILabel *)[cell viewWithTag:100];
//    ShowName.text = [SearchLocationNameArray objectAtIndex:indexPath.row];
    
    SearchLocationModel* model = self.searchModel.predictions[indexPath.row];
    
    NSDictionary* dict = model.terms[0];
    
    cell.textLabel.text = dict[@"value"];
    cell.detailTextLabel.text = [model longDescription];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self processDataForGoogleLocation:indexPath];
}

-(void)getGoogleSearchPlaces
{
    [self.sManager getSearchLocationFromGoogle:self.location input:self.ibLocationText.text completionBlock:^(id object) {
        if (object) {
            self.searchModel = [[DataManager Instance]googleSearchModel];
            [self refreshViewGoogle];
        }
    }];
    
}
-(void)refreshViewGoogle
{
    
    [self.ibLocationTableView reloadData];
}
-(void)initWithLocation:(CLLocation*)location
{
    [LoadingManager show];
    // must go throught this mark inorder to have location.
    
    self.location = location;
    
}
-(void)performSearch
{
    if(!self.location)
    {
        
        [self.sManager getCoordinateFromGPSThenWifi:^(CLLocation *currentLocation) {
            
            self.location = currentLocation;
            [self getGoogleSearchPlaces];
            
            
        } errorBlock:^(NSString *status) {
            
            [TSMessage showNotificationInViewController:self title:@"system" subtitle:@"No Internet Connection" type:TSMessageNotificationTypeWarning];
            [LoadingManager hide];
        }];
    }
    else{
        SLog(@"error no location");
      //  [self requestSearch];
        [LoadingManager hide];
        
    }
    
}
#pragma mark - location API
-(void)processDataForGoogleLocation:(NSIndexPath*)indexPath
{
    
    DataManager* manager = [DataManager Instance];
    SearchLocationModel* model = manager.googleSearchModel.predictions[indexPath.row];
    [self requestForGoogleMapDetails:model.place_id];
    
    NSDictionary* dict = model.terms[0];
    self.ibLocationText.text = dict[@"value"];
    
}
#pragma mark - Request Sever
-(void)requestForGoogleMapDetails:(NSString*)placeID
{
    
    NSDictionary* dict = @{@"placeid":placeID,@"key":GOOGLE_API_KEY};
    
    [[ConnectionManager Instance] requestServerWithPost:NO customURL:GOOGLE_PLACE_DETAILS_API requestType:ServerRequestTypeGoogleSearchWithDetail param:dict completeHandler:^(id object) {
        
        SearchLocationDetailModel* googleSearchDetailModel = [[DataManager Instance] googleSearchDetailModel];
        
        RecommendationVenueModel* recommendationVenueModel  = [RecommendationVenueModel new];
        SLog(@"recommendationVenueModel == %@",recommendationVenueModel);
        [recommendationVenueModel processGoogleModel:googleSearchDetailModel];
        [self.ibSearchText resignFirstResponder];
        [self.ibLocationText resignFirstResponder];
        self.ibLocationView.hidden = YES;
//        if (self.didSelectOnLocationBlock) {
//            self.didSelectOnLocationBlock(recommendationVenueModel);
//        }
        
    } errorBlock:nil];
    
}
-(ProfileViewController*)profileViewController
{
    if(!_profileViewController)
        _profileViewController = [ProfileViewController new];
    
    return _profileViewController;
}


@end
