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
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property(nonatomic,assign)ProfileViewType profileType;
@property(nonatomic,strong)ProfileModel* profileModel;

@end

@implementation CollectionListingViewController

- (IBAction)btnSegmentedClicked:(id)sender {
    
    UISegmentedControl* segmentedControl = (UISegmentedControl*)sender;
    
    CGRect frame = self.ibScrollView.frame;
    frame.origin.x = frame.size.width * segmentedControl.selectedSegmentIndex;
    frame.origin.y = 0;
    [self.ibScrollView scrollRectToVisible:frame animated:YES];
}

-(void)setType:(ProfileViewType)type ProfileModel:(ProfileModel*)model
{
    self.profileType = type;
    self.profileModel = model;
    
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
    
    self.ibScrollView.delegate = self;
    SLog(@" view size : %f || height : %f",self.view.frame.size.width,self.view.frame.size.height);
    [self.ibScrollView addSubview:self.myCollectionListingViewController.view];
   
    CGRect frame = [Utils getDeviceScreenSize];
    
    [self.ibScrollView setWidth:frame.size.width];
    [self.myCollectionListingViewController.view setWidth:frame.size.width];
    [self.followingCollectionListingViewController.view setWidth:frame.size.width];
    
    [self.myCollectionListingViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.followingCollectionListingViewController.view setHeight:self.ibScrollView.frame.size.height];


    [self.ibScrollView addSubview:self.myCollectionListingViewController.view];
    [self.ibScrollView addSubview:self.followingCollectionListingViewController.view];
  
    SLog(@"scroll view size : %f",self.ibScrollView.frame.size.width);
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*2, self.ibScrollView.frame.size.height);
    
    self.ibScrollView.pagingEnabled = YES;

    [self.followingCollectionListingViewController.view setX:self.myCollectionListingViewController.view.frame.size.width];
    [self initViewData];
  
}

-(void)initViewData
{
    self.lblTitle.text = [NSString stringWithFormat:@"%@ %@",self.profileModel.username,LocalisedString(@"Collections")];

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
        _myCollectionListingViewController.profileType = self.profileType;
        _myCollectionListingViewController.userID = self.profileModel.uid;
        __weak typeof (self)weakSelf = self;
        _myCollectionListingViewController.didSelectEdiCollectionRowBlock = ^(NSString* collectionID)
        {
            [weakSelf showEditCollectionViewWithCollectionID:collectionID];
        };
        
        _myCollectionListingViewController.didSelectDisplayCollectionRowBlock = ^(NSString* collectionID)
        {
            [weakSelf showCollectionDisplayViewWithCollectionID:collectionID];
        };
        
    }
    
    return _myCollectionListingViewController;
}

-(CollectionListingTabViewController*)followingCollectionListingViewController
{
    if(!_followingCollectionListingViewController)
    {
        _followingCollectionListingViewController = [CollectionListingTabViewController new];
        _followingCollectionListingViewController.profileType = self.profileType;
        _followingCollectionListingViewController.userID = self.profileModel.uid;
        __weak typeof (self)weakSelf = self;
        
        _followingCollectionListingViewController.didSelectEdiCollectionRowBlock = ^(NSString* collectionID)
        {
            [weakSelf showEditCollectionViewWithCollectionID:collectionID];
        };
        
        _followingCollectionListingViewController.didSelectDisplayCollectionRowBlock = ^(NSString* collectionID)
        {
            [weakSelf showCollectionDisplayViewWithCollectionID:collectionID];
        };
    }
    
    return _followingCollectionListingViewController;
}

-(EditCollectionViewController*)editCollectionViewController
{
    if (!_editCollectionViewController) {
        _editCollectionViewController = [EditCollectionViewController new];
    }
    
    return _editCollectionViewController;
}

-(CollectionViewController*)collectionViewController
{
    if (!_collectionViewController) {
        _collectionViewController = [CollectionViewController new];
    }
    
    return _collectionViewController;
}


#pragma mark - UIScroll View Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    
    self.ibSegmentedControl.selectedSegmentIndex = page;

}


-(void)showEditCollectionViewWithCollectionID:(NSString*)collID
{
    _editCollectionViewController = nil;
    [self.editCollectionViewController initData:collID ProfileType:self.profileType];
   // [LoadingManager show];
    [self.navigationController pushViewController:self.editCollectionViewController animated:YES];
}

-(void)showCollectionDisplayViewWithCollectionID:(NSString*)collID
{
    _collectionViewController = nil;
    [self.collectionViewController GetCollectionID:collID GetPermision:@"self"];
    [self.navigationController pushViewController:self.collectionViewController animated:YES];
}
@end
