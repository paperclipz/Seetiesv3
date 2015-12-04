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
@property(nonatomic,strong)NSArray* arrImagesList;
// -------------------- MODEL -----------------------------//

@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initSelfView];
    [self requestServerForSeetiShopDetail];
    self.arrImagesList = @[@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png",@"1.png",@"2.png",@"3.png"];
    

}

-(void)initSelfView
{
    [self initTableViewDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableViewDelegate
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
    
    cell.ibImageView.image = [UIImage imageNamed:self.arrImagesList[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   // LikeListingCollectionViewCell* cell = (LikeListingCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self.photoVC initData:self.arrImagesList scrollToIndexPath:indexPath];
    
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];

    [self.navigationController pushViewController:self.photoVC animated:NO];
    [self.photoVC collectionViewSrollToIndexPath];

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect frame = [Utils getDeviceScreenSize];
    
    int numberOfCell = 3;
    
    float cellSize = roundf(frame.size.width/numberOfCell)  -10 - 5;
    
    return CGSizeMake(cellSize, cellSize);
}


#pragma mark - Declaration
-(PhotoViewController*)photoVC
{
    if (!_photoVC) {
        _photoVC = [PhotoViewController new];
        __weak typeof (self)weakSelf = self;
        _photoVC.didPopViewControllerAtIndexPathBlock = ^(NSIndexPath* indexPath)
        {
            [weakSelf.ibCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        };
    }
    
    return _photoVC;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    float reload_distance = 10;
    if (bottomEdge >= scrollView.contentSize.height -  reload_distance) {
        
        SLog(@"BOTTOM LIAO");

        if (!isMiddleOfCallingServer) {
            
//            if (self.profileLikeModel.userPostData.total_page > self.profileLikeModel.userPostData.page) {
//                SLog(@"start to call server");
//                [self requestServerForUserLikes];
//                
//            }
            
        }
    }
}

-(void)requestServerForSeetiShopDetail
{
    
    NSDictionary* param;
    NSString* appendString = @"56397e301c4d5be92e8b4711";
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetiShopDetail param:param appendString:appendString completeHandler:^(id object) {
        
        SLog(@"requestServerForSeetiShopDetail RESULT: %@",object);
        
    } errorBlock:^(id object) {
        
        
    }];
}

@end
