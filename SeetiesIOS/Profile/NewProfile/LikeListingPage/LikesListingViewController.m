//
//  LikesListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "LikesListingViewController.h"
#import "LikeListingCollectionViewCell.h"
#import "ListingHeaderView.h"


@interface LikesListingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL isMiddleOfCallingServer;

}

@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (weak, nonatomic) IBOutlet UIView *ibCollectionHeader;
@property (weak, nonatomic) ListingHeaderView *listingHeaderView;
@property (strong, nonatomic) NSMutableArray *arrLikesList;
@property (strong, nonatomic) ProfilePostModel *profileLikeModel;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *ibCollectionViewLayout;

@end

@implementation LikesListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self.ibCollectionView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initCollectionView
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[LikeListingCollectionViewCell class] forCellWithReuseIdentifier:@"LikeListingCollectionViewCell"];
    [self.ibCollectionView registerClass:[ListingHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ListingHeaderView"];
    [self.ibCollectionHeader addSubview:self.listingHeaderView];
    self.ibCollectionView.backgroundColor = [UIColor clearColor];
    
}

-(ListingHeaderView*)listingHeaderView
{
    if (!_listingHeaderView) {
        _listingHeaderView = [ListingHeaderView initializeCustomView];
        [_listingHeaderView adjustToScreenWidth];
    
        [_listingHeaderView setType:ListingViewTypeLikes addMoreClicked:^{
            
            SLog(@"Add More Clicked");
        }totalCount:self.profileLikeModel.userPostData.total_posts];

        
    }
    return _listingHeaderView;
}

-(void)initData:(ProfilePostModel*)model
{
    self.profileLikeModel = model;
    self.arrLikesList = [NSMutableArray arrayWithArray:self.profileLikeModel.userPostData.posts];
}

#pragma mark - Declaration
-(FeedV2DetailViewController*)feedV2DetailViewController
{
    if (!_feedV2DetailViewController) {
        _feedV2DetailViewController = [FeedV2DetailViewController new];
    }
    
    return _feedV2DetailViewController;
    
}

-(NSMutableArray*)arrLikesList
{

    if (!_arrLikesList) {
        _arrLikesList = [NSMutableArray new];
    }
    
    return _arrLikesList;
}
#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrLikesList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LikeListingCollectionViewCell* cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikeListingCollectionViewCell" forIndexPath:indexPath];
    
    DraftModel* draftModel = self.arrLikesList[indexPath.row];
    [cell initData:draftModel.arrPhotos[0]];
    
   
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _feedV2DetailViewController = nil;
    
    DraftModel* model = self.arrLikesList[indexPath.row];
    [self.navigationController pushViewController:self.feedV2DetailViewController animated:YES onCompletion:^{
        [_feedV2DetailViewController GetPostID:model.post_id];
        
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect frame = [Utils getDeviceScreenSize];
    
    int numberOfCell = 3;
    
    float cellSize = roundf(frame.size.width/numberOfCell)  -10 - 5;
    
    return CGSizeMake(cellSize, cellSize);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    float reload_distance = 10;
    if (bottomEdge >= scrollView.contentSize.height -  reload_distance) {

        
        if (!isMiddleOfCallingServer) {
            
            if (self.profileLikeModel.userPostData.total_page > self.profileLikeModel.userPostData.page) {
                SLog(@"start to call server");
                [self requestServerForUserLikes];
                
            }

        }
    }
}

#pragma mark - Request Server
-(void)requestServerForUserLikes
{
    isMiddleOfCallingServer = true;
    SLog(@"requestServerForUserLikes");
    NSString* appendString = [NSString stringWithFormat:@"%@/likes",self.userID];
  
    
    NSDictionary* dict = @{@"page":self.profileLikeModel.userPostData.page?@(self.profileLikeModel.userPostData.page + 1):@1,
                           @"list_size":@(LIKES_LIST_SIZE),
                           @"token":[Utils getAppToken]
                           };

    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserLikes param:dict appendString:appendString completeHandler:^(id object) {
        
        self.profileLikeModel = [[ConnectionManager dataManager]userProfileLikeModel];
        
        [self.arrLikesList addObjectsFromArray:self.profileLikeModel.userPostData.posts];
        
        [self.ibCollectionView reloadData];
        
        isMiddleOfCallingServer = false;

    } errorBlock:^(id object) {
        isMiddleOfCallingServer = false;

    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end