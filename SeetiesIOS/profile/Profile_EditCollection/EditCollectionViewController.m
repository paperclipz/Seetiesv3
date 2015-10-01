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
@property (strong, nonatomic) NSMutableArray *arrList;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *ibBtnEdit;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfRecommendation;

@property (strong, nonatomic)CollectionModel* collectionModel;

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
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.lblTitle.text = self.collectionModel.name;
        self.lblDesc.text = self.collectionModel.postDesc;
        self.lblNumberOfRecommendation.text = [NSString stringWithFormat:@"%lu %@",(unsigned long)self.arrList.count,LOCALIZATION(@"Recommendations")];

        
    } completion:nil];
    
  }

-(void)initData:(CollectionModel*)model
{
    self.collectionModel = model;
    
    
    self.arrList = [[NSMutableArray alloc]initWithArray:self.collectionModel.arrayPost];
}

-(void)initSelfView
{
    [Utils setRoundBorder:self.ibBtnEdit color:[UIColor darkGrayColor] borderRadius:self.ibBtnEdit.frame.size.height/2];
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
        
        [self.arrList removeObjectAtIndex:indexPath.row];
        
        [self.ibTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        [self.ibTableView endUpdates];
    
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.arrList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

#pragma mark - Server

-(void)requestServerForCollectionDetails:(NSString*)collectionID successBlock:(IDBlock)successBlock failBlock:(IDBlock)failBlock{
    
    NSDictionary* dict = @{@"collection_id":collectionID,
                           @"list_size":@0,
                           @"page":@0
                           };
    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/%@",[Utils getUserID],collectionID];
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetCollectionInfo param:dict appendString:appendString completeHandler:^(id object) {
        
        if (successBlock) {
            successBlock(nil);
        }
    } errorBlock:nil];
    
}

#pragma mark - Declaration

-(EditCollectionDetailViewController*)editCollectionDetailViewController
{
    
    if (!_editCollectionDetailViewController) {
        
        _editCollectionDetailViewController = [EditCollectionDetailViewController new];
        
        __weak typeof (self)weakSelf = self;
        _editCollectionDetailViewController.btnDoneBlock = ^(id block)
        {
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
                           @"description":self.collectionModel.description,
                           @"tags":@""};
    
    NSString* appendString = [NSString stringWithFormat:@"%@/Collections",[Utils getUserID]];
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypePostCreateCollection param:dict appendString:appendString completeHandler:^(id object) {
        
        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Create New Collections" type:TSMessageNotificationTypeSuccess];
        
    } errorBlock:nil];
    
}

-(void)requestServerForUpdateCollection
{
    
    NSDictionary* dict = @{@"token":[Utils getAppToken],
                           @"collection_id":self.collectionModel.collection_id,
                           @"name":self.collectionModel.name,
                           @"access":self.collectionModel.isPrivate?@0:@1,
                           @"description":self.collectionModel.postDesc
                          // @"tags":@""
                           };
    
    NSMutableDictionary* finalDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    for (int i = 0; i<self.collectionModel.arrayPost.count; i++) {
        
        PostModel* model = self.collectionModel.arrayPost[i];
        NSDictionary* tempDict = @{@"id":model.post_id,
                                   @"note":model.collection_note
                                   //@"section":@"1"
                                   };
        
        NSDictionary* dictPost = @{[NSString stringWithFormat:@"posts[%d]",i]:tempDict};
        [finalDict addEntriesFromDictionary:dictPost];
    }

    //NSDictionary* dictSecondDesc = @{[NSString stringWithFormat:@"title[%@]",THAI_CODE]:ObjectOrNull(tempModel.postSecondTitle),
      //                               [NSString stringWithFormat:@"message[%@]",THAI_CODE]:ObjectOrNull(tempModel.postSecondDescription)};
    
    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/%@",[Utils getUserID],self.collectionModel.collection_id];
    
    [[ConnectionManager Instance] requestServerWithPut:ServerRequestTypePostCreateCollection param:finalDict appendString:appendString completeHandler:^(id object) {
        
        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Create New Collections" type:TSMessageNotificationTypeSuccess];
        
    } errorBlock:nil];
    
}

@end
