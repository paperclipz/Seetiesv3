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
#import "CAPSPageMenu.h"
#import "HMSegmentedControl.h"

@interface CT3_SearchListingViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

}

@property (weak, nonatomic) IBOutlet UIView *ibSegmentedControlView;
@property (nonatomic, strong) NSArray* arrViewControllers;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *ibSegmentedControlScrollView;

@property(nonatomic)SearchLocationDetailModel* googleLocationDetailModel;

@property (weak, nonatomic) IBOutlet UIView *ibContentView;
@property (strong, nonatomic) IBOutlet UITableView *ibSearchTableView;
@property (weak, nonatomic) IBOutlet UITableView *ibLocationTableView;

@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (weak, nonatomic) IBOutlet UITextField *ibSearchText;
@property (weak, nonatomic) IBOutlet UITextField *ibLocationText;
@property (weak, nonatomic) IBOutlet UIView *ibSearchContentView;

@property (weak, nonatomic) IBOutlet UIView *ibLocationContentView;

@property(nonatomic,strong)SearchModel* searchModel;
@property (nonatomic,strong)CLLocation* location;
@property (nonatomic,strong)SearchManager* sManager;
@property(nonatomic,assign)ProfileViewType profileType;

@property (nonatomic, strong) CAPSPageMenu *cAPSPageMenu;

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

@property(nonatomic) GeneralFilterViewController *shopFilterViewController;
@property(nonatomic) GeneralFilterViewController *collectionFilterViewController;
@property(nonatomic) PostFilterViewController *postFilterViewController;

@property(nonatomic)NSArray* arrSimpleTagList;
@property(nonatomic)NSArray* arrComplexTagList;
@property(nonatomic)FiltersModel *shopFilterModel;
@property(nonatomic)FiltersModel *collectionFilterModel;
@property(nonatomic)FiltersModel *postFilterModel;
@end

@implementation CT3_SearchListingViewController

#pragma mark - Initialization

-(void)initData:(HomeLocationModel*) model
{
    self.homeLocationModel = model;
}


-(void)viewDidAppear:(BOOL)animated
{
  //  [IQKeyboardManager sharedManager].enable = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self InitSelfView];
    
    self.location = [[SearchManager Instance] getAppLocation];

    self.sManager = [SearchManager Instance];
    
    [self.ibSearchText becomeFirstResponder];
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
    [self.ibContentView bringSubviewToFront:self.ibSearchTableView];
    [self.ibContentView bringSubviewToFront:self.ibLocationTableView];

    self.ibLocationTableView.delegate = self;
    self.ibLocationTableView.dataSource = self;
    self.ibSearchTableView.delegate = self;
    self.ibSearchTableView.dataSource = self;
    
    [self formatShopFilter];
    [self formatCollectionFilter];
    [self formatPostFilter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        vc.view.frame = CGRectMake(i*frame.size.width, 0, view.frame.size.width, self.ibSegmentedControlScrollView.frame.size.height);
    }

    view.contentSize = CGSizeMake(frame.size.width*arryViewControllers.count , view.frame.size.height);
    
    
    NSString* fontName;
    
    if ([[Utils getDeviceAppLanguageCode] isEqualToString:TAIWAN_CODE] ||
        [[Utils getDeviceAppLanguageCode] isEqualToString:CHINESE_CODE]) {
        fontName = @"PingFangTC-Regular";
    }
    else{
        fontName = CustomFontNameBold;
    }
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : TEXT_GRAY_COLOR,
                                                  NSFontAttributeName : [UIFont fontWithName:fontName size:14.0f]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ONE_ZERO_TWO_COLOR,
                                                  NSFontAttributeName : [UIFont fontWithName:fontName size:14.0f]};

    self.segmentedControl.sectionTitles = arrTitles;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.selectionIndicatorColor = DEVICE_COLOR;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    [contentView addSubview:self.segmentedControl];
    

    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
           [weakSelf.ibSegmentedControlScrollView scrollRectToVisible:CGRectMake(view.frame.size.width * index, 0, view.frame.size.width, view.frame.size.height) animated:YES];
    }];
}

