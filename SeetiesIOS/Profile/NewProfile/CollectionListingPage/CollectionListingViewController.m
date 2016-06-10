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
    NSString* seetiesID;
}
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (weak, nonatomic) IBOutlet UIView *ibSegmentedControlView;
@property(nonatomic) HMSegmentedControl *segmentedControl;
@property(nonatomic) NSArray *arrViewControllers;

@property(nonatomic,assign)ProfileViewType profileType;
@property(nonatomic,assign)CollectionListingType collectionListingType;
@property(nonatomic,strong)ProfileModel* profileModel;
@property(nonatomic,assign)int viewPage;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMore;
@property (strong, nonatomic)EditCollectionDetailViewController *collectionDetailController;
@property (strong, nonatomic) NSString* postID;

@end

@implementation CollectionListingViewController


- (IBAction)btnAddMoreClicked:(id)sender {
    _collectionDetailController = nil;
    [self.collectionDetailController initDataWithUserID:[Utils getUserID]];
    [self.navigationController presentViewController:self.collectionDetailController animated:YES completion:nil];
}

-(void)setType:(ProfileViewType)type ProfileModel:(ProfileModel*)model NumberOfPage:(int)page
{
    self.profileType = type;
    self.profileModel = model;
    self.viewPage = page;//page refers to 1 or 2 page which can be scroll in scroll view . my collection 1st page , my following 2nd page
    
}

-(void)setTypeSeeties:(NSString*)ID
{
    self.profileType = ProfileViewTypeOthers;
    self.collectionListingType = CollectionListingTypeSeetiesShop;
    seetiesID = ID;
    self.myCollectionListingViewController.userID = seetiesID;
    self.viewPage = 1;//page refers to 1 or 2 page which can be scroll in scroll view . my collection 1st page , my following 2nd page
    
}

-(void)setType:(ProfileViewType)type ProfileModel:(ProfileModel*)model NumberOfPage:(int)page collectionType:(CollectionListingType)collType
{
    [self setType:type ProfileModel:model NumberOfPage:page];
    self.collectionListingType = collType;
}

-(void)setTypePostSuggestion:(NSString*)postID
{
    self.collectionListingType = CollectionListingTypePostSuggestion;
    self.viewPage = 1;
    self.postID = postID;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.myCollectionListingViewController reloadView];
    [self.followingCollectionListingViewController reloadView];
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
    [self initSegmentedControlViewInView:self.ibScrollView ContentView:self.ibSegmentedControlView ViewControllers:self.arrViewControllers];

    self.btnAddMore.hidden = self.profileType == ProfileViewTypeOthers;
    
    [self initViewData];
}

-(void)initSegmentedControlViewInView:(UIScrollView*)view ContentView:(UIView*)contentView ViewControllers:(NSArray*)arryViewControllers
{
    
    CGRect frame = [Utils getDeviceScreenSize];
    view.delegate = self;
    
    
    NSMutableArray* arrTitles = [NSMutableArray new];
    
    for (int i = 0; i<arryViewControllers.count; i++) {
        
        UIViewController* vc = arryViewControllers[i];
        [view addSubview:vc.view];
        [arrTitles addObject:vc.title];
        vc.view.frame = CGRectMake(i*frame.size.width, 0, view.frame.size.width, view.frame.size.height);
    }
    
    view.contentSize = CGSizeMake(frame.size.width*arryViewControllers.count , view.frame.size.height);
    
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : TEXT_GRAY_COLOR,
                                                  NSFontAttributeName : [UIFont fontWithName:CustomFontNameBold size:14.0f]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ONE_ZERO_TWO_COLOR,
                                                          NSFontAttributeName : [UIFont fontWithName:CustomFontNameBold size:14.0f]};
    
    self.segmentedControl.sectionTitles = arrTitles;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.selectionIndicatorColor = DEVICE_COLOR;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    [contentView addSubview:self.segmentedControl];
    
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [view scrollRectToVisible:CGRectMake(view.frame.size.width * index, 0, view.frame.size.width, view.frame.size.height) animated:YES];
    }];
    
}

