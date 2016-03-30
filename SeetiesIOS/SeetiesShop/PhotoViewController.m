//
//  PhotoViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/3/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIView+draggable.h"
#import "LikeListingCollectionViewCell.h"

@interface PhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate>
{
    CGFloat firstX;
    CGFloat firstY;
    NSIndexPath* currentIndexPath;
    BOOL isMiddleOfCallingServer;

    
}
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *draggableViews;


// --------------------- DATA ---------------------//
@property(nonatomic,strong)NSArray* arrImageList;
@end

@implementation PhotoViewController
- (IBAction)btnBackClicked:(id)sender {
 
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
    
    if (self.didPopViewControllerAtIndexPathBlock) {
        
        NSArray* currentPaths = [self.ibCollectionView indexPathsForVisibleItems];
        self.didPopViewControllerAtIndexPathBlock(currentPaths[0]);
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self changeLanguage];
    [self someMethod];
    [self initColletionViewDelegate];
    [self.ibCollectionView setNeedsUpdateConstraints];
    [self.ibCollectionView layoutIfNeeded];

}


-(void)initData:(NSArray*)array scrollToIndexPath:(NSIndexPath*)indexPath
{
    self.arrImageList = array;
    currentIndexPath = indexPath;
}

-(void)collectionViewSrollToIndexPath
{
    
    [self.ibCollectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self.ibCollectionView reloadData];

}

-(void)initColletionViewDelegate
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[LikeListingCollectionViewCell class] forCellWithReuseIdentifier:@"LikeListingCollectionViewCell"];
    self.ibCollectionView.pagingEnabled = YES;
    
    CGRect frame = [Utils getDeviceScreenSize];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.ibCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.ibCollectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (frame.size.width - 1);

    flowLayout.itemSize = CGSizeMake(availableWidthForCells, availableWidthForCells);
}

-(IBAction) someMethod {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.ibDragableView addGestureRecognizer:panRecognizer];
}

-(void)move:(id)sender {
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
    }
    
    translatedPoint = CGPointMake(firstX, firstY+ translatedPoint.y);
    
    [[sender view] setCenter:translatedPoint];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        CGFloat velocityY = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        
        CGFloat finalX = firstX;
        CGFloat finalY = translatedPoint.y + velocityY;// translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        CGRect frame = [Utils getDeviceScreenSize];
        if (finalY>frame.size.height || finalY<0) {
            
            [self btnBackClicked:sender];
        }
        else{
            
            finalX = firstX;
            finalY = firstY;
        }

        
        CGFloat animationDuration = (ABS(velocityY)*.0002)+.2;
        
      //  NSLog(@"the duration is: %f", animationDuration);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
       // [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrImageList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LikeListingCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikeListingCollectionViewCell" forIndexPath:indexPath];
    
    
    [cell setNoRoundBorder];
    [cell setNeedsUpdateConstraints];
    [cell layoutIfNeeded];

    SePhotoModel* model = self.arrImageList[indexPath.row];
 //   [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] completed:nil];
    [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.ibImageView.image = image;
    }];

    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    CGRect frame = [Utils getDeviceScreenSize];
//    
//    return CGSizeMake(frame.size.width, frame.size.width);
//}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.x + scrollView.frame.size.width;
    
    float reload_distance = 10;
    if (bottomEdge >= scrollView.contentSize.width -  reload_distance) {
        
        
        if (self.triggerLoadMoreBlock) {
            self.triggerLoadMoreBlock();
        }
    }
}

-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Swipe Up or Down to Close");
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
