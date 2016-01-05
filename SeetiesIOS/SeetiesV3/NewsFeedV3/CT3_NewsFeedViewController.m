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

@interface CT3_NewsFeedViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
/*IBOUTLET*/
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) IBOutlet UIView *ibHeaderView;
@property (weak, nonatomic) IBOutlet UICollectionView *ibIntroCollectionView;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantQuickBrowseHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *ibQuickBrowseCollectionView;
@end

@implementation CT3_NewsFeedViewController
- (IBAction)btnTestCliked:(id)sender {
    
    [self.navigationController pushViewController:self.meViewController animated:YES];
}

#pragma mark - Declaration

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
  //  [self requestServerForNewsFeed];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    [self initTableViewDelegate];
    [self initCollectionViewDelegate];
    
    [self.ibHeaderView setHeight:self.lastView.frame.size.height + self.lastView.frame.origin.y];
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:@"FeedTableViewCell"];
    
    [self.ibQuickBrowseCollectionView registerClass:[QuickBrowserCollectionTableViewCell class] forCellWithReuseIdentifier:@"QuickBrowserCollectionTableViewCell"];
    self.ibQuickBrowseCollectionView.delegate = self;
    self.ibQuickBrowseCollectionView.dataSource = self;
}

-(void)initCollectionViewDelegate
{

    self.ibIntroCollectionView.delegate = self;
    self.ibIntroCollectionView.dataSource = self;
    [self.ibIntroCollectionView registerClass:[FeedSquareCollectionViewCell class] forCellWithReuseIdentifier:@"FeedSquareCollectionViewCell"];
    
    self.ibQuickBrowseCollectionView.delegate = self;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ADJUST VIEW

-(void)adjustView
{
    
}

#pragma mark - Request Server

-(void)requestServerForNewsFeed
{
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"offset" : @"",
                           @"limit" : @"",
                           };
    
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetNewsFeed param:dict appendString:@"" completeHandler:^(id object) {
        
    } errorBlock:^(id object) {
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 0;
    }
    else{
        return 20;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FeedTableViewCell" forIndexPath:indexPath];
    
    return cell;
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
    return 2;
}

#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView == self.ibIntroCollectionView) {
        return 10;

    }
    else{
        return 20;
    
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
