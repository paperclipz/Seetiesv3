//
//  CT3_SearchListingViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_SearchListingViewController.h"
#import "AddCollectionDataViewController.h"
#import "SeetiesShopViewController.h"

@interface CT3_SearchListingViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

}

@property(nonatomic,assign)SearchViewType searchType;

@property(nonatomic)SearchLocationDetailModel* googleLocationDetailModel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (weak, nonatomic) IBOutlet UIView *ibLocationView;
@property (weak, nonatomic) IBOutlet UITableView *ibLocationTableView;
@property (weak, nonatomic) IBOutlet UITextField *ibSearchText;
@property (weak, nonatomic) IBOutlet UITextField *ibLocationText;

@property(nonatomic,strong)SearchModel* searchModel;
@property (nonatomic,strong)CLLocation* location;
@property (nonatomic,strong)SearchManager* sManager;
@property(nonatomic,assign)ProfileViewType profileType;


@property(nonatomic,strong)SearchLTabViewController *shopListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *collectionListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *PostsListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *SeetizensListingTableViewController;

@property(nonatomic,strong)AddCollectionDataViewController* collectPostToCollectionVC;
@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic,strong)CollectionViewController* collectionViewController;
@property(nonatomic, strong)FeedV2DetailViewController* feedV2DetailViewController;
@property(nonatomic)EditCollectionViewController* editCollectionViewController;
@property(nonatomic)SeetiesShopViewController* seetiesShopViewController;

@end