-(void)InitSelfView{

    [self registerForKeyboardNotifications];

    
    self.arrViewControllers = @[self.shopListingTableViewController,self.collectionListingTableViewController,self.PostsListingTableViewController,self.SeetizensListingTableViewController];
    [self initSegmentedControlViewInView:self.ibSegmentedControlScrollView ContentView:self.ibSegmentedControlView ViewControllers:self.arrViewControllers];
    
    self.ibLocationText.delegate = self;
    self.ibSearchText.delegate = self;
    self.ibSearchText.placeholder = LocalisedString(@"Search");
    self.ibLocationText.placeholder = LocalisedString(@"Add a location?");
    self.ibSearchText.text = self.keyword;
    self.ibLocationText.text = self.locationName;
    [self.ibSearchContentView setSideCurveBorder];
    [self.ibLocationContentView setSideCurveBorder];

//    CGRect frame = [Utils getDeviceScreenSize];
//    [self.ibScrollView setWidth:frame.size.width];
//    [self.shopListingTableViewController.view setWidth:frame.size.width];
//    [self.shopListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
//    [self.ibScrollView addSubview:self.shopListingTableViewController.view];
//    self.ibScrollView.contentSize = CGSizeMake(frame.size.width, self.ibScrollView.frame.size.height);
//    
//    [self.collectionListingTableViewController.view setWidth:frame.size.width];
//    [self.collectionListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
//    [self.ibScrollView addSubview:self.collectionListingTableViewController.view];
//    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*2, self.ibScrollView.frame.size.height);
//    self.ibScrollView.pagingEnabled = YES;
//    [self.collectionListingTableViewController.view setX:self.shopListingTableViewController.view.frame.size.width];
//
//    [self.PostsListingTableViewController.view setWidth:frame.size.width];
//    [self.PostsListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
//    [self.ibScrollView addSubview:self.PostsListingTableViewController.view];
//    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*3, self.ibScrollView.frame.size.height);
//    self.ibScrollView.pagingEnabled = YES;
//    [self.PostsListingTableViewController.view setX:self.collectionListingTableViewController.view.frame.size.width*2];
//    
//    [self.SeetizensListingTableViewController.view setWidth:frame.size.width];
//    [self.SeetizensListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
//    [self.ibScrollView addSubview:self.SeetizensListingTableViewController.view];
//    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*4, self.ibScrollView.frame.size.height);
//    self.ibScrollView.pagingEnabled = YES;
//    [self.SeetizensListingTableViewController.view setX:self.PostsListingTableViewController.view.frame.size.width*3];
    
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

-(void)formatShopFilter{
    self.shopFilterModel = [[FiltersModel alloc] init];
    self.shopFilterModel.filterCategories = [[NSMutableArray<FilterCategoryModel> alloc] init];
    self.shopFilterModel.filterViewType = FilterViewTypeSearchShop;
    
    //Sort
    FilterCategoryModel *sortCategory = [[FilterCategoryModel alloc] init];
    sortCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    sortCategory.categoryName = LocalisedString(@"Sort by");
    sortCategory.filterCategoryType = FilterTypeSort;
    
    FilterModel *latest = [[FilterModel alloc] init];
    latest.name = LocalisedString(@"Latest");
    latest.isSelected = YES;
    latest.sortType = SortTypeMostRecent;
    
    FilterModel *distance = [[FilterModel alloc] init];
    distance.name = LocalisedString(@"Distance");
    distance.isSelected = NO;
    distance.sortType = SortTypeNearest;
    
    [sortCategory.filtersArray addObject:latest];
    [sortCategory.filtersArray addObject:distance];
    
    //Category
    FilterCategoryModel *catCategory = [[FilterCategoryModel alloc] init];
    catCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    catCategory.categoryName = LocalisedString(@"Category");
    catCategory.filterCategoryType = FilterTypeCat;
    
    HomeModel *homeModel = [[DataManager Instance] homeModel];
    for (QuickBrowseModel *quickBrowse in homeModel.quick_browse) {
        FilterModel *filter = [[FilterModel alloc] init];
        filter.name = quickBrowse.name;
        filter.filterId = quickBrowse.category_group_id;
        filter.isSelected = NO;
        [catCategory.filtersArray addObject:filter];
    }
    
    //IsOpen
    FilterCategoryModel *isOpenCategory = [[FilterCategoryModel alloc] init];
    isOpenCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    isOpenCategory.categoryName = LocalisedString(@"Now open");
    isOpenCategory.filterCategoryType = FilterTypeIsOpen;
    
    FilterModel *isOpenFilter = [[FilterModel alloc] init];
    isOpenFilter.name = LocalisedString(@"Now open");
    isOpenFilter.isSelected = NO;
    [isOpenCategory.filtersArray addObject:isOpenFilter];
    
    [self.shopFilterModel.filterCategories addObject:sortCategory];
    [self.shopFilterModel.filterCategories addObject:catCategory];
    [self.shopFilterModel.filterCategories addObject:isOpenCategory];
}

-(NSDictionary*)getShopFilter{
    int sort = 1;
    NSMutableString *catString = [[NSMutableString alloc] init];
    int isOpen = 0;
    for (FilterCategoryModel *filterCategory in self.shopFilterModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeSort:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        sort = (int)filter.sortType;
                    }
                }
            }
                break;
                
            case FilterTypeCat:
            {
                BOOL isFirst = YES;
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        if (isFirst) {
                            isFirst = NO;
                        }
                        else{
                            [catString appendString:@","];
                        }
                        
                        [catString appendString:filter.filterId];
                    }
                }
            }
                break;
                
            case FilterTypeIsOpen:
            {
                FilterModel *isOpenModel = filterCategory.filtersArray[0];
                isOpen = isOpenModel.isSelected? 1 : 0;
            }
                break;
                
            default:
                break;
        }
    }
    
    return @{@"sort": @(sort),
             @"category_group": catString,
             @"opening_now": @(isOpen)};
}

