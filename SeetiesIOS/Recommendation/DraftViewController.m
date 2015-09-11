//
//  DraftViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/3/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DraftViewController.h"
#import "EditPostViewController.h"

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
 
        DraftModel* model = self.arrDraftList[indexPath.row];
    [cell initData:model];
       
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.editPostViewController initData:self.arrDraftList[indexPath.row]];
    
   // [self.navigationController pushViewController:self.editPostViewController animated:YES];
}

#pragma mark Request Server

-(void)requestServerForDeletePost
{
    
    NSDictionary* dict;
    [[ConnectionManager Instance]requestServerWithDelete:ServerRequestTypePostDeletePost param:dict completeHandler:^(id object) {
        
    } errorBlock:nil];
}

-(void)requestServerForDraft
{
//    self.arrDraftList = [NSMutableArray new];
//    
//    for (int i = 0; i<10; i++) {
//        [self.arrDraftList addObject:[DataManager getSampleRecommendation]];
//    }

    NSDictionary* dict = @{@"token":@"JDJ5JDEwJElrb1EvRXNGdUl6VjJQaVY4MXJLQmVsZEc4MXM0eUhJUkNJQTRjRXNWa2RnaUM1Ump5MzR1"};
    
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
        _editPostViewController = [EditPostViewController new];
    }
    return _editPostViewController;
}


@end