@implementation CT3_SearchListingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self InitSelfView];
    self.sManager = [SearchManager Instance];
    self.ibSearchText.text = self.keyword;
    [self refreshSearch];
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
    self.ibSearchText.text = self.keyword;
    self.ibLocationText.text = self.locationName;
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.ibLocationText) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
     
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
        
       
        if (![Utils isStringNull:self.ibSearchText.text]) {
            [self refreshSearch];
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

//-(void)requestServerForSearchCollection:(NSString*)keyword
//{
//    CLLocation* location = [[SearchManager Instance]getAppLocation];
//    NSDictionary* dict = @{@"offset" : @"",
//                           @"limit" : @"",
//                           @"keyword" : keyword,
//                           @"token" : [Utils getAppToken],
//                           @"lat" : @(location.coordinate.latitude).stringValue,
//                           @"lng" : @(location.coordinate.longitude).stringValue,
//                           @"address_components" : @"",
//                           @"place_id" : @"",
//                           
//                           };
//    
//    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeSearchShops param:dict appendString:nil completeHandler:^(id object) {
//
//        
//    } errorBlock:^(id object) {
//        
//    }];
//}
-(void)getGoogleSearchPlaces
{
    [self.sManager getSearchLocationFromGoogle:self.location input:self.ibLocationText.text completionBlock:^(id object) {
        if (object) {
            self.searchModel = [[DataManager Instance]googleSearchModel];
            [self.ibLocationTableView reloadData];
            
        }
    }];
    
}
-(void)requestForGoogleMapDetails:(NSString*)placeID
{
    
    NSDictionary* dict = @{@"placeid":placeID,@"key":GOOGLE_API_KEY};
    
    [[ConnectionManager Instance] requestServerWithPost:NO customURL:GOOGLE_PLACE_DETAILS_API requestType:ServerRequestTypeGoogleSearchWithDetail param:dict completeHandler:^(id object) {
        
        SearchLocationDetailModel* googleSearchDetailModel = [[ConnectionManager dataManager] googleSearchDetailModel];
        
        RecommendationVenueModel* recommendationVenueModel  = [RecommendationVenueModel new];
        [recommendationVenueModel processGoogleModel:googleSearchDetailModel];
        
        self.googleLocationDetailModel = googleSearchDetailModel;

        self.locationLatitude = recommendationVenueModel.lat;
        self.locationLongtitude = recommendationVenueModel.lng;
        
        [self.ibSearchText resignFirstResponder];
        [self.ibLocationText resignFirstResponder];
        self.ibLocationView.hidden = YES;
        
       [self refreshSearch];
        
        
        //        if (self.didSelectOnLocationBlock) {
//            self.didSelectOnLocationBlock(recommendationVenueModel);
//        }
        
    } errorBlock:nil];
    
}

#pragma mark - Show View

-(void)showSeetieshopView:(SeShopDetailModel*)model
{
    _seetiesShopViewController = nil;
    
    if (![Utils isStringNull:model.seetishop_id]) {
        [self.seetiesShopViewController initDataWithSeetiesID:model.seetishop_id];
        [self.navigationController pushViewController:self.seetiesShopViewController animated:YES];

    }
    else if(![Utils isStringNull:model.post_id] && ![Utils isStringNull:model.post_id]){
        [self.seetiesShopViewController initDataPlaceID:model.place_id postID:model.post_id];
        [self.navigationController pushViewController:self.seetiesShopViewController animated:YES];

    }
}

-(void)showCollectionDisplayViewWithCollectionID:(CollectionModel*)colModel ProfileType:(ProfileViewType)profileType
{
    _collectionViewController = nil;
    if (self.profileType == ProfileViewTypeOwn) {
        [self.collectionViewController GetCollectionID:colModel.collection_id GetPermision:@"self" GetUserUid:colModel.user_info.uid];
        
    }
    else{
        
        [self.collectionViewController GetCollectionID:colModel.collection_id GetPermision:@"Others" GetUserUid:colModel.user_info.uid];
    }
    
    [self.navigationController pushViewController:self.collectionViewController animated:YES];
}

-(void)showEditCollectionViewWithCollection:(CollectionModel*)model
{
    _editCollectionViewController = nil;
    
    [self.editCollectionViewController initData:model.collection_id];
    
    [self.navigationController pushViewController:self.editCollectionViewController animated:YES];
}

#pragma mark - Declaration


-(SeetiesShopViewController*)seetiesShopViewController
{
    if (!_seetiesShopViewController) {
        _seetiesShopViewController = [SeetiesShopViewController new];
    }
    
    return _seetiesShopViewController;
}
-(EditCollectionViewController*)editCollectionViewController
{
    if (!_editCollectionViewController) {
        _editCollectionViewController = [EditCollectionViewController new];
    }
    
    return _editCollectionViewController;
}
-(SearchLTabViewController*)shopListingTableViewController{
    if(!_shopListingTableViewController)
    {
        _shopListingTableViewController = [SearchLTabViewController new];
        _shopListingTableViewController.searchListingType = SearchListingTypeShop;
        
        __weak typeof (self)weakSelf = self;
        _shopListingTableViewController.didSelectShopBlock = ^(SeShopDetailModel* model)
        {
            [weakSelf showSeetieshopView:model];
        };
    }
    return _shopListingTableViewController;
}
-(SearchLTabViewController*)collectionListingTableViewController{
    if(!_collectionListingTableViewController)
    {
        _collectionListingTableViewController = [SearchLTabViewController new];
        _collectionListingTableViewController.searchListingType = SearchsListingTypeCollections;
        // [_collectionListingTableViewController refreshRequestWithText:self.ibSearchText.text];
        __weak typeof (self)weakSelf = self;
        
        _collectionListingTableViewController.didSelectDisplayCollectionRowBlock = ^(CollectionModel* model)
        {
            // [weakSelf showCollectionDisplayViewWithCollectionID:model.collection_id ProfileType:ProfileViewTypeOthers];
            _collectionViewController = nil;
            [weakSelf.collectionViewController GetCollectionID:model.collection_id GetPermision:@"Others" GetUserUid:model.user_info.uid];
            [weakSelf.navigationController pushViewController:weakSelf.collectionViewController animated:YES];
        };
        _collectionListingTableViewController.didSelectEditDisplayCollectionRowBlock = ^(CollectionModel* model)
        {
        
            [weakSelf showEditCollectionViewWithCollection:model];
        };
        
        
    }
    return _collectionListingTableViewController;
}
-(SearchLTabViewController*)PostsListingTableViewController{
    if(!_PostsListingTableViewController)
    {
        _PostsListingTableViewController = [SearchLTabViewController new];
        _PostsListingTableViewController.searchListingType = SearchsListingTypePosts;
        
        // [_PostsListingTableViewController refreshRequest:self.ibSearchText.text Latitude:self.Getlat Longtitude:self.Getlong CurrentLatitude:self.GetCurrentlat CurrentLongtitude:self.GetCurrentLong];
        
        __weak typeof (self)weakSelf = self;
        
        _PostsListingTableViewController.didSelectPostsRowBlock = ^(NSString* postid)
        {
            _feedV2DetailViewController = nil;
            [weakSelf.feedV2DetailViewController GetPostID:postid];
            [weakSelf.navigationController pushViewController:weakSelf.feedV2DetailViewController animated:YES];
            
        };
        
        _PostsListingTableViewController.didSelectUserRowBlock = ^(NSString* userid)
        {
            _profileViewController = nil;
            [weakSelf.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:userid];
            [weakSelf.navigationController pushViewController:weakSelf.profileViewController animated:YES];
            
        };
        _PostsListingTableViewController.didSelectCollectionOpenViewBlock = ^(DraftModel* model)
        {
            _collectPostToCollectionVC = nil;
            [weakSelf.navigationController presentViewController:weakSelf.collectPostToCollectionVC animated:YES completion:^{
                PhotoModel*pModel;
                if (![Utils isArrayNull:model.arrPhotos]) {
                    pModel = model.arrPhotos[0];
                }
                [weakSelf.collectPostToCollectionVC GetPostID:model.post_id GetImageData:pModel.imageURL];
            }];
        };
    }
    return _PostsListingTableViewController;
}
-(SearchLTabViewController*)SeetizensListingTableViewController{
    if(!_SeetizensListingTableViewController)
    {
        _SeetizensListingTableViewController = [SearchLTabViewController new];
        _SeetizensListingTableViewController.searchListingType = SearchsListingTypeSeetizens;
        
        // [_SeetizensListingTableViewController refreshRequestWithText:self.ibSearchText.text];
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
-(FeedV2DetailViewController*)feedV2DetailViewController
{
    if(!_feedV2DetailViewController)
        _feedV2DetailViewController = [FeedV2DetailViewController new];
    
    return _feedV2DetailViewController;
}
-(ProfileViewController*)profileViewController
{
    if(!_profileViewController)
        _profileViewController = [ProfileViewController new];
    
    return _profileViewController;
}
-(CollectionViewController*)collectionViewController
{
    if (!_collectionViewController) {
        _collectionViewController = [CollectionViewController new];
    }
    
    return _collectionViewController;
}

-(AddCollectionDataViewController*)collectPostToCollectionVC
{
    if (!_collectPostToCollectionVC) {
        _collectPostToCollectionVC = [AddCollectionDataViewController new];
    }
    return _collectPostToCollectionVC;
}

#pragma mark Init Data

-(void)setSearchType:(SearchViewType)searchType
{
    self.searchType = searchType;
}

-(void)refreshSearch
{
    
    //[self.SeetizensListingTableViewController refreshRequestWithText:self.ibSearchText.text];
    
    switch (self.searchType) {
        default:
        case SearchViewTypeCoordinate:
          //  [self.PostsListingTableViewController refreshRequestWithCoordinate:self.ibSearchText.text Latitude:self.locationLatitude Longtitude:self.locationLongtitude];
          //  [self.collectionListingTableViewController refreshRequestWithCoordinate:self.ibSearchText.text Latitude:self.locationLatitude Longtitude:self.locationLongtitude];
            [self.shopListingTableViewController refreshRequestWithCoordinate:self.ibSearchText.text Latitude:self.locationLatitude Longtitude:self.locationLongtitude];
            
            break;
        case SearchViewTypePlaceID:
            [self.shopListingTableViewController refreshRequestShop:self.ibSearchText.text SeetieshopPlaceID:self.placeID];
            [self.collectionListingTableViewController refreshRequestShop:self.ibSearchText.text SeetieshopPlaceID:self.placeID];
            [self.PostsListingTableViewController refreshRequestWithCoordinate:self.ibSearchText.text Latitude:self.locationLatitude Longtitude:self.locationLongtitude];

            break;
        case SearchViewTypeTypeGoogleDetail:
            [self.PostsListingTableViewController refreshRequestWithGoogleDetail:self.ibSearchText.text googleDetails:self.googleLocationDetailModel];
            [self.collectionListingTableViewController refreshRequestWithGoogleDetail:self.ibSearchText.text googleDetails:self.googleLocationDetailModel];
            [self.shopListingTableViewController refreshRequestWithGoogleDetail:self.ibSearchText.text googleDetails:self.googleLocationDetailModel];


            break;
            
    }
   
}

@end
