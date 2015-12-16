//
//  SeetiShopListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/10/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeetiShopListingViewController.h"
#import "SeetiShopListTableViewCell.h"
#import "SeetiesShopViewController.h"
@class SeetiesShopViewController;


@interface SeetiShopListingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)SeetiesShopViewController* seetiesShopViewController;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic)SeetiShopsModel *seetiShopsModel;
@property(nonatomic,strong)NSString* seetiesID;
@property(nonatomic,strong)NSString* placeID;
@property(nonatomic,strong)NSString* postID;
@property(nonatomic,assign)float shoplat;
@property(nonatomic,assign)float shopLgn;
// ===================      Model       ===============//
@property(nonatomic,strong)NSMutableArray* arrShopList;
@end

@implementation SeetiShopListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTableViewDelegate];
    
    [[SearchManager Instance]getCoordinateFromGPSThenWifi:^(CLLocation *currentLocation) {
        
        self.shoplat = currentLocation.coordinate.latitude;
        self.shopLgn = currentLocation.coordinate.longitude;
        
        [self requestServerForSeetiShopNearbyShop];
        
    } errorBlock:^(NSString *status) {
        [self requestServerForSeetiShopNearbyShop];
        
    }];

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
    cell.lblTitle.text = model.name;
   
    cell.lblDesc.text = [NSString stringWithFormat:@"%@ • %@",[Utils getDistance:model.location.distance Locality:model.location.locality],model.location.formatted_address];
   
    [cell setIsOpen:model.location.opening_hours.open_now];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _seetiesShopViewController = nil;
    
    ShopModel* model = self.arrShopList[indexPath.row];
    [self.seetiesShopViewController initDataWithSeetiesID:model.seetishop_id Latitude:[model.location.lat floatValue] Longitude:[model.location.lng floatValue]];
    [self.navigationController pushViewController:self.seetiesShopViewController animated:YES];
}

-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID
{
    self.seetiesID = seetiesID;
    self.placeID = placeID;
    self.postID = postID;
}

#pragma mark - Declaration

-(SeetiesShopViewController*)seetiesShopViewController
{
    if (!_seetiesShopViewController) {
        _seetiesShopViewController = [SeetiesShopViewController new];
    }
    return _seetiesShopViewController;
    
}

#pragma mark - Server Request

-(void)requestServerForSeetiShopNearbyShop
{
    NSDictionary* dict;
    NSString* appendString;
    
    if (![Utils stringIsNilOrEmpty:self.seetiesID]) {
        appendString = [NSString stringWithFormat:@"%@/nearby/shops",self.seetiesID];
        dict = @{@"limit":@(ARRAY_LIST_SIZE),
                 @"offset":@"1",
                 @"lat":@(self.shoplat),
                 @"lng":@(self.shopLgn),
                 @"lat" : @(self.shoplat),
                 @"lng" : @(self.shopLgn),
                 };

    }
    else{
        appendString = [NSString stringWithFormat:@"%@/nearby/shops",self.placeID];
        dict = @{@"limit":@(ARRAY_LIST_SIZE),
                 @"offset":@"1",
                 @"post_id":self.postID,
                 @"lat" : @(self.shoplat),
                 @"lng" : @(self.shopLgn),
                 };

    }
    
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
