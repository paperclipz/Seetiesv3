//
//  DraftViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/3/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DraftViewController.h"
#import "DraftTableViewCell.h"
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
    
    RecommendationModel* model = self.arrDraftList[indexPath.row];
    EditPhotoModel* editModel = model.arrPostImagesList[0];
    cell.imageView.image = editModel.image;
    cell.lblTitle.text =editModel.photoDescription;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.editPostViewController initData:self.arrDraftList[indexPath.row]];
    
    [self.navigationController pushViewController:self.editPostViewController animated:YES];
}

#pragma mark Request Server
-(void)requestServerForDraft
{
//    self.arrDraftList = [NSMutableArray new];
//    
//    for (int i = 0; i<10; i++) {
//        [self.arrDraftList addObject:[DataManager getSampleRecommendation]];
//    }

   // NSData *imageData = UIImagePNGRepresentation(myImage.image);
    NSDictionary* dict = @{@"token":[Utils getAppToken],@"status":@"0",@"title":@"Hello",@"message":@"this is the publish message",@"category":@[@1,@2,@3],@"device_type":@2,@"location":@"",@"link":@"www.google.com",@"photos":@""};
    
    [[ConnectionManager Instance] requestServerWithPost:ServerRequestTypePostCreatePost param:dict completeHandler:^(id object) {
        
    } errorBlock:^(id object) {
        
    }];
 
}
-(EditPostViewController*)editPostViewController
{
    if(!_editPostViewController)
    {
        _editPostViewController = [EditPostViewController new];
    }
    return _editPostViewController;
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