-(void)initViewData
{
    
    if (self.collectionListingType == CollectionListingTypeSeetiesShop) {
        
        self.lblTitle.text = LocalisedString(@"SeetiShop Collections");

    }
    else if(self.collectionListingType == CollectionListingTypePostSuggestion)
    {
        self.lblTitle.text = LocalisedString(@"Collections");

    }
    else
    {
        if ([self.profileModel.uid isEqualToString:[Utils getUserID]]) {
            self.lblTitle.text = LocalisedString(@"Collections");
            
        }
        else{
            
            self.lblTitle.text = [NSString stringWithFormat:@"%@ %@",self.profileModel.username,LocalisedString(@"Collections")];
            
        }

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

-(EditCollectionDetailViewController*)collectionDetailController
{
    if (!_collectionDetailController) {
        _collectionDetailController = [EditCollectionDetailViewController new];
        
        __weak typeof (self)weakself = self;
        _collectionDetailController.btnDoneBlock = ^(id object)
        {
            [weakself.myCollectionListingViewController refreshRequest];

        };
    }
    return _collectionDetailController;
}

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
        _myCollectionListingViewController.title = LocalisedString(@"Collections");
        _myCollectionListingViewController.profileType = self.profileType;
        //my collection is used for my own collection , suggested collection and trending collection
        _myCollectionListingViewController.collectionListingType = self.collectionListingType == CollectionListingTypeMyOwn?CollectionListingTypeMyOwn:self.collectionListingType;
        
        _myCollectionListingViewController.userID = self.profileModel.uid;
        _myCollectionListingViewController.postID = self.postID;

        __weak typeof (self)weakSelf = self;
        _myCollectionListingViewController.didSelectEdiCollectionRowBlock = ^(CollectionModel* model)
        {
            [weakSelf showEditCollectionViewWithCollectionID:model.collection_id];
        };
        
        _myCollectionListingViewController.didSelectDisplayCollectionRowBlock = ^(CollectionModel* model)
        {
            [weakSelf showCollectionDisplayViewWithCollectionID:model];
        };
        
    }
    
    return _myCollectionListingViewController;
}

-(CollectionListingTabViewController*)followingCollectionListingViewController
{
    if(!_followingCollectionListingViewController)
    {
        _followingCollectionListingViewController = [CollectionListingTabViewController new];
        _followingCollectionListingViewController.title = LocalisedString(@"Following Collections");
        _followingCollectionListingViewController.profileType = ProfileViewTypeOthers;
        _followingCollectionListingViewController.collectionListingType = CollectionListingTypeFollowing;
        _followingCollectionListingViewController.userID = self.profileModel.uid;
        _followingCollectionListingViewController.postID = self.postID;

        __weak typeof (self)weakSelf = self;
        
        _followingCollectionListingViewController.didSelectEdiCollectionRowBlock = ^(CollectionModel* model)
        {
            [weakSelf showEditCollectionViewWithCollectionID:model.collection_id];
        };
        
        _followingCollectionListingViewController.didSelectDisplayCollectionRowBlock = ^(CollectionModel* model)
        {
            [weakSelf showCollectionDisplayViewWithCollectionID:model];
        };
    }
    
    return _followingCollectionListingViewController;
}

-(EditCollectionViewController*)editCollectionViewController
{
    if (!_editCollectionViewController) {
        _editCollectionViewController = [EditCollectionViewController new];
        __weak typeof (self)weakSelf = self;
        _editCollectionViewController.refreshBlock = ^(void)
        {
            [weakSelf.myCollectionListingViewController refreshRequest];
        };
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

-(NSArray *)arrViewControllers{
    if (!_arrViewControllers) {
        _arrViewControllers = @[self.myCollectionListingViewController, self.followingCollectionListingViewController];
    }
    return _arrViewControllers;
}

#pragma mark - UIScroll View Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}


-(void)showEditCollectionViewWithCollectionID:(NSString*)collID
{
    _editCollectionViewController = nil;
    [self.editCollectionViewController initData:collID];
    // [LoadingManager show];
    [self.navigationController pushViewController:self.editCollectionViewController animated:YES];
}

-(void)showCollectionDisplayViewWithCollectionID:(CollectionModel*)colModel
{
    _collectionViewController = nil;
    if ([colModel.user_info.uid isEqualToString:[Utils getUserID]]) {
        [self.collectionViewController GetCollectionID:colModel.collection_id GetPermision:@"self" GetUserUid:colModel.user_info.uid];

    }
    else{
        
     [self.collectionViewController GetCollectionID:colModel.collection_id GetPermision:@"Others" GetUserUid:colModel.user_info.uid];
    }

    [self.navigationController pushViewController:self.collectionViewController animated:YES];
}

@end
