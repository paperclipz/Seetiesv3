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

@property (strong, nonatomic)CollectionModels* collectionModel;

@end

@implementation EditCollectionViewController
- (IBAction)btnEditClicked:(id)sender {
    
    if(self.btnEditClickBlock)
    {
        self.btnEditClickBlock(self);
    }
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

-(void)initData:(CollectionModels*)model
{
    self.collectionModel = model;
    self.arrList = (NSMutableArray*)self.collectionModel.arrayPost;
    
    

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
@end