-(void)formatCollectionFilter{
    self.collectionFilterModel = [[FiltersModel alloc] init];
    self.collectionFilterModel.filterCategories = [[NSMutableArray<FilterCategoryModel> alloc] init];
    self.collectionFilterModel.filterViewType = FilterViewTypeSearchCollection;
    
    //Sort
    FilterCategoryModel *sortCategory = [[FilterCategoryModel alloc] init];
    sortCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    sortCategory.categoryName = LocalisedString(@"Sort by");
    sortCategory.filterCategoryType = FilterTypeSort;
    
    FilterModel *latest = [[FilterModel alloc] init];
    latest.name = LocalisedString(@"Latest");
    latest.isSelected = YES;
    latest.sortType = SortTypeMostRecent;
    
    FilterModel *popular = [[FilterModel alloc] init];
    popular.name = LocalisedString(@"Popular");
    popular.isSelected = NO;
    popular.sortType = SortTypeMostPopular;
    
    [sortCategory.filtersArray addObject:latest];
    [sortCategory.filtersArray addObject:popular];
    
    //Category
    FilterCategoryModel *catCategory = [[FilterCategoryModel alloc] init];
    catCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    catCategory.categoryName = LocalisedString(@"Category");
    catCategory.filterCategoryType = FilterTypeCat;
    
    HomeModel *homeModel = [[DataManager Instance] homeModel];
    for (QuickBrowseModel *quickBrowse in homeModel.quick_browse) {
        FilterModel *filter = [[FilterModel alloc] init];
        filter.name = quickBrowse.name;
        filter.filterId = quickBrowse.category_group_id;
        filter.isSelected = NO;
        [catCategory.filtersArray addObject:filter];
    }
    
    [self.collectionFilterModel.filterCategories addObject:sortCategory];
    [self.collectionFilterModel.filterCategories addObject:catCategory];
}

-(NSDictionary*)getCollectionFilter{
    int sort = 1;
    NSMutableString *catString = [[NSMutableString alloc] init];
    for (FilterCategoryModel *filterCategory in self.collectionFilterModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeSort:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        sort = (int)filter.sortType;
                    }
                }
            }
                break;
                
            case FilterTypeCat:
            {
                BOOL isFirst = YES;
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        if (isFirst) {
                            isFirst = NO;
                        }
                        else{
                            [catString appendString:@","];
                        }
                        
                        [catString appendString:filter.filterId];
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    return @{@"sort": @(sort),
             @"category_group": catString};
}

