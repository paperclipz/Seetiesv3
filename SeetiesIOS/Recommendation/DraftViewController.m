//
//  DraftViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/3/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DraftViewController.h"
#import "EditPostViewController.h"
#import "MGSwipeButton.h"
#import "UITableView+NXEmptyView.h"
#import "AFSwipeToHide.h"

@interface DraftViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *ibSwipeDeleteNoteView;
@property (weak, nonatomic) IBOutlet UILabel *lblSwipeToDelete;
@property (weak, nonatomic) IBOutlet UILabel *lblNoDraftYet;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* arrDraftList;
@property(nonatomic,strong)EditPostViewController* editPostViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic,strong)UIImageView* loadingImageView;
@property (strong, nonatomic) IBOutlet UIView *ibHeaderView;

// ======
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation DraftViewController

- (IBAction)btnBackClicked:(id)sender {
    
    if (_backBlock) {
        self.backBlock(self);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self changeLanguage];
    
     // Do any additional setup after loading the view from its nib.
}

-(void)initData
{
    [self requestServerForDraft];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [Utils setRoundBorder:self.ibSwipeDeleteNoteView color:TWO_ZERO_FOUR_COLOR borderRadius:0 borderWidth:0.5f];

    [self.tableView registerClass:[DraftTableViewCell class] forCellReuseIdentifier:@"DraftTableViewCell"];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self.loadingImageView startAnimating];
        [self requestServerForDraft];
        [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:30];
        
    }];

    UIImageView* initialLoadingView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    initialLoadingView.image = [UIImage imageNamed:@"2.png"];
    [self.tableView.pullToRefreshView setCustomView:self.loadingImageView forState:SVPullToRefreshStateAll];
    [self.tableView.pullToRefreshView setCustomView:initialLoadingView forState:SVPullToRefreshStateTriggered];

    
    [self changeLanguage];
}

-(UIImageView*)loadingImageView
{
    if(!_loadingImageView)
    {
        _loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _loadingImageView.animationImages = @[[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"3.png"]];
        _loadingImageView.animationDuration = 1.0f;
        _loadingImageView.animationRepeatCount = 100;

    }
    return _loadingImageView;
}

-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Draft");
    self.lblNoDraftYet.text = LocalisedString(@"No Draft Yet");
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDraftList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DraftTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DraftTableViewCell"];
    cell.delegate = self;
   // cell.rightButtons = [self createRightButtons:data.rightButtonsCount];
    cell.rightButtons = [self createRightButtons:1];
    
    CGRect frame = [Utils getDeviceScreenSize];
    cell.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        DraftModel* model = self.arrDraftList[indexPath.row];
    [cell initData:model];
    
       
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DraftModel* draftModel = self.arrDraftList[indexPath.row];

    _editPostViewController = nil;
    [self.editPostViewController initDataDraft:draftModel];

    [self.navigationController pushViewController:self.editPostViewController animated:YES onCompletion:^{
    }];
}

#pragma mark Request Server

-(void)requestServerForDeletePost:(NSString*)postID
{
    
    NSDictionary* dict = @{@"token":[Utils getAppToken]};
    [LoadingManager showWithTitle:LocalisedString(@"Deleting Draft...")];
    [[ConnectionManager Instance]requestServerWithDelete:ServerRequestTypePostDeletePost param:dict appendString:postID completeHandler:^(id object) {
        
        
    } errorBlock:nil];
}

-(void)requestServerForDraft
{
//    self.arrDraftList = [NSMutableArray new];
//    
//    for (int i = 0; i<10; i++) {
//        [self.arrDraftList addObject:[DataManager getSampleRecommendation]];
//    }

    NSDictionary* dict = @{@"token":[Utils getAppToken]};
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetRecommendationDraft param:dict appendString:nil completeHandler:^(id object) {
        
        NSArray<DraftModel>* array = [[[ConnectionManager dataManager]draftsModel]posts];
        self.arrDraftList = [[NSMutableArray alloc]initWithArray:array];
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
       
        [self.loadingImageView stopAnimating];

    } errorBlock:^(id object) {
        [self.tableView.pullToRefreshView stopAnimating];
        [self.loadingImageView stopAnimating];

    }];
 
}

#pragma mark Declaration

-(EditPostViewController*)editPostViewController
{
    if(!_editPostViewController)
    {
        
        __weak typeof (self)weakSelf = self;
        _editPostViewController = [EditPostViewController new];
        _editPostViewController.editPostBackBlock = ^(id object)
        {
            EditPostViewController* obj  = (EditPostViewController*)object;
            obj = nil;
            [weakSelf requestServerForDraft];
        
        };
    }
    return _editPostViewController;
}
-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"Delete", @"More"};
    UIColor * colors[2] = {[UIColor redColor], [UIColor lightGrayColor]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (right).");
            BOOL autoHide = i != 0;
            
            [self.tableView beginUpdates];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            NSString* postID = [self.arrDraftList[indexPath.row] post_id];

            [self.arrDraftList removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
            [self requestServerForDeletePost:postID];

            return autoHide; //Don't autohide in delete button to improve delete expansion animation
        }];
        [result addObject:button];
    }
    return result;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    SLog(@"%f !!!",scrollView.contentOffset.y);
    float scrollYvariance = scrollView.contentOffset.y;
    
    SLog(@"content offset %f :",scrollYvariance);
    
    float tempnumber = fabs(scrollYvariance);
    if (tempnumber <= self.ibHeaderView.frame.size.height) {
        
        SLog(@"MOVING");
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y-scrollYvariance)];

    }
    
//    ScrollDirection scrollDirection;
//    if (self.lastContentOffset > scrollView.contentOffset.y)
//    {
//        scrollDirection = ScrollDirectionDown;
//        
//        if(self.ibHeaderView.frame.origin.y == -self.ibHeaderView.frame.size.height)
//        [self.ibHeaderView setY:self.ibHeaderView.frame.origin.y - scrollView.contentOffset.y];
//
//    }
//    else if (self.lastContentOffset < scrollView.contentOffset.y)
//    {
//        SLog(@"bottom");
//        [self.ibHeaderView setY:self.ibHeaderView.frame.origin.y + scrollView.contentOffset.y];
//
//        scrollDirection = ScrollDirectionUp;
//
//    }
//    
//    self.lastContentOffset = scrollView.contentOffset.x;

   //ibHeaderView
}
@end
