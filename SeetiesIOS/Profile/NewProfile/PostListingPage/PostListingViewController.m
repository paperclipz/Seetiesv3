//
//  PostListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/23/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "PostListingViewController.h"
#import "PostListingTableViewCell.h"
#import "ListingHeaderView.h"

@interface PostListingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isMiddleOfCallingServer;
}

@property (strong, nonatomic)NSMutableArray* arrPostListing;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) ProfilePostModel* userProfilePostModel;
@property (strong, nonatomic) ListingHeaderView* viewHeader;

@end

@implementation PostListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initSelfView
{
    [self initTableViewWithDelegate];

    
}

-(void)initTableViewWithDelegate
{
    
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[PostListingTableViewCell class] forCellReuseIdentifier:@"PostListingTableViewCell"];
}


-(void)initData:(ProfilePostModel*)model
{
    self.userProfilePostModel = model;
    
    self.arrPostListing = [NSMutableArray arrayWithArray:self.userProfilePostModel.userPostData.posts];

}

#pragma mark = Declaration
-(NSMutableArray*)arrPostListing
{
    if (!_arrPostListing) {
        _arrPostListing = [NSMutableArray new];
    }
    
    return _arrPostListing;
}

#pragma mark - UITableView

#pragma mark - Header

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [ListingHeaderView getheight];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
    if (!_viewHeader) {
        _viewHeader = [ListingHeaderView initializeCustomView];
        [_viewHeader setType:ListingViewTypePost addMoreClicked:^{
            
            SLog(@"Add More Clicked");
        }totalCount:self.userProfilePostModel.userPostData.total_posts];
    }
    
    return _viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PostListingTableViewCell getHeight];
}
#pragma mark - Row

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrPostListing.count;
}

#pragma mark - Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostListingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PostListingTableViewCell"];
    [cell initData:self.arrPostListing[indexPath.row]];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 0;
        if(y >= h + reload_distance) {
            
            if (!isMiddleOfCallingServer) {
                if (self.userProfilePostModel.userPostData.total_page > self.userProfilePostModel.userPostData.page) {
                    SLog(@"start to call server");
                    [self requestServerForUserPost];
                    
                }
            }
            

    
        }
}

#pragma mark - Request Server
-(void)requestServerForUserPost
{
    
    isMiddleOfCallingServer = true;
    NSString* appendString = [NSString stringWithFormat:@"%@/posts",[Utils getUserID]];
    NSDictionary* dict = @{@"page":self.userProfilePostModel.userPostData.page?@(self.userProfilePostModel.userPostData.page + 1):@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken]
                           };
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserPosts param:dict appendString:appendString completeHandler:^(id object) {
        
        isMiddleOfCallingServer = false;
        
        self.userProfilePostModel = [[ConnectionManager dataManager]userProfilePostModel];
        
        [self.arrPostListing addObjectsFromArray:self.userProfilePostModel.userPostData.posts];
        
        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        isMiddleOfCallingServer = false;

    }];
}


@end