-(void)formatPostFilter{
    self.postFilterModel = [[FiltersModel alloc] init];
    self.postFilterModel.filterCategories = [[NSMutableArray<FilterCategoryModel> alloc] init];
    self.postFilterModel.filterViewType = FilterViewTypeSearchShop;
    
    //Sort
    FilterCategoryModel *sortCategory = [[FilterCategoryModel alloc] init];
    sortCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    sortCategory.categoryName = LocalisedString(@"Sort by");
    sortCategory.filterCategoryType = FilterTypeSort;
    
    FilterModel *popular = [[FilterModel alloc] init];
    popular.name = LocalisedString(@"Popular");
    popular.isSelected = YES;
    
    FilterModel *distance = [[FilterModel alloc] init];
    distance.name = LocalisedString(@"Distance");
    distance.isSelected = NO;
    distance.sortType = SortTypeNearest;
    
    [sortCategory.filtersArray addObject:popular];
    [sortCategory.filtersArray addObject:distance];
    
    //Category
    FilterCategoryModel *catCategory = [[FilterCategoryModel alloc] init];
    catCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    catCategory.categoryName = LocalisedString(@"Filter by");
    catCategory.filterCategoryType = FilterTypeCat;
    
    AppInfoModel *appInfoModel = [[DataManager Instance] appInfoModel];
    for (CategoryModel *categoryModel in appInfoModel.categories) {
        FilterModel *filter = [[FilterModel alloc] init];
        NSString *languageCode = [Utils getDeviceAppLanguageCode];
        NSString *name = categoryModel.single_line[languageCode];
        filter.name = name? name : @"";
        filter.filterId = [NSString stringWithFormat:@"%d", categoryModel.category_id];
        filter.isSelected = NO;
        filter.imageUrl = categoryModel.selectedImageUrl;
        filter.bgColorHexValue = categoryModel.background_color;
        [catCategory.filtersArray addObject:filter];
    }
    
    [self.postFilterModel.filterCategories addObject:sortCategory];
    [self.postFilterModel.filterCategories addObject:catCategory];
}

-(NSDictionary*)getPostFilter{
    int sort = 1;
    NSMutableString *catString = [[NSMutableString alloc] init];
    for (FilterCategoryModel *filterCategory in self.postFilterModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeSort:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        sort = (int)filter.sortType;
                    }
                }
            }
                break;
                
            case FilterTypeCat:
            {
                BOOL isFirst = YES;
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        if (isFirst) {
                            isFirst = NO;
                        }
                        else{
                            [catString appendString:@","];
                        }
                        
                        [catString appendString:filter.filterId];
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    return @{@"sort": @(sort),
             @"categories": catString};
}

-(void)applyFilterClicked:(FiltersModel*)filtersModel{
    [self refreshSearch];
}

-(void)postApplyFilterClicked:(FiltersModel*)filtersModel{
//    self.postFilterModel = filtersModel;
    [self refreshSearch];
}

