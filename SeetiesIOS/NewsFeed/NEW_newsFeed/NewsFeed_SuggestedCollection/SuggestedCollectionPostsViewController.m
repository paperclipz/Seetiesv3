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
-(NSMutableArray*)arrPostList
{
    if (!_arrPostList) {
        _arrPostList = [[NSMutableArray alloc]initWithArray:@[@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum    has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                                              @"Lorem Ipsum is simply dummy text",
                                                              @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                                              @"Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",
                                                              @"There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
                                                           
                                                              ]];
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
    cell.lblDesc.text = self.arrPostList[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {


//    if (self.arrCellSize[indexPath.row] == [NSNull null]) {
//        
//        DraftModel* draftModel = self.arrPostList[indexPath.row];
//       // Post* postModel = draftModel.arrCustomPost[0];
//        CGRect frame = [Utils getDeviceScreenSize];
//        
//        CGRect rect = [postModel.message boundingRectWithSize:frame.size
//                                         options:NSStringDrawingUsesLineFragmentOrigin
//                                      attributes:@{
//                                                   NSFontAttributeName : [UIFont fontWithName:CustomFontName size:17]
//                                                   }
//                                         context:nil];
//        //SLog(@"AAAA = %f",rect.size.height);
//        [self.arrCellSize replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:rect.size.height]];
//
//    }
       return [self.arrCellSize[indexPath.row] floatValue] + 160 + 60;

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
    
    self.collectionID = @"56022ed61c4d5b19038b4627";
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
@end
