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

@end

@implementation SuggestedCollectionPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
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
        _arrPostList = [[NSMutableArray alloc]initWithArray:@[@"123",@"123",@"2222"]];
    }
    
    return _arrPostList;
}
#pragma mark - UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [SuggestedCollectionPostTableViewCell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SuggestedCollectionPostTableViewCell getHeight];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrPostList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuggestedCollectionPostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestedCollectionPostTableViewCell"];
    
    return cell;
}


@end
