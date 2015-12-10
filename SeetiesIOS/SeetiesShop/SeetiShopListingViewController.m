//
//  SeetiShopListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/10/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeetiShopListingViewController.h"
#import "SeetiShopListTableViewCell.h"


@interface SeetiShopListingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic)SeetiShopsModel *seetiShopsModel;


// ===================      Model       ===============//
@property(nonatomic,strong)NSMutableArray* arrShopList;
@end

@implementation SeetiShopListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTableViewDelegate];
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[SeetiShopListTableViewCell class] forCellReuseIdentifier:@"SeetiShopListTableViewCell"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrShopList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeetiShopListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeetiShopListTableViewCell"];
    
    ShopModel* model = self.arrShopList[indexPath.row];
    
    if (![model.arrPhotos isNull])
    {
        PhotoModel* photoModel = model.arrPhotos[0];
        [cell.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:photoModel.imageURL] completed:nil];

    }
   
    
    return cell;
}


-(void)initData
{
    [self requestServerForSeetiShopNearbyShop];
}
#pragma mark - Server Request

-(void)requestServerForSeetiShopNearbyShop
{
    
        NSString* appendString = @"56397e301c4d5be92e8b4711/nearby/shops";
        NSDictionary* dict = @{@"limit":@(10),
                               @"offset":@"1",
                               };
        
        [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetoShopNearbyShop param:dict appendString:appendString completeHandler:^(id object) {
            
            
            self.seetiShopsModel = [[ConnectionManager dataManager]seNearbyShopModel];
            [self.arrShopList addObjectsFromArray:self.seetiShopsModel.userPostData.shops];
            [self.ibTableView reloadData];
            
        } errorBlock:^(id object) {
            
            
        }];
        
}

-(NSMutableArray*)arrShopList
{
    if (!_arrShopList) {
        _arrShopList = [NSMutableArray new];
    }
    return _arrShopList;
}

@end
