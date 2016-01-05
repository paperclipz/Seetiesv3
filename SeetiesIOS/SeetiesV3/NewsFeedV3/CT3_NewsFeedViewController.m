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

@interface CT3_NewsFeedViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
/*IBOUTLET*/
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) IBOutlet UIView *ibHeaderView;
@property (weak, nonatomic) IBOutlet UICollectionView *ibIntroCollectionView;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@end

@implementation CT3_NewsFeedViewController

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
}

-(void)initCollectionViewDelegate
{

    self.ibIntroCollectionView.delegate = self;
    self.ibIntroCollectionView.dataSource = self;
    [self.ibIntroCollectionView registerClass:[FeedSquareCollectionViewCell class] forCellWithReuseIdentifier:@"FeedSquareCollectionViewCell"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedSquareCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedSquareCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}


@end
