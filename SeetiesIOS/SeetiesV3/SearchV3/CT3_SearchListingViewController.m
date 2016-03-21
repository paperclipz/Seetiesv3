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
#import "SearchComplexTableViewCell.h"
#import "SearchSimpleTableViewCell.h"
#import "DealHeaderView.h"
#import "UILabel+Exntension.h"
#import "DealDetailsViewController.h"

@interface CT3_SearchListingViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

}

@property(nonatomic)SearchLocationDetailModel* googleLocationDetailModel;

@property (weak, nonatomic) IBOutlet UIView *ibContentView;
@property (strong, nonatomic) IBOutlet UITableView *ibSearchTableView;
@property (weak, nonatomic) IBOutlet UITableView *ibLocationTableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (weak, nonatomic) IBOutlet UITextField *ibSearchText;
@property (weak, nonatomic) IBOutlet UITextField *ibLocationText;
@property (weak, nonatomic) IBOutlet UIView *ibSearchContentView;

@property (weak, nonatomic) IBOutlet UIView *ibLocationContentView;

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

@property(nonatomic)HomeLocationModel* homeLocationModel;
@property(nonatomic)DealDetailsViewController* dealDetailsViewController;

@property(nonatomic)NSArray* arrSimpleTagList;
@property(nonatomic)NSArray* arrComplexTagList;

@end

@implementation CT3_SearchListingViewController

#pragma mark - Initialization

-(void)initData:(HomeLocationModel*) model
{
    self.homeLocationModel = model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self InitSelfView];
    
    self.location = [[SearchManager Instance] getAppLocation];

    self.sManager = [SearchManager Instance];
    
    _homeLocationModel = nil;
    self.homeLocationModel.locationName = self.locationName;
    self.homeLocationModel.latitude = self.locationLatitude;
    self.homeLocationModel.longtitude = self.locationLongtitude;
    self.homeLocationModel.place_id = self.placeID;
    self.homeLocationModel.dictAddressComponent = self.addressComponent;
    self.ibSearchText.text = self.keyword;
    
    
    [self refreshSearch];
    
    self.ibLocationTableView.hidden = YES;
    self.ibSearchTableView.hidden = YES;
  
//    [self.ibContentView addSubview:self.ibLocationTableView];
//    [self.ibContentView addSubview:self.ibSearchTableView];
//
//    CGRect frame = [Utils getDeviceScreenSize];
//    self.ibLocationTableView.frame = CGRectMake(0, 0, frame.size.width, self.ibContentView.frame.size.height);
//    self.ibSearchTableView.frame = CGRectMake(0, 0, frame.size.width, self.ibContentView.frame.size.height);
    self.ibLocationTableView.delegate = self;
    self.ibLocationTableView.dataSource = self;
    self.ibSearchTableView.delegate = self;
    self.ibSearchTableView.dataSource = self;
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
    [self.ibSearchContentView setSideCurveBorder];
    [self.ibLocationContentView setSideCurveBorder];

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

