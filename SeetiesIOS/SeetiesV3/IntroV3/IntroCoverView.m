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
- (IBAction)btnNextClicked:(id)sender {
    
//    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.ibScrollView.contentOffset = CGPointMake((currentPage+1)*self.ibScrollView.frame.size.width,0);
//    } completion:NULL];
//    
    float width = CGRectGetWidth(self.ibScrollView.frame);
    float height = CGRectGetHeight(self.ibScrollView.frame);
    float newPosition = self.ibScrollView.contentOffset.x+width;
    CGRect toVisible = CGRectMake(newPosition, 0, width, height);
    
    [self.ibScrollView scrollRectToVisible:toVisible animated:YES];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initWithCoverViews:(NSArray*)views backgroundImages:(NSArray*)images
{
    self.arrBackGroundImages = images;
    self.arrCoverViews = views;
    
    
    [self loadCoverViews];
    //[self loadBackgroundImages];
    [self addBackgroundViews];
}

-(void)initDataAll
{
    self.arrBackgroundHome = @[];
}

-(void)initSelfView
{
    
    self.ibScrollView.delegate = self;
  

}

-(void)loadCoverViews
{
    if (self.arrCoverViews) {
        
        CGRect frame = [Utils getDeviceScreenSize];
        SLog(@"view frame: %f",frame.size.width);
        for (int i = 0; i<self.arrCoverViews.count; i++) {
            UIView* view = self.arrCoverViews[i];
            [view setX:(i*view.frame.size.width)];
            [self.ibScrollView addSubview:view];
        }
        SLog(@"scroll view frame: %f",self.ibScrollView.frame.size.width);
        
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
    return currentPage == currentPage + 1;
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
