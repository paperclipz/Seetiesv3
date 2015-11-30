//
//  CollectionListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CollectionListingViewController.h"

@interface CollectionListingViewController ()
{
    
    __weak IBOutlet NSLayoutConstraint *scrollViewTopConstraint;
}
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property(nonatomic,assign)ProfileViewType profileType;
@property(nonatomic,assign)CollectionListingType collectionListingType;
@property(nonatomic,strong)ProfileModel* profileModel;
@property(nonatomic,assign)int viewPage;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMore;

@end

@implementation CollectionListingViewController


- (IBAction)btnAddMoreClicked:(id)sender {
    
    _newCollectionViewController = nil;

    [self.navigationController pushViewController:self.newCollectionViewController animated:YES];

}

- (IBAction)btnSegmentedClicked:(id)sender {
    
    UISegmentedControl* segmentedControl = (UISegmentedControl*)sender;
    
    CGRect frame = self.ibScrollView.frame;
    frame.origin.x = frame.size.width * segmentedControl.selectedSegmentIndex;
    frame.origin.y = 0;
    [self.ibScrollView scrollRectToVisible:frame animated:YES];
    
    if (self.profileType == ProfileViewTypeOwn && segmentedControl.selectedSegmentIndex == 0) {
        self.btnAddMore.hidden = NO;
    }
    else{
        self.btnAddMore.hidden = YES;

    }
}

-(void)setType:(ProfileViewType)type ProfileModel:(ProfileModel*)model NumberOfPage:(int)page
{
    self.profileType = type;
    self.profileModel = model;
    self.viewPage = page;//page refers to 1 or 2 page which can be scroll in scroll view . my collection 1st page , my following 2nd page
    
}

-(void)setType:(ProfileViewType)type ProfileModel:(ProfileModel*)model NumberOfPage:(int)page collectionType:(CollectionListingType)collType
{
    [self setType:type ProfileModel:model NumberOfPage:page];
    self.collectionListingType = collType;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self changeLanguage];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    self.ibScrollView.delegate = self;
    [self.ibScrollView addSubview:self.myCollectionListingViewController.view];
    scrollViewTopConstraint.constant = 0;

    CGRect frame = [Utils getDeviceScreenSize];
    [self.ibScrollView setWidth:frame.size.width];
    [self.myCollectionListingViewController.view setWidth:frame.size.width];
    [self.myCollectionListingViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.myCollectionListingViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width, self.ibScrollView.frame.size.height);


    if (self.viewPage == 2)
    {
        scrollViewTopConstraint.constant = 46;
        self.ibSegmentedControl.hidden = NO;
        [self.followingCollectionListingViewController.view setWidth:frame.size.width];
        [self.followingCollectionListingViewController.view setHeight:self.ibScrollView.frame.size.height];
        [self.ibScrollView addSubview:self.followingCollectionListingViewController.view];
        self.ibScrollView.contentSize = CGSizeMake(frame.size.width*2, self.ibScrollView.frame.size.height);
        self.ibScrollView.pagingEnabled = YES;
        [self.followingCollectionListingViewController.view setX:self.myCollectionListingViewController.view.frame.size.width];
    }
    else{
        self.ibSegmentedControl.hidden = YES;

    }
    

    self.btnAddMore.hidden = self.profileType == ProfileViewTypeOthers;
    
    [self initViewData];
}

-(void)initViewData
{
    
    if ([self.profileModel.uid isEqualToString:[Utils getUserID]]) {
        self.lblTitle.text = LocalisedString(@"Collections");
        
    }
    else{
        
        self.lblTitle.text = [NSString stringWithFormat:@"%@ %@",self.profileModel.username,LocalisedString(@"Collections")];
        
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Declaration
-(NewCollectionViewController*)newCollectionViewController
{
    if (!_newCollectionViewController) {
        _newCollectionViewController = [NewCollectionViewController new];
    }
    
    return _newCollectionViewController;
}
-(CollectionListingTabViewController*)myCollectionListingViewController
{
    if(!_myCollectionListingViewController)
    {
        _myCollectionListingViewController = [CollectionListingTabViewController new];
        _myCollectionListingViewController.profileType = self.profileType;
        //my collection is used for my own collection , suggested collection and trending collection
        _myCollectionListingViewController.collectionListingType = self.collectionListingType == CollectionListingTypeMyOwn?CollectionListingTypeMyOwn:self.collectionListingType;
        
        _myCollectionListingViewController.userID = self.profileModel.uid;
        __weak typeof (self)weakSelf = self;
        _myCollectionListingViewController.didSelectEdiCollectionRowBlock = ^(NSString* collectionID)
        {
            [weakSelf showEditCollectionViewWithCollectionID:collectionID];
        };
        
        _myCollectionListingViewController.didSelectDisplayCollectionRowBlock = ^(NSString* collectionID)
        {
            [weakSelf showCollectionDisplayViewWithCollectionID:collectionID ProfileType:weakSelf.profileType];
        };
        
    }
    
    return _myCollectionListingViewController;
}

-(CollectionListingTabViewController*)followingCollectionListingViewController
{
    if(!_followingCollectionListingViewController)
    {
        _followingCollectionListingViewController = [CollectionListingTabViewController new];
        _followingCollectionListingViewController.profileType = ProfileViewTypeOthers;
        _followingCollectionListingViewController.collectionListingType = CollectionListingTypeFollowing;
        _followingCollectionListingViewController.userID = self.profileModel.uid;
        __weak typeof (self)weakSelf = self;
        
        _followingCollectionListingViewController.didSelectEdiCollectionRowBlock = ^(NSString* collectionID)
        {
            [weakSelf showEditCollectionViewWithCollectionID:collectionID];
        };
        
        _followingCollectionListingViewController.didSelectDisplayCollectionRowBlock = ^(NSString* collectionID)
        {
            [weakSelf showCollectionDisplayViewWithCollectionID:collectionID ProfileType:ProfileViewTypeOthers];
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

-(void)showCollectionDisplayViewWithCollectionID:(NSString*)collID ProfileType:(ProfileViewType)profileType
{
    _collectionViewController = nil;
    if (self.profileType == ProfileViewTypeOwn) {
        [self.collectionViewController GetCollectionID:collID GetPermision:@"self"];

    }
    else{
        
     [self.collectionViewController GetCollectionID:collID GetPermision:@"Others"];
    }

    [self.navigationController pushViewController:self.collectionViewController animated:YES];
}

-(void)changeLanguage
{
    [self.ibSegmentedControl setTitle:LocalisedString(@"Collections") forSegmentAtIndex:0];
    [self.ibSegmentedControl setTitle:LocalisedString(@"Following Collections") forSegmentAtIndex:1];

}
@end
