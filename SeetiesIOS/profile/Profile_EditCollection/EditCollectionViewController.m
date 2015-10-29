//
//  EditCollectionViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditCollectionViewController.h"
#import "EditCollectionTableViewCell.h"

@interface EditCollectionViewController ()
{
    int collectionDetailPage;
    int collectionDetailTotal_page;
    int collectionDetailTotal_posts;


}
@property (strong, nonatomic) NSMutableArray *arrList; // use this to update collection
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *ibBtnEdit;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfRecommendation;
@property (weak, nonatomic) IBOutlet UILabel *lblPostTitle;

@property (strong, nonatomic)CollectionModel* collectionModel;
@property (strong, nonatomic)NSString* collectionID;

@end

@implementation EditCollectionViewController
- (IBAction)btnDoneClicked:(id)sender {


    [self saveData];
    [self requestServerForUpdateCollection];
}
- (IBAction)btnEditClicked:(id)sender {

    
    _editCollectionDetailViewController = nil;
    [self.editCollectionDetailViewController initData:self.collectionModel];
    [self.navigationController pushViewController:self.editCollectionDetailViewController animated:YES];
    
}
- (IBAction)btnBackClicked:(id)sender {
   
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self changeLanguage];
    collectionDetailPage = 0;
    self.arrList = [NSMutableArray new];
 
    collectionDetailTotal_page = 1;//to ensure the first time is run
    [self requestServerDetail];
    
   // [self.lblTitle setFont:[UIFont fontWithName:CustomFontName size:17]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    
    [self reloadData];
    
}

-(void)reloadData
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.lblPostTitle.text = self.collectionModel.name;
        self.lblDesc.text = self.collectionModel.postDesc;
        self.lblNumberOfRecommendation.text = [NSString stringWithFormat:@"%d %@",collectionDetailTotal_posts,LocalisedString(@"Recommendations")];
        
        
    } completion:nil];
}

-(void)initData:(NSString*)collectionID
{
    self.collectionID = collectionID;
}

-(void)initSelfView
{
    [Utils setRoundBorder:self.ibBtnEdit color:TWO_ZERO_FOUR_COLOR borderRadius:self.ibBtnEdit.frame.size.height/2 borderWidth:BORDER_WIDTH];

    [self initTableViewWithDelegate:self];
}

-(void)initTableViewWithDelegate:(id)sender
{
    self.ibTableView.delegate = sender;
    self.ibTableView.dataSource = sender;
    [self.ibTableView registerClass:[EditCollectionTableViewCell class] forCellReuseIdentifier:@"EditCollectionTableViewCell"];
    self.ibTableView.longPressReorderEnabled = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITable View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return self.arrList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditCollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EditCollectionTableViewCell"];
    [cell initData:self.arrList[indexPath.row]];
    
    cell.deleteCellBlock = ^(id object)
    {
        EditCollectionTableViewCell* cell = (EditCollectionTableViewCell*)object;
        
        NSIndexPath* indexPath = [self.ibTableView indexPathForCell:cell];
        
        [self.ibTableView beginUpdates];
        
        [self.collectionModel.deleted_posts addObject:self.arrList[indexPath.row]];

        [self.arrList removeObjectAtIndex:indexPath.row];
        
        [self.ibTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        
        self.lblNumberOfRecommendation.text = [NSString stringWithFormat:@"%lu %@",(unsigned long)self.arrList.count,LocalisedString(@"Recommendations")];

        [self.ibTableView endUpdates];
        
    
    };
    
    return cell;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.arrList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
   
    float reload_distance = 10;
    if(y > h + reload_distance) {
        [self requestServerDetail];
    }
}

#pragma mark - Declaration

-(EditCollectionDetailViewController*)editCollectionDetailViewController
{
    
    if (!_editCollectionDetailViewController) {
        
        _editCollectionDetailViewController = [EditCollectionDetailViewController new];
        
        __weak typeof (self)weakSelf = self;
        _editCollectionDetailViewController.btnDoneBlock = ^(id block)
        {
            weakSelf.collectionModel = (CollectionModel*)block;
         //   weakSelf.editCollectionDetailViewController = nil;
        };
        
        _editCollectionDetailViewController.btnCancelBlock = ^()
        {
        
        //    weakSelf.editCollectionDetailViewController = nil;

            
        };
    }
    
    return _editCollectionDetailViewController;
}

#pragma mark - server


-(void)saveData
{
    
    for (int i = 0; i<[self.ibTableView numberOfRowsInSection:0]; i++) {
        
        EditCollectionTableViewCell* cell = (EditCollectionTableViewCell*)[self.ibTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell saveData];
    }

}

-(void)requestServerForCreateCollection{
    
    
    NSDictionary* dict = @{@"token":[Utils getAppToken],
                           @"name":self.collectionModel.name,
                           @"access":self.collectionModel.isPrivate?@0:@1,
                           @"description":self.collectionModel.postDesc,
                           @"tags":@""};
    
    NSString* appendString = [NSString stringWithFormat:@"%@/Collections",[Utils getUserID]];
    [LoadingManager showWithTitle:@"updating"];

    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypePostCreateCollection param:dict appendString:appendString completeHandler:^(id object) {
        [LoadingManager hide];

        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Create New Collections" type:TSMessageNotificationTypeSuccess];
        
    } errorBlock:^(id object) {
        [LoadingManager hide];

    }];
    
}

