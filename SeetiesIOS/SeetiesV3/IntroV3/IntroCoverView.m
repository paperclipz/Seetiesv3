//
//  IntroCoverView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/24/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "IntroCoverView.h"

#define walkthrough_key @"walkthrough"
@interface IntroCoverView()
{
    int currentPage;
    NSBundleResourceRequest* request;
}
@property (nonatomic, strong) NSArray *backgroundViews;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrCoverHome;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrCoverWallet;

@property (strong, nonatomic) NSArray* arrBackgroundHome;
@property (strong, nonatomic) NSArray* arrBackgroundWallet;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipThis;

@property (weak, nonatomic) IBOutlet UILabel *ibView0Title;
@property (weak, nonatomic) IBOutlet UILabel *ibView0Desc;
@property (weak, nonatomic) IBOutlet UILabel *ibView1Title;
@property (weak, nonatomic) IBOutlet UILabel *ibView1Desc;
@property (weak, nonatomic) IBOutlet UILabel *ibView2Title;
@property (weak, nonatomic) IBOutlet UILabel *ibView2Desc;
@property (weak, nonatomic) IBOutlet UILabel *ibView3Title;
@property (weak, nonatomic) IBOutlet UILabel *ibView3Desc;
@property (weak, nonatomic) IBOutlet UILabel *ibView4Title;
@property (weak, nonatomic) IBOutlet UILabel *ibView4Desc;
@property (weak, nonatomic) IBOutlet UILabel *ibView5Title;
@property (weak, nonatomic) IBOutlet UILabel *ibView5Desc;
@property (weak, nonatomic) IBOutlet UILabel *ibView6Title;
@property (weak, nonatomic) IBOutlet UILabel *ibView6Desc;
@property (weak, nonatomic) IBOutlet UILabel *ibView7Title;
@property (weak, nonatomic) IBOutlet UILabel *ibView7Desc;
@property (weak, nonatomic) IBOutlet UILabel *ibView8Title;
@property (weak, nonatomic) IBOutlet UILabel *ibView8Desc;
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
    [self.btnNext setTitle:LocalisedString(@"Next") forState:UIControlStateNormal];
    
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
    
    NSSet *tagsSet = [NSSet setWithObjects:walkthrough_key, nil];
    
    
    [LoadingManager show];
    request = [[NSBundleResourceRequest alloc] initWithTags:tagsSet];
    
    
    [request beginAccessingResourcesWithCompletionHandler:^(NSError * __nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Loaded On Demand Resource
            // Modify UI here as needed
            self.arrBackgroundHome = @[@"BgWalkLanding.jpg",@"BgWalkHome1.jpg",@"BgWalkHome2.jpg",@"BgWalkHome3.jpg",@"BgWalkHome4.jpg",@"BgWalkHome5.jpg"];
            self.arrBackgroundWallet = @[@"BgWalkWallet1.jpg",@"BgWalkWallet2.jpg",@"BgWalkWallet3.jpg"];
            
            
            [LoadingManager hide];
            
            [self setupView];
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
            
    
            
        
        });
    }];
    

    

}



-(void)setupView
{
    [self.btnNext setTitle:LocalisedString(@"Let's Get Started") forState:UIControlStateNormal];
    [self.btnSkipThis setTitle:LocalisedString(@"Skip this") forState:UIControlStateNormal];
    
    self.ibView0Title.text = LocalisedString(@"Welcome to Seeties");
    self.ibView0Desc.text = LocalisedString(@"Step by step on how to search, collect and redeem deals.");
    self.ibView1Title.text = LocalisedString(@"Handpicked Deals for You");
    self.ibView1Desc.text = LocalisedString(@"Watch this space for deals we think you'd like. Refreshed frequently, do check for updates!");
    self.ibView2Title.text = LocalisedString(@"Change Location");
    self.ibView2Desc.text=  LocalisedString(@"Tap to change between countries & cities for deals closest to you. Green tabs indicate deal availability at location.");
    self.ibView3Title.text = LocalisedString(@"Deals of the Day");
    self.ibView3Desc.text = LocalisedString(@"Featured deals are affordable & exclusively available for Seeties users. Don't miss out!");
    self.ibView4Title.text = LocalisedString(@"Voucher Wallet");
    self.ibView4Desc.text = LocalisedString(@"Access your voucher wallet here & keep track of your vouchers to be redeemed.");
    self.ibView5Title.text = LocalisedString(@"Shops & Places");
    self.ibView5Desc.text = LocalisedString(@"Discover more deals & collections of places to eat, hangout and play.");
    self.ibView6Title.text = LocalisedString(@"Voucher History");
    self.ibView6Desc.text = LocalisedString(@"See all redeemed and expired vouchers.");
    self.ibView7Title.text = LocalisedString(@"Redeem It");
    self.ibView7Desc.text = LocalisedString(@"Once you've collected a deal, be sure to redeem it before it expires. Don't let a good deal go to waste!");
    self.ibView8Title.text = LocalisedString(@"Voucher Types of Use");
    self.ibView8Desc.text = [NSString stringWithFormat:@"\u2022%@\n\n\u2022%@", LocalisedString(@"This voucher can only be used once."), LocalisedString(@"This voucher can be used multiple times.")];
}

-(void)initSelfView
{
    [self changeLanguage];
    
    [self.btnNext setSideCurveBorder];
    self.ibScrollView.delegate = self;
  
   }

-(void)changeLanguage{
   
    
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
                [self.btnNext setTitle:LocalisedString(@"Done") forState:UIControlStateNormal];
            }];
    } else {
            [UIView animateWithDuration:0.4 animations:^{
                [self.btnNext setTitle:LocalisedString(@"Next") forState:UIControlStateNormal];

            }];
    }
}
@end
