//
//  PhotoListViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/3/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "PhotoListViewController.h"
#import "LikeListingCollectionViewCell.h"
#import "PhotoViewController.h"

@interface PhotoListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL isMiddleOfCallingServer;
}
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property(nonatomic,strong)PhotoViewController* photoVC;

// -------------------- MODEL -----------------------------//
@property(nonatomic,strong)NSMutableArray* arrImagesList;
@property(nonatomic,strong)SeShopPhotoModel* seShopPhotoModel;
@property(nonatomic,strong)NSString* seetiesID;
@property(nonatomic,strong)NSString* placeID;
@property(nonatomic,strong)NSString* postID;
// -------------------- MODEL -----------------------------//

@end

@implementation PhotoListViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initSelfView];
    [self requestServerForSeetiShopPhotos];

}

-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID
{
    self.seetiesID = seetiesID;
    self.placeID = placeID;
    self.postID = postID;
    
}

-(void)initSelfView
{
    [self initCollectionViewDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initCollectionViewDelegate
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[LikeListingCollectionViewCell class] forCellWithReuseIdentifier:@"LikeListingCollectionViewCell"];
}

#pragma mark- CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrImagesList.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LikeListingCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikeListingCollectionViewCell" forIndexPath:indexPath];
    [Utils setRoundBorder:cell.ibImageView color:OUTLINE_COLOR borderRadius:3.0f];

    SePhotoModel* model = self.arrImagesList[indexPath.row];
    [cell.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:model.imageURL] completed:nil];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   // LikeListingCollectionViewCell* cell = (LikeListingCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    _photoVC = nil;
    SLog(@"index row : %@",indexPath);
    [self.photoVC initData:self.arrImagesList scrollToIndexPath:indexPath];
    
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];

    [self.navigationController pushViewController:self.photoVC animated:NO onCompletion:^{
        [self.photoVC collectionViewSrollToIndexPath];

    }];

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect frame = [Utils getDeviceScreenSize];
    
    int remainSize = frame.size.width - 10;
    int numberOfCell = 3;
    
    float cellSize = roundf((remainSize/numberOfCell)-5);
    
    return CGSizeMake(cellSize, cellSize);
}

#pragma mark - Declaration
-(NSMutableArray*)arrImagesList
{
    if (!_arrImagesList) {
        _arrImagesList = [NSMutableArray new];
    }
    return _arrImagesList;
}

-(PhotoViewController*)photoVC
{
    if (!_photoVC) {
        _photoVC = [PhotoViewController new];
        __weak typeof (self)weakSelf = self;
        _photoVC.didPopViewControllerAtIndexPathBlock = ^(NSIndexPath* indexPath)
        {
            [weakSelf.ibCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        };
        _photoVC.triggerLoadMoreBlock = ^(void)
        {
            [weakSelf scrollViewRequestServerForPhotos];
        };
    }
    
    return _photoVC;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    float reload_distance = 10;
    if (bottomEdge >= scrollView.contentSize.height -  reload_distance) {
        
     //   [self scrollViewRequestServerForPhotos];
    }
}


-(void)scrollViewRequestServerForPhotos
{
    if (!isMiddleOfCallingServer) {
        
        if(![Utils isStringNull:self.seShopPhotoModel.next])
        {
            [self requestServerForSeetiShopPhotos];
        }
    }
}

-(void)requestServerForSeetiShopPhotos
{
    
    isMiddleOfCallingServer = YES;
    
    NSDictionary* dict;
    NSString* appendString;
    
    if (![Utils stringIsNilOrEmpty:self.seetiesID]) {
    
        dict = @{@"limit":@(LIKES_LIST_SIZE),
                 @"offset":@(self.seShopPhotoModel.offset + self.seShopPhotoModel.limit),
                 @"token":[Utils getAppToken],
                 };
        
        appendString = [NSString stringWithFormat:@"%@/photos",self.seetiesID];
    }
    else{
    
        dict = @{@"limit":@(LIKES_LIST_SIZE),
                 @"offset":@(self.seShopPhotoModel.offset + self.seShopPhotoModel.limit),
                 @"token":[Utils getAppToken],
                 @"post_id":self.postID
                 };
        
        appendString = [NSString stringWithFormat:@"%@/photos",self.placeID];

    }
    

    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetiShopPhoto param:dict appendString:appendString completeHandler:^(id object) {
        self.seShopPhotoModel = [[ConnectionManager dataManager]seShopPhotoModel];
        
        [self.arrImagesList addObjectsFromArray:self.seShopPhotoModel.photos];
        [self.ibCollectionView reloadData];
        
        if (self.photoVC) {
            [self.photoVC.ibCollectionView reloadData];
        }
        isMiddleOfCallingServer = NO;
    } errorBlock:^(id object) {
        
        isMiddleOfCallingServer = NO;

    }];
    
}


@end
