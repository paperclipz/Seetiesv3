//
//  CT3_NewsFeedViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/31/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CT3_NewsFeedViewController.h"
#import "FeedTableViewCell.h"
#import "FeedSquareCollectionViewCell.h"
#import "QuickBrowserCollectionTableViewCell.h"
#import "FeedType_FollowingPostTblCell.h"
#import "FeedType_Two_TableViewCell.h"

#define NUMBER_OF_SECTION 2
@interface CT3_NewsFeedViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
/*IBOUTLET*/
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) IBOutlet UIView *ibHeaderView;
@property (weak, nonatomic) IBOutlet UICollectionView *ibIntroCollectionView;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantQuickBrowseHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *ibQuickBrowseCollectionView;


/* Model */
@property(nonatomic,strong)NSMutableArray* arrayNewsFeed;
/* Model */

@end

@implementation CT3_NewsFeedViewController
- (IBAction)btnLoginClicked:(id)sender {
    
    
    //use this block if feeds api return token session over or app not login
    if (self.btnLoginClickedBlock) {
        self.btnLoginClickedBlock();
    }
    
}
- (IBAction)btnTestCliked:(id)sender {
    
    [self.navigationController pushViewController:self.meViewController animated:YES];
}

-(void)refreshViewAfterLogin
{
    [self requestServerForNewsFeed];
}

#pragma mark - Declaration

-(NSMutableArray*)arrayNewsFeed
{
    if (!_arrayNewsFeed) {
        _arrayNewsFeed = [NSMutableArray new];
    }
    
    return _arrayNewsFeed;
}
-(CT3_MeViewController*)meViewController
{
    if (!_meViewController) {
        _meViewController = [CT3_MeViewController new];
    }
    return _meViewController;
}
#pragma mark - DEFAULT
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initSelfView];
    [self refreshViewAfterLogin];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.ibTableView reloadData];
}

-(void)initSelfView
{
    [self initTableViewDelegate];
    [self initCollectionViewDelegate];
    
    [self adjustView];
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    self.ibTableView.estimatedRowHeight = [FeedType_Two_TableViewCell getHeight];
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;

}

-(void)initCollectionViewDelegate
{

    self.ibIntroCollectionView.delegate = self;
    self.ibIntroCollectionView.dataSource = self;
    [self.ibIntroCollectionView registerClass:[FeedSquareCollectionViewCell class] forCellWithReuseIdentifier:@"FeedSquareCollectionViewCell"];
    
    [self.ibQuickBrowseCollectionView registerClass:[QuickBrowserCollectionTableViewCell class] forCellWithReuseIdentifier:@"QuickBrowserCollectionTableViewCell"];
    self.ibQuickBrowseCollectionView.delegate = self;
    self.ibQuickBrowseCollectionView.dataSource = self;
    self.ibQuickBrowseCollectionView.backgroundColor = [UIColor clearColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ADJUST VIEW

-(void)adjustView
{
    
    self.constantQuickBrowseHeight.constant = 42 + 105*(2);
    [self.ibHeaderView refreshConstraint];
    [self.ibHeaderView setHeight:(self.lastView.frame.size.height + self.lastView.frame.origin.y)];
    [self.ibTableView reloadData];
  // CGSize apple = [self.ibTableView intrinsicContentSize];
    
}

#pragma mark - Request Server

-(void)requestServerForNewsFeed
{
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"offset" : @"",
                           @"limit" : @"",
                           };
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetNewsFeed param:dict appendString:@"" completeHandler:^(id object) {
        
      //  NewsFeedModels* model = [[ConnectionManager dataManager] newsFeedModels];
      //  [self.arrayNewsFeed addObjectsFromArray:model.items];
        [self.ibTableView reloadData];
    } errorBlock:^(id object) {
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 0;
    }
    else{// this is newsfeed row count
       // return self.arrayNewsFeed.count;
        return 5;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int type = 1;
    
    switch (type) {
        case 1:
        {
            /*Following Post*/
            static NSString *CellIdentifier = @"Cell";
            FeedType_FollowingPostTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_FollowingPostTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
           // [cell initData:self.arrayNewsFeed[indexPath.row]];
          
            [cell refreshConstraint];
            
            
            //Configure cell
            return cell;

        }
            break;
        case 2:
        {
            /*Following Post*/
            static NSString *CellIdentifier = @"Cell";
            FeedType_Two_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_Two_TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            //Configure cell
            return cell;
            
        }
            break;

            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.ibHeaderView.frame.size.height;
    }
    else{
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.ibHeaderView;
    }
    else{
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTION;
}

#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView == self.ibIntroCollectionView) {
        return 1;

    }
    else{
        return 6;
    
    }
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.ibIntroCollectionView) {
        FeedSquareCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedSquareCollectionViewCell" forIndexPath:indexPath];
        return cell;

    }
    else{
    
        QuickBrowserCollectionTableViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuickBrowserCollectionTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    
}


@end
