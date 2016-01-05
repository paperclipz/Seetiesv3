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

@interface DraftViewController ()<UIScrollViewDelegate>
{
    BOOL isMiddleOfCallingServer;
}
@property (weak, nonatomic) IBOutlet UIView *ibSwipeDeleteNoteView;
@property (weak, nonatomic) IBOutlet UILabel *lblSwipeToDelete;
@property (weak, nonatomic) IBOutlet UILabel *lblNoDraftYet;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* arrDraftList;
@property(nonatomic,strong)EditPostViewController* editPostViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic,strong)UIImageView* loadingImageView;
@property (strong, nonatomic) IBOutlet UIView *ibHeaderView;
@property (strong, nonatomic) DraftsModel* draftsModel;

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
    cell.didDeleteAtIndexPath = ^(DraftTableViewCell* sender)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        if (indexPath) {
            [self.tableView beginUpdates];
            NSString* postID = [self.arrDraftList[indexPath.row] post_id];
            [self.arrDraftList removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            [self requestServerForDeletePost:postID];
        }
        
    };
    
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

    [self.navigationController pushViewController:self.editPostViewController animated:YES];

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

    isMiddleOfCallingServer = YES;

    
    NSDictionary* dict = @{@"token":[Utils getAppToken],
                           @"limit":@(ARRAY_LIST_SIZE),
                           @"offset":@(self.draftsModel.offset + self.draftsModel.limit)
                           
                           };
  
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetRecommendationDraft param:dict appendString:nil completeHandler:^(id object) {
        
        self.draftsModel = [[ConnectionManager dataManager]draftsModel];
        NSArray<DraftModel>* array = [[[ConnectionManager dataManager]draftsModel]posts];
        [self.arrDraftList addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
       
        [self.loadingImageView stopAnimating];
        isMiddleOfCallingServer = NO;


    } errorBlock:^(id object) {
        [self.tableView.pullToRefreshView stopAnimating];
        [self.loadingImageView stopAnimating];
        isMiddleOfCallingServer = NO;

    }];
 
}

#pragma mark Declaration

-(NSMutableArray*)arrDraftList
{
    if (!_arrDraftList) {
        _arrDraftList = [NSMutableArray new];
    }
    return _arrDraftList;
}

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
            _draftsModel = nil;
            _arrDraftList = nil;
            [weakSelf.tableView reloadData];
            [weakSelf requestServerForDraft];
        
        };
    }
    return _editPostViewController;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.x + scrollView.frame.size.width;
    
    float reload_distance = 10;
    if (bottomEdge >= scrollView.contentSize.width -  reload_distance) {
        
        if(![Utils isStringNull:self.draftsModel.next])
        {
            [self requestServerForDraft];
        }
//        if (self.triggerLoadMoreBlock) {
//            self.triggerLoadMoreBlock();
//        }
    }
}

@end