-(void)resetAllFilters{
    //reset post filter
    for (FilterCategoryModel *filterCategory in self.postFilterModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeSort:
            {
                int count = 0;
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (count == 0) {
                        filter.isSelected = YES;
                    }
                    else{
                        filter.isSelected = NO;
                    }
                    count++;
                }
            }
                break;
                
            case FilterTypeCat:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    filter.isSelected = NO;
                }
            }
                break;
                
            default:
                break;
        }
    }
    self.postFilterViewController = nil;
    
    //reset shop filter
    for (FilterCategoryModel *filterCategory in self.shopFilterModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeSort:
            {
                int count = 0;
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (count == 0) {
                        filter.isSelected = YES;
                    }
                    else{
                        filter.isSelected = NO;
                    }
                    count++;
                }
            }
                break;
                
            case FilterTypeCat:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    filter.isSelected = NO;
                }
            }
                break;
                
            case FilterTypeIsOpen:
            {
                FilterModel *filter = filterCategory.filtersArray[0];
                filter.isSelected = NO;
            }
                
            default:
                break;
        }
    }
    self.shopFilterViewController = nil;
    
    //reset collection filter
    for (FilterCategoryModel *filterCategory in self.collectionFilterModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeSort:
            {
                int count = 0;
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (count == 0) {
                        filter.isSelected = YES;
                    }
                    else{
                        filter.isSelected = NO;
                    }
                    count++;
                }
            }
                break;
                
            case FilterTypeCat:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    filter.isSelected = NO;
                }
            }
                break;
                
            default:
                break;
        }
    }
    self.collectionFilterViewController = nil;
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
    if(textField == self.ibSearchText){
        self.ibLocationTableView.hidden = YES;
        self.ibSearchTableView.hidden = NO;

    }
    if (textField == self.ibLocationText) {
        NSLog(@"SearchAddressField begin");
        self.ibLocationTableView.hidden = NO;
        self.ibSearchTableView.hidden = YES;

    }
    
    textField.returnKeyType=UIReturnKeySearch;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [self.ibSearchText resignFirstResponder];
    [self.ibLocationText resignFirstResponder];
    self.ibLocationTableView.hidden = YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"textFieldShouldReturn:");
    
  //  [self.cAPSPageMenu moveToPage:0];
    
    [textField resignFirstResponder];
    if (textField == self.ibSearchText) {
        self.ibLocationTableView.hidden = YES;
        self.ibSearchTableView.hidden = YES;

       
        if (![Utils isStringNull:self.ibSearchText.text]) {
            [self resetAllFilters];
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

    [self.ibSearchText resignFirstResponder];
    [self.ibLocationText resignFirstResponder];
    
    if(tableView == self.ibLocationTableView)
    {
        [self processDataForGoogleLocation:indexPath];
        
        self.ibLocationTableView.hidden = YES;
        self.ibSearchTableView.hidden = YES;


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
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetTagsSuggestion parameter:dict appendString:tagStr success:^(id object) {
        
        self.arrSimpleTagList =[[NSMutableArray alloc]initWithArray:[[[ConnectionManager dataManager] tagModel] arrayTag] ];
        
        self.arrComplexTagList =[[NSMutableArray alloc]initWithArray:[[[ConnectionManager dataManager] tagModel] arrComplexTag] ];

        [self.ibSearchTableView reloadData];
        
    } failure:^(id object) {
        
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
    
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGoogleSearchWithDetail parameter:dict appendString:nil success:^(id object) {
        
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
        
    } failure:^(id object) {
    
    }];
}

#pragma mark - Show View

-(void)showDealDetailView:(DealModel*)model
{
    _dealDetailsViewController = nil;
    
    [self.dealDetailsViewController initDealModel:model];
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

-(CAPSPageMenu*)cAPSPageMenu
{
    if(!_cAPSPageMenu)
    {
        CGRect deviceFrame = [Utils getDeviceScreenSize];
        NSArray *controllerArray = @[self.shopListingTableViewController,self.collectionListingTableViewController,self.PostsListingTableViewController,self.SeetizensListingTableViewController];
        NSDictionary *parameters = @{
                                     CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionSelectionIndicatorColor: DEVICE_COLOR,
                                     CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor],
                                     CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0],
                                     CAPSPageMenuOptionMenuHeight: @(40.0),
                                     CAPSPageMenuOptionMenuItemWidth: @(deviceFrame.size.width/4 - 15),
                                     CAPSPageMenuOptionCenterMenuItems: @(YES),
                                     CAPSPageMenuOptionUnselectedMenuItemLabelColor:TEXT_GRAY_COLOR,
                                     CAPSPageMenuOptionSelectedMenuItemLabelColor:DEVICE_COLOR,
                                     };
        
        _cAPSPageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.ibContentView.frame.size.width, self.ibContentView.frame.size.height) options:parameters];
        _cAPSPageMenu.view.backgroundColor = [UIColor whiteColor];
       // _cAPSPageMenu.delegate = self;
    }
    return _cAPSPageMenu;
}


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
        _shopListingTableViewController.title = LocalisedString(@"Shops");
        _shopListingTableViewController.showFilter = YES;
        
        __weak typeof (self)weakSelf = self;

        _shopListingTableViewController.didSelectShopBlock = ^(SeShopDetailModel* model)
        {
            [weakSelf showSeetieshopView:model];
        };
        _shopListingTableViewController.didSelectDealBlock = ^(DealModel* model)
        {
            [weakSelf showDealDetailView:model];
        };
        _shopListingTableViewController.filterBtnClickedBlock = ^{
            [weakSelf presentViewController:weakSelf.shopFilterViewController animated:YES completion:nil];
        };
    }
    return _shopListingTableViewController;
}
-(SearchLTabViewController*)collectionListingTableViewController{
    if(!_collectionListingTableViewController)
    {
        _collectionListingTableViewController = [SearchLTabViewController new];
        _collectionListingTableViewController.searchListingType = SearchsListingTypeCollections;
        _collectionListingTableViewController.title = LocalisedString(@"Collection");
        _collectionListingTableViewController.showFilter = YES;

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
        _collectionListingTableViewController.filterBtnClickedBlock = ^{
            [weakSelf presentViewController:weakSelf.collectionFilterViewController animated:YES completion:nil];
        };
        
    }
    return _collectionListingTableViewController;
}
-(SearchLTabViewController*)PostsListingTableViewController{
    if(!_PostsListingTableViewController)
    {
        _PostsListingTableViewController = [SearchLTabViewController new];
        _PostsListingTableViewController.searchListingType = SearchsListingTypePosts;
        _PostsListingTableViewController.title = LocalisedString(@"Posts");
        _PostsListingTableViewController.showFilter = YES;

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
            [weakSelf.navigationController pushViewController:weakSelf.profileViewController animated:YES onCompletion:^{
                [weakSelf.profileViewController initDataWithUserID:userid];

            }];
            
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
        _PostsListingTableViewController.filterBtnClickedBlock = ^{
            [weakSelf presentViewController:weakSelf.postFilterViewController animated:YES completion:nil];
        };
    }
    return _PostsListingTableViewController;
}