#pragma mark - TextField Search
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.ibLocationText) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
     
        
        self.ibLocationTableView.hidden = NO;
        self.ibSearchTableView.hidden = YES;
        
        [self getGoogleSearchPlaces:newString];
    
    
    }else if(textField == self.ibSearchText){
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

        [self requestServerForTag:newString];
        
        self.ibSearchTableView.hidden = NO;
        self.ibLocationTableView.hidden = YES;

    }
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"The did begin edit method was called");
    if(textField == self.ibSearchText){
        NSLog(@"SearchTextField begin");
        self.ibLocationTableView.hidden = YES;
        self.ibSearchTableView.hidden = NO;

    }
    if (textField == self.ibLocationText) {
        NSLog(@"SearchAddressField begin");
        self.ibLocationTableView.hidden = NO;
        self.ibSearchTableView.hidden = YES;

    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [self.ibSearchText resignFirstResponder];
    [self.ibLocationText resignFirstResponder];
    self.ibLocationTableView.hidden = YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    
    [textField resignFirstResponder];
    if (textField == self.ibSearchText) {
        self.ibLocationTableView.hidden = YES;
        self.ibSearchTableView.hidden = YES;

       
        if (![Utils isStringNull:self.ibSearchText.text]) {
            [self refreshSearch];
            
        }

    }else if(textField == self.ibLocationText){
        if (![self.ibLocationText.text isEqualToString:@""]) {
            [self getGoogleSearchPlaces:textField.text];
        }
    }

    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.ibSearchTableView) {
        
        return 2;

    }
    else{
    
        return 1;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.ibSearchTableView) {
        
        DealHeaderView* view = [DealHeaderView initializeCustomView];
        view.btnSeeMore.hidden = YES;
        [view adjustToScreenWidth];
        [view prefix_addLowerBorder:OUTLINE_COLOR];
        [view.btnDeals.titleLabel setFont:[UIFont fontWithName:CustomFontNameBold size:15]];

        if (section == 0) {
            [view.btnDeals setTitle:LocalisedString(@"Suggested places") forState:UIControlStateNormal];
        }
        else{
            [view.btnDeals setTitle:LocalisedString(@"Suggested search") forState:UIControlStateNormal];
            
        }
        return view;

    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.ibSearchTableView) {
        return 52.0f;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.ibLocationTableView) {
        return self.searchModel.predictions.count;

    }
    else
    {
        if(section == 0)
        {
            return self.arrComplexTagList.count;
        }
        else{
            return self.arrSimpleTagList.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.ibLocationTableView) {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
            
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        
        SearchLocationModel* model = self.searchModel.predictions[indexPath.row];
        
        NSDictionary* dict = model.terms[0];
        
        cell.textLabel.text = dict[@"value"];
        cell.detailTextLabel.text = [model longDescription];
        cell.textLabel.textColor = TEXT_GRAY_COLOR;
        return cell;

    }
    
    else if(tableView == self.ibSearchTableView)
    {
        
        
        if(indexPath.section == 0)
        {
            SearchComplexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchComplexTableViewCell"];
            
            if (cell == nil) {
                cell = [[SearchComplexTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchComplexTableViewCell"];
                
            }
            
            @try {
                
                ComplexTagModel* cModel = self.arrComplexTagList[indexPath.row];
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@ > %@",cModel.tag,cModel.location.formatted_address];
                [cell.lblTitle boldSubstring:cModel.location.formatted_address];
            }
            
            @catch (NSException *exception) {
                SLog(@"");
            }

            return cell;
        }
        else{
            SearchSimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchSimpleTableViewCell"];
            
            if (cell == nil) {
                cell = [[SearchSimpleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchSimpleTableViewCell"];
                
            }
            
            @try {
                
                NSString* tag = self.arrSimpleTagList[indexPath.row];
                
                cell.lblTitle.text = tag;
            }
            
            @catch (NSException *exception) {
                SLog(@"");
            }
            @finally {
                
                cell.btnSuggestSearchClickedBlock = ^(void)
                {
                    NSString* tempString = self.arrSimpleTagList[indexPath.row];
                    self.ibSearchText.text = tempString;
                    [self requestServerForTag:tempString];
                    
                };
                return cell;
            }
        }
       

    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if(tableView == self.ibLocationTableView)
    {
        [self processDataForGoogleLocation:indexPath];

    }
    else if(tableView == self.ibSearchTableView)
    {
        if(indexPath.section == 0)
        {
            
            ComplexTagModel* model = self.arrComplexTagList[indexPath.row];
            
            _homeLocationModel = nil;
            
            self.homeLocationModel.latitude = model.location.lat;
            self.homeLocationModel.longtitude = model.location.lng;
            self.homeLocationModel.stringAddressComponent = model.location.address_components;
            self.ibLocationTableView.hidden = YES;
            self.ibSearchTableView.hidden = YES;

            [self refreshSearch];
        }
        else if (indexPath.section == 1)
        {
            
            self.ibLocationTableView.hidden = YES;
            self.ibSearchTableView.hidden = YES;
            
            NSString* tempString = self.arrSimpleTagList[indexPath.row];
            
            self.ibSearchText.text = tempString;
            
            [self refreshSearch];

        }
    }
        
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
            [self getGoogleSearchPlaces:self.ibLocationText.text];
            
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


-(void)requestServerForTag:(NSString*)tag
{
    NSDictionary* dict = @{@"token" : [Utils getAppToken]};
    
    NSString *tagStr = [tag stringByReplacingOccurrencesOfString:@" " withString:@""];

    //[LoadingManager show];
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetTagsSuggestion  param:dict appendString:tagStr completeHandler:^(id object) {
        
        self.arrSimpleTagList =[[NSMutableArray alloc]initWithArray:[[[ConnectionManager dataManager] tagModel] arrayTag] ];
        
        self.arrComplexTagList =[[NSMutableArray alloc]initWithArray:[[[ConnectionManager dataManager] tagModel] arrComplexTag] ];

        [self.ibSearchTableView reloadData];
        
    } errorBlock:^(id object) {
        
    }];
}
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
-(void)getGoogleSearchPlaces:(NSString*)input
{
    [self.sManager getSearchLocationFromGoogle:self.location input:input completionBlock:^(id object) {
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
        
        _homeLocationModel = nil;
        self.homeLocationModel.locationName = recommendationVenueModel.name;
        self.homeLocationModel.latitude = recommendationVenueModel.lat;
        self.homeLocationModel.longtitude = recommendationVenueModel.lng;
        self.homeLocationModel.address_components.country = recommendationVenueModel.country;
        self.homeLocationModel.address_components.route = recommendationVenueModel.route;
        self.homeLocationModel.address_components.locality = recommendationVenueModel.city;
        self.homeLocationModel.address_components.administrative_area_level_1 = recommendationVenueModel.state;
        self.homeLocationModel.dictAddressComponent = googleSearchDetailModel.address_components;

        [self.ibSearchText resignFirstResponder];
        [self.ibLocationText resignFirstResponder];
        self.ibLocationTableView.hidden = YES;
        
       [self refreshSearch];
        
        
        //        if (self.didSelectOnLocationBlock) {
//            self.didSelectOnLocationBlock(recommendationVenueModel);
//        }
        
    } errorBlock:nil];
    
}

#pragma mark - Show View

-(void)showDealDetailView:(DealModel*)model
{
    _dealDetailsViewController = nil;
    
    [self.dealDetailsViewController setDealModel:model];
    [self.navigationController pushViewController:self.dealDetailsViewController animated:YES onCompletion:^{
        
        [self.dealDetailsViewController setupView];
    }];
}

-(void)showSeetieshopView:(SeShopDetailModel*)model
{
    _seetiesShopViewController = nil;
    
    if (![Utils isStringNull:model.location.location_id]) {
        [self.seetiesShopViewController initDataWithSeetiesID:model.location.location_id];
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

-(DealDetailsViewController*)dealDetailsViewController
{
    if (!_dealDetailsViewController) {
        _dealDetailsViewController = [DealDetailsViewController new];
    }
    
    return _dealDetailsViewController;
}
-(HomeLocationModel*)homeLocationModel
{
    if (!_homeLocationModel) {
        _homeLocationModel = [HomeLocationModel new];
    }
    
    return _homeLocationModel;
}
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
        _shopListingTableViewController.didSelectDealBlock = ^(DealModel* model)
        {
            [weakSelf showDealDetailView:model];
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

-(void)refreshSearch
{
    
    [self.SeetizensListingTableViewController refreshRequestWithText:self.ibSearchText.text];
    [self.shopListingTableViewController refreshRequestWithModel:self.homeLocationModel Keyword:self.ibSearchText.text];
    [self.collectionListingTableViewController refreshRequestWithModel:self.homeLocationModel Keyword:self.ibSearchText.text];
    [self.PostsListingTableViewController refreshRequestWithModel:self.homeLocationModel Keyword:self.ibSearchText.text];
    
   
}

@end
