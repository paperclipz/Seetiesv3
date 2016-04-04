//
//  IntroCoverView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/24/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "IntroCoverView.h"

@interface IntroCoverView()
{
    int currentPage;
}
@property (nonatomic, strong) NSArray *backgroundViews;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrCoverHome;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrCoverWallet;

@property (strong, nonatomic) NSArray* arrBackgroundHome;
@property (strong, nonatomic) NSArray* arrBackgroundWallet;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation IntroCoverView
- (IBAction)btnSkipClicked:(id)sender {
   
    if (self.didEndClickedBlock) {
        self.didEndClickedBlock();
    }
}
- (IBAction)btnNextClicked:(id)sender {
    
//    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.ibScrollView.contentOffset = CGPointMake((currentPage+1)*self.ibScrollView.frame.size.width,0);
//    } completion:NULL];
//
    
    if (currentPage == self.arrCoverViews.count - 1) {
        if (self.didEndClickedBlock) {
            self.didEndClickedBlock();
            
            return;
        }
    }
    float width = CGRectGetWidth(self.ibScrollView.frame);
    float height = CGRectGetHeight(self.ibScrollView.frame);
    float newPosition = self.ibScrollView.contentOffset.x+width;
    CGRect toVisible = CGRectMake(newPosition, 0, width, height);
    
    [self.ibScrollView scrollRectToVisible:toVisible animated:YES];
    
}

-(void)initDataAll
{
    
    self.arrBackGroundImages = nil;
    self.arrCoverViews = nil;
    NSMutableArray* arraybackground = [[NSMutableArray alloc]initWithArray:self.arrBackgroundHome];
    [arraybackground addObjectsFromArray:self.arrBackgroundWallet];
    self.arrBackGroundImages = arraybackground;
    
    NSMutableArray* arrCoverVIew = [[NSMutableArray alloc]initWithArray:self.arrCoverHome];
    [arrCoverVIew addObjectsFromArray:self.arrCoverWallet];
    self.arrCoverViews = arrCoverVIew;
    [self loadCoverViews];
    [self addBackgroundViews];

}

-(void)initSelfView
{
    
    [self.btnNext setSideCurveBorder];
    self.ibScrollView.delegate = self;
  
    self.arrBackgroundHome = @[@"BgWalkLanding.jpg",@"BgWalkHome1.jpg",@"BgWalkHome2.jpg",@"BgWalkHome3.jpg",@"BgWalkHome4.jpg",@"BgWalkHome5.jpg"];
    self.arrBackgroundWallet = @[@"BgWalkWallet1.jpg",@"BgWalkWallet2.jpg",@"BgWalkWallet3.jpg"];
}

-(void)loadCoverViews
{
    if (self.arrCoverViews) {
        
        CGRect frame = [Utils getDeviceScreenSize];
        SLog(@"view frame: %f",frame.size.width);
        for (int i = 0; i<self.arrCoverViews.count; i++) {
            UIView* view = self.arrCoverViews[i];
            view.frame = frame;
            view.backgroundColor = [UIColor clearColor];
            [view setX:(i*view.frame.size.width)];
            [self.ibScrollView addSubview:view];
        }
        
        self.ibScrollView.contentSize = CGSizeMake(frame.size.width*self.arrCoverViews.count, frame.size.height);
    }
}

- (void)addBackgroundViews
{
    CGRect frame = [Utils getDeviceScreenSize];
    NSMutableArray *tmpArray = [NSMutableArray new];
    [[[[self arrBackGroundImages] reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:obj]];
        imageView.frame = frame;
        imageView.tag = idx + 1;
        [tmpArray addObject:imageView];
        [self.ibContentView addSubview:imageView];
    }];
    
    self.backgroundViews = [[tmpArray reverseObjectEnumerator] allObjects];
}
//
//-(void)loadBackgroundImages
//{
//    CGRect frame = [Utils getDeviceScreenSize];
//   
//    self.backgroundViews = [NSMutableArray new];
//        for (int i = self.arrBackGroundImages.count; i> 0; i--) {
//    
//            UIImageView* imageView = [[UIImageView alloc]initWithFrame:frame];
//            imageView.image = [UIImage imageNamed:self.arrBackGroundImages[i-1]];
//            [self.ibContentView addSubview:imageView];
//            [self.backgroundViews addObject:imageView];
//        }
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
    CGFloat alpha = 1 - ((scrollView.contentOffset.x - index * self.frame.size.width) / self.frame.size.width);

    if ([self.backgroundViews count] > index) {
        UIView *v = [self.backgroundViews objectAtIndex:index];
        if (v) {
            [v setAlpha:alpha];
        }
    }
    
    currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / [self numberOfPagesInPagingScrollView]);
    
    [self pagingScrollViewDidChangePages:scrollView];
}

- (BOOL)hasNext
{
    return currentPage > self.arrCoverViews.count - 1;
}
- (BOOL)isLast
{
    return currentPage == self.arrCoverViews.count - 1;
}

- (NSInteger)numberOfPagesInPagingScrollView
{
    return [[self arrCoverViews] count];
}

- (void)pagingScrollViewDidChangePages:(UIScrollView *)pagingScrollView
{
    if ([self isLast]) {
        
            [UIView animateWithDuration:0.4 animations:^{
                [self.btnNext setTitle:LocalisedString(@"Ok, Got it") forState:UIControlStateNormal];
            }];
    } else {
            [UIView animateWithDuration:0.4 animations:^{
                [self.btnNext setTitle:LocalisedString(@"Next") forState:UIControlStateNormal];

            }];
    }
}
@end