-(SearchLTabViewController*)SeetizensListingTableViewController{
    if(!_SeetizensListingTableViewController)
    {
        _SeetizensListingTableViewController = [SearchLTabViewController new];
        _SeetizensListingTableViewController.searchListingType = SearchsListingTypeSeetizens;
        _SeetizensListingTableViewController.title = LocalisedString(@"People");

        // [_SeetizensListingTableViewController refreshRequestWithText:self.ibSearchText.text];
        __weak typeof (self)weakSelf = self;
        
        _SeetizensListingTableViewController.didSelectUserRowBlock = ^(NSString* userid)
        {
            _profileViewController = nil;
            [weakSelf.navigationController pushViewController:weakSelf.profileViewController animated:YES onCompletion:^{
                
                [weakSelf.profileViewController initDataWithUserID:userid];

            }];
            
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

-(GeneralFilterViewController *)shopFilterViewController{
    if (!_shopFilterViewController) {
        _shopFilterViewController = [GeneralFilterViewController new];
        [_shopFilterViewController initWithFilter:self.shopFilterModel];
        _shopFilterViewController.delegate = self;
    }
    return _shopFilterViewController;
}

-(GeneralFilterViewController *)collectionFilterViewController{
    if ((!_collectionFilterViewController)) {
        _collectionFilterViewController = [GeneralFilterViewController new];
        [_collectionFilterViewController initWithFilter:self.collectionFilterModel];
        _collectionFilterViewController.delegate = self;
    }
    return _collectionFilterViewController;
}

-(PostFilterViewController *)postFilterViewController{
    if (!_postFilterViewController) {
        _postFilterViewController = [PostFilterViewController new];
        [_postFilterViewController initWithFilter:self.postFilterModel];
        _postFilterViewController.delegate = self;
    }
    return _postFilterViewController;
}

#pragma mark Init Data

-(void)refreshSearch
{
    
    [self.SeetizensListingTableViewController refreshRequestWithText:self.ibSearchText.text];
    [self.shopListingTableViewController refreshRequestWithModel:self.homeLocationModel Keyword:self.ibSearchText.text filterDictionary:[self getShopFilter]];
    [self.collectionListingTableViewController refreshRequestWithModel:self.homeLocationModel Keyword:self.ibSearchText.text filterDictionary:[self getCollectionFilter]];
    [self.PostsListingTableViewController refreshRequestWithModel:self.homeLocationModel Keyword:self.ibSearchText.text filterDictionary:[self getPostFilter]];
    
   
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

#pragma mark - Keyboard ScrollView 

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.ibSearchTableView.contentInset = contentInsets;
    self.ibSearchTableView.scrollIndicatorInsets = contentInsets;
    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your application might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
//        [self.ibScrollView setContentOffset:scrollPoint animated:YES];
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.ibSearchTableView.contentInset = contentInsets;
    self.ibSearchTableView.scrollIndicatorInsets = contentInsets;
}

@end