-(void)requestServerForUpdateCollection
{
    
    

    NSDictionary* dict = @{@"token":ObjectOrNull([Utils getAppToken]),
                           @"collection_id":ObjectOrNull(self.collectionModel.collection_id),
                           @"name":ObjectOrNull(self.collectionModel.name),
                           @"access":self.collectionModel.isPrivate?@1:@0,
                           @"tags":ObjectOrNull(self.collectionModel.tagList),
                           @"description":ObjectOrNull(self.collectionModel.postDesc)

                           };
    
    
    NSMutableDictionary* finalDict = [[NSMutableDictionary alloc]initWithDictionary:dict];

    for (int i = 0; i<self.collectionModel.deleted_posts.count; i++) {

        DraftModel* tempPostModel = self.collectionModel.deleted_posts[i];
        NSDictionary* tempDict = @{[NSString stringWithFormat:@"delete_posts[%d]",i]:tempPostModel.post_id};
        [finalDict addEntriesFromDictionary:tempDict];
    }
    
    for (int i = 0; i<self.arrList.count; i++) {
        
        DraftModel* model = self.arrList[i];
        NSDictionary* tempDict = @{@"id":model.post_id,
                                   @"note":model.collection_note
                                   //@"section":@"1"
                                   };
        
        NSDictionary* dictPost = @{[NSString stringWithFormat:@"posts[%d]",i]:tempDict};
        [finalDict addEntriesFromDictionary:dictPost];
    }

    
    SLog(@" collection request : %@",finalDict);
    //NSDictionary* dictSecondDesc = @{[NSString stringWithFormat:@"title[%@]",THAI_CODE]:ObjectOrNull(tempModel.postSecondTitle),
      //                               [NSString stringWithFormat:@"message[%@]",THAI_CODE]:ObjectOrNull(tempModel.postSecondDescription)};
    
    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/%@",[Utils getUserID],self.collectionModel.collection_id];
    [LoadingManager show];

    [[ConnectionManager Instance] requestServerWithPut:ServerRequestTypePostCreateCollection param:finalDict appendString:appendString completeHandler:^(id object) {
        
        [TSMessage showNotificationInViewController:self title:@"system" subtitle:@"Success Saved Collections" type:TSMessageNotificationTypeSuccess];
        [LoadingManager hide];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];

    } errorBlock:^(id object) {
        [LoadingManager hide];

    }];
}

#pragma mark - Server

-(void)requestServerDetail
{
    if (collectionDetailTotal_page > collectionDetailPage) {
        [self requestServerForCollectionDetails:self.collectionID successBlock:^(id object) {
            
            self.collectionModel = [[ConnectionManager dataManager] collectionModels];
            collectionDetailTotal_posts = self.collectionModel.total_posts;
            collectionDetailPage = self.collectionModel.page;
            collectionDetailTotal_page = self.collectionModel.total_page;
            [self.arrList addObjectsFromArray:self.collectionModel.arrayPost];
            [self.ibTableView reloadData];
            [self reloadData];

            
        } failBlock:^(id object) {
            
        }];
        
    }
    
}

-(void)requestServerForCollectionDetails:(NSString*)collectionID successBlock:(IDBlock)successBlock failBlock:(IDBlock)failBlock{
    
    collectionDetailPage+=1;
    NSDictionary* dict = @{@"collection_id":collectionID,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"page":@(collectionDetailPage),
                           @"token":[Utils getAppToken]
                           };
    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/%@",[Utils getUserID],collectionID];
    
    //[LoadingManager show];
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetCollectionInfo param:dict appendString:appendString completeHandler:^(id object) {
        
        
        if (successBlock) {
            successBlock(nil);
        }
        [LoadingManager hide];
        
    } errorBlock:^(id object) {
        [LoadingManager hide];
        
    }];
    
}

static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}


#pragma mark - change language

-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Edit Collection");
    [self.ibBtnEdit setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
}

@end
