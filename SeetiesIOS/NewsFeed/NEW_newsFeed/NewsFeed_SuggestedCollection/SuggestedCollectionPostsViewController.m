//
//  SuggestedCollectionPostsViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/11/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SuggestedCollectionPostsViewController.h"
#import "SuggestedCollectionPostTableViewCell.h"

@interface SuggestedCollectionPostsViewController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)NSMutableArray* arrPostList;

// =================== IBOUTLET ===========================
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
// =================== IBOUTLET ===========================



// =================== MODEL ===========================
@property (strong, nonatomic) NSMutableArray* arrCellSize;
@property (strong, nonatomic) NSString* collectionID;
@property (strong, nonatomic) NSArray* arrPostIDs;
@property (strong, nonatomic) CollectionModel* collectionModel;

// =================== MODEL ===========================

@end

@implementation SuggestedCollectionPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self requestServerForCollectionInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.ibTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData:(NSString*)collectionID
{
    self.collectionID = collectionID;
}

-(void)initSelfView
{
    [self iniiTableViewDelegate:self];
}

-(void)iniiTableViewDelegate:(id)delegate
{
    self.ibTableView.delegate = delegate;
    self.ibTableView.dataSource = delegate;
    [self.ibTableView registerClass:[SuggestedCollectionPostTableViewCell class] forCellReuseIdentifier:@"SuggestedCollectionPostTableViewCell"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (int)lineCountForLabel:(UILabel *)label {
//    CGRect paragraphRect =
//    [label.text boundingRectWithSize:CGSizeMake(300.f, CGFLOAT_MAX)
//                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                 context:nil];
//    
//    return ceil(size.height / label.font.lineHeight);
//}

#pragma mark - Declaration

-(FeedV2DetailViewController*)feedV2DetailViewController
{
    if (!_feedV2DetailViewController) {
        _feedV2DetailViewController = [FeedV2DetailViewController new];
    }
    
    return _feedV2DetailViewController;
}
-(NSMutableArray*)arrPostList
{
    if (!_arrPostList) {
        _arrPostList = [NSMutableArray new];
    }
    
    return _arrPostList;
}
#pragma mark - UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [SuggestedCollectionPostTableViewCell getHeight];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrPostList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuggestedCollectionPostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestedCollectionPostTableViewCell"];
    
    DraftModel* draftModel = self.arrPostList[indexPath.row];
    
    if (![draftModel.arrCustomPost isNull]) {
        Post* postModel = draftModel.arrCustomPost[0];
        [cell setDescription:postModel.message userName:draftModel.user_info.name];

    }
    
    if (![draftModel.arrPhotos isNull]) {
        PhotoModel* photoModel = draftModel.arrPhotos[0];
        [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.imageURL]];

    }
    
    cell.lblLocation.text = draftModel.location.sublocality;
    cell.lblName.text = draftModel.location.name;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {


    if (self.arrCellSize[indexPath.row] == [NSNull null]) {
        
        DraftModel* draftModel = self.arrPostList[indexPath.row];
        
        
        NSString* message = @"";
        
        if (![draftModel.arrCustomPost isNull]) {
            Post* postModel = draftModel.arrCustomPost[0];
            message = postModel.message;
        }
            CGRect frame = [Utils getDeviceScreenSize];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragraphStyle setLineSpacing:5];
            
            CGRect rect = [message boundingRectWithSize:CGSizeMake(frame.size.width - (2*10), frame.size.height)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{
                                                                    NSFontAttributeName : [UIFont fontWithName:CustomFontName size:17],
                                                                    NSParagraphStyleAttributeName : paragraphStyle
                                                                    }
                                                          context:nil];
            //SLog(@"AAAA = %f",rect.size.height);
            [self.arrCellSize replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:rect.size.height]];


    }
    return [self.arrCellSize[indexPath.row] floatValue] + 160 + 60;//60 is buffer

}

#pragma mark - UITable View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showPostDetailView:indexPath];
}

-(NSMutableArray*)arrCellSize
{
    if (!_arrCellSize) {
        _arrCellSize = [[NSMutableArray alloc]init];
        for(int i = 0;i<self.arrPostList.count;i++)
        {
            [_arrCellSize addObject:[NSNull null]];
        }
    }
    return  _arrCellSize;
}

#pragma mark - SERVER REQUEST

-(void)requestServerForCollectionInfo
{
    
    NSDictionary* dict = @{@"collection_id":self.collectionID,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"page":@(1),
                           @"token":[Utils getAppToken]
                           };
    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/%@",[Utils getUserID],self.collectionID];
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetCollectionInfo param:dict appendString:appendString completeHandler:^(id object) {
        
        
        self.collectionModel = [[ConnectionManager dataManager] collectionModels];
        self.arrPostList = [[NSMutableArray alloc]initWithArray:self.collectionModel.arrayPost];
        _arrCellSize = nil;
        [LoadingManager hide];
        
        [self.ibTableView reloadData];
    } errorBlock:^(id object) {
        [LoadingManager hide];
        
    }];
    

}

-(void)showPostDetailView:(NSIndexPath*)indexPath
{
    DraftModel* model = self.arrPostList[indexPath.row];
    [self.feedV2DetailViewController GetPostID:model.post_id];
    [self.navigationController pushViewController:self.feedV2DetailViewController animated:YES];

}
@end
