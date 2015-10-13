//
//  ProfileViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+FX.h"
#import "UIScrollView+IBFloatingHeader.h"
//#import "ParallaxHeaderView.h"


@interface ProfileViewController ()
@property (nonatomic, assign) CGFloat lastContentOffset;



@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfileBG;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfilePic;
@property (strong, nonatomic) IBOutlet UIView *ibTopContentView;
@property (strong, nonatomic) IBOutlet UIView *ibHeaderView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *ibContentView;

@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@end

@implementation ProfileViewController
- (IBAction)btnSegmentedControlClicked:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [self.ibScrollView removeContentOffsetObserver];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initSelfView
{
    
    self.ibScrollView.delegate = self;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [Utils setRoundBorder:self.ibImgProfilePic color:[UIColor whiteColor] borderRadius:self.ibImgProfilePic.frame.size.width/2 borderWidth:6.0f];

    [self.ibImgProfilePic sd_setImageWithURL:[NSURL URLWithString:@"http://i2.listal.com/image/1005436/936full-rooney-mara.jpg"] placeholderImage:[UIImage imageNamed:@"DefaultProfilePic.png"]];
    

    [self.ibImgProfileBG sd_setImageWithURL:[NSURL URLWithString:@"http://i.ytimg.com/vi/tjW1mKwNUSo/maxresdefault.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.ibImgProfileBG.image = [image imageCroppedAndScaledToSize:self.ibImgProfileBG.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
        
    }];
    
    [self.ibScrollView addSubview:self.collectionTBLVC.view];
    CGRect frame = [Utils getDeviceScreenSize];
    self.collectionTBLVC.view.frame = CGRectMake(0,self.ibContentView.frame.size.height, frame.size.width, self.collectionTBLVC.view.frame.size.height);
    [self.collectionTBLVC.tableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    UIView* header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 40)];
    [header setBackgroundColor:[UIColor redColor]];
    [self.ibScrollView setFloatingHeaderView:header];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.collectionTBLVC.tableView) {
        
        if ([keyPath isEqualToString:@"contentSize"]) {
            
            

            self.ibScrollView.contentSize = CGSizeMake(self.ibContentView.frame.size.width, self.ibContentView.frame.size.height +  self.collectionTBLVC.tableView.contentSize.height);
            self.collectionTBLVC.view.frame = CGRectMake(0, self.collectionTBLVC.view.frame.origin.y,self.collectionTBLVC.view.frame.size.width, self.collectionTBLVC.tableView.contentSize.height);
            
        }
        
    }
}

-(PcollectionTableViewController*)collectionTBLVC
{
    if (!_collectionTBLVC) {
        _collectionTBLVC = [PcollectionTableViewController new];
    }
    
    return _collectionTBLVC;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    ScrollDirection scrollDirection;
//    if (self.lastContentOffset > scrollView.contentOffset.y)
//        scrollDirection = ScrollDirectionRight;
//    else if (self.lastContentOffset < scrollView.contentOffset.y)
//        scrollDirection = ScrollDirectionLeft;
//    
//    self.lastContentOffset = scrollView.contentOffset.x;
    float scrollOffset = scrollView.contentOffset.y;

    
    SLog(@"scroll view scrollOffset : %f",scrollOffset);
    if (scrollOffset >= self.ibContentView.frame.size.height) {
        self.ibHeaderView.frame = CGRectMake(0, 0, self.ibHeaderView.frame.size.width, self.ibHeaderView.frame.size.height);
    }
//    else if ()
//    {
//    
//    }
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
