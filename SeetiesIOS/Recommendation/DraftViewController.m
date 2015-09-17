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


@interface DraftViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* arrDraftList;

@property(nonatomic,strong)EditPostViewController* editPostViewController;
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
    [self.tableView registerClass:[DraftTableViewCell class] forCellReuseIdentifier:@"DraftTableViewCell"];
    
 
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
    [self.editPostViewController initDataDraft:draftModel];
    
    [self.navigationController pushViewController:self.editPostViewController animated:YES];
}

#pragma mark Request Server

-(void)requestServerForDeletePost:(NSString*)postID
{
    
    NSDictionary* dict = @{@"token":[Utils getAppToken]};
    
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
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetRecommendationDraft param:dict completeHandler:^(id object) {
        
        NSArray<DraftModel>* array = [[[ConnectionManager dataManager]draftsModel]posts];
        self.arrDraftList = [[NSMutableArray alloc]initWithArray:array];
        [self.tableView reloadData];
        
    } errorBlock:nil];
 
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

@end
