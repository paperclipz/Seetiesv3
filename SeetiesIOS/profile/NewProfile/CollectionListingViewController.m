//
//  CollectionListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CollectionListingViewController.h"

@interface CollectionListingViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;

@end

@implementation CollectionListingViewController

- (IBAction)btnSegmentedClicked:(id)sender {
    
    UISegmentedControl* segmentedControl = (UISegmentedControl*)sender;
    
    CGRect frame = self.ibScrollView.frame;
    frame.origin.x = frame.size.width * segmentedControl.selectedSegmentIndex;
    frame.origin.y = 0;
    [self.ibScrollView scrollRectToVisible:frame animated:YES];
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
    
    CGRect frame = [Utils getDeviceScreenSize];
    
    [self.myCollectionListingViewController.view setWidth:frame.size.width];
    [self.followingCollectionListingViewController.view setHeight:frame.size.height];

    [self.ibScrollView setWidth:frame.size.width];
    [self.ibScrollView addSubview:self.myCollectionListingViewController.view];
    [self.ibScrollView addSubview:self.followingCollectionListingViewController.view];
  
    SLog(@"scroll view size : %f",self.ibScrollView.frame.size.width);
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*2, self.ibScrollView.frame.size.height);
    
    self.ibScrollView.pagingEnabled = YES;

    [self.followingCollectionListingViewController.view setX:self.myCollectionListingViewController.view.frame.size.width];

    
  }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(CollectionListingTabViewController*)myCollectionListingViewController
{
    if(!_myCollectionListingViewController)
    {
        _myCollectionListingViewController = [CollectionListingTabViewController new];
    }
    
    return _myCollectionListingViewController;
}

-(CollectionListingTabViewController*)followingCollectionListingViewController
{
    if(!_followingCollectionListingViewController)
    {
        _followingCollectionListingViewController = [CollectionListingTabViewController new];
    }
    
    return _followingCollectionListingViewController;
}


@end
