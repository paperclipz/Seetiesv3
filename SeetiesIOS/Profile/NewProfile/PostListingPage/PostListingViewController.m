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
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic)NSMutableArray* arrPostListing;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) ProfilePostModel* userProfilePostModel;
@property (strong, nonatomic) ListingHeaderView* viewHeader;
@property (strong, nonatomic) ProfileModel* profileModel;
@property (assign, nonatomic) ProfileViewType profileType;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMore;

@end

@implementation PostListingViewController
- (IBAction)btnAddMoreClicked:(id)sender {
    
    if(_btnAddMorePostBlock)
    {
        self.btnAddMorePostBlock();

    }
}


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
    self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userProfilePostModel.userPostData.total_posts,LocalisedString(@"Posts")];
    self.lblTitle.text = LocalisedString(@"Posts");
    if (self.profileType == ProfileViewTypeOthers) {
        self.btnAddMore.hidden = YES;
    }
}

-(void)initTableViewWithDelegate
{
    
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[PostListingTableViewCell class] forCellReuseIdentifier:@"PostListingTableViewCell"];
}

-(void)initData:(ProfilePostModel*)model UserProfileModel:(ProfileModel*)profileModel ProfileViewType:(ProfileViewType)type
{
    self.profileType = type;
    self.userProfilePostModel = model;
    self.profileModel = profileModel;
    self.arrPostListing = [NSMutableArray arrayWithArray:self.userProfilePostModel.userPostData.posts];

}

#pragma mark - Declaration
-(FeedV2DetailViewController*)feedV2DetailViewController
{
    if (!_feedV2DetailViewController) {
        _feedV2DetailViewController = [FeedV2DetailViewController new];
    }
    
    return _feedV2DetailViewController;
    
}
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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return [ListingHeaderView getheight];
//}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    if (!_viewHeader) {
//        _viewHeader = [ListingHeaderView initializeCustomView];
//        
//        __weak typeof (self)wealSelf = self;
//        [_viewHeader setType:self.profileType==ProfileViewTypeOwn?ListingViewTypePostOwn:ListingViewTypePostOthers addMoreClicked:^{
//            
//            if (wealSelf.btnAddMorePostBlock) {
//                wealSelf.btnAddMorePostBlock();
//                SLog(@"Add More Clicked");
//
//            }
//        }totalCount:self.userProfilePostModel.userPostData.total_posts];
//    }
//    
//    return _viewHeader;
//}

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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _feedV2DetailViewController = nil;
    
    DraftModel* model = self.arrPostListing[indexPath.row];
    [self.navigationController pushViewController:self.feedV2DetailViewController animated:YES onCompletion:^{
        [_feedV2DetailViewController GetPostID:model.post_id];

    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 10;
        if(y >= h - reload_distance) {
            
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
    NSString* appendString = [NSString stringWithFormat:@"%@/posts",self.profileModel.uid];
    NSDictionary* dict = @{@"page":self.userProfilePostModel.userPostData.page?@(self.userProfilePostModel.userPostData.page + 1):@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken]
                           };
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserPosts param:dict appendString:appendString completeHandler:^(id object) {
        
        isMiddleOfCallingServer = false;
        
        self.userProfilePostModel = [[ConnectionManager dataManager]userProfilePostModel];
        
        [self.arrPostListing addObjectsFromArray:self.userProfilePostModel.userPostData.posts];
        
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userProfilePostModel.userPostData.total_posts,LocalisedString(@"Posts")];
        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        isMiddleOfCallingServer = false;

    }];
}


@end
