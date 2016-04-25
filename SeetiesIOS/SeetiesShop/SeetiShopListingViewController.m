//
//  SeetiShopListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/10/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeetiShopListingViewController.h"
#import "PromoOutletCell.h"
#import "SeetiesShopViewController.h"
#import "UITableView+Extension.h"
#import "UITableView+emptyState.h"

@class SeetiesShopViewController;


@interface SeetiShopListingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isServerMiddleOfLoading;
}
@property(nonatomic,strong)SeetiesShopViewController* seetiesShopViewController;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic)SeShopsModel *seetiShopsModel;
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
    
    [self.ibTableView setupCustomEmptyView];
    [self.ibTableView setupFooterView];
    isServerMiddleOfLoading= NO;
    // Do any additional setup after loading the view from its nib.
    [self initTableViewDelegate];
    
    self.shoplat = [[SearchManager Instance]getAppLocation].coordinate.latitude;
    self.shopLgn = [[SearchManager Instance]getAppLocation].coordinate.longitude;
    [self changLanguage];
    
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[PromoOutletCell class] forCellReuseIdentifier:@"PromoOutletCell"];
    self.ibTableView.estimatedRowHeight = [PromoOutletCell getHeight];
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrShopList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [PromoOutletCell getHeight];
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromoOutletCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PromoOutletCell"];
    
    SeShopDetailModel* model = self.arrShopList[indexPath.row];
    [cell setCellType:PromoOutletCellTypeStatus];
    [cell setShopModel:model];
//    [cell drawBorders];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _seetiesShopViewController = nil;
    
    SeShopDetailModel* model = self.arrShopList[indexPath.row];
    [self.seetiesShopViewController initDataWithSeetiesID:model.seetishop_id Latitude:[model.location.lat floatValue] Longitude:[model.location.lng floatValue]];
    [self.navigationController pushViewController:self.seetiesShopViewController animated:YES];
}

-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID
{
    self.seetiesID = seetiesID;
    self.placeID = placeID;
    self.postID = postID;
    
    [self requestServerForSeetiShopNearbyShop];
}

-(void)initWithArray:(NSMutableArray*)shopArray{
    self.arrShopList = shopArray;
    [self.ibTableView reloadData];
    [self.ibTableView hideAll];
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
    
    if (isServerMiddleOfLoading) {
        return;
    }
    NSDictionary* dict;
    NSString* appendString;
    
    if (![Utils stringIsNilOrEmpty:self.seetiesID]) {
        appendString = [NSString stringWithFormat:@"%@/nearby/shops",self.seetiesID];
        dict = @{@"limit":@(ARRAY_LIST_SIZE),
                 @"offset":@(self.seetiShopsModel.offset + self.seetiShopsModel.limit),
                 @"lat" : @(self.shoplat),
                 @"lng" : @(self.shopLgn),
                 };

    }
    else{
        appendString = [NSString stringWithFormat:@"%@/nearby/shops",self.placeID];
        dict = @{@"limit":@(ARRAY_LIST_SIZE),
                 @"offset":@(self.seetiShopsModel.offset + self.seetiShopsModel.limit),
                 @"post_id":self.postID,
                 @"lat" : @(self.shoplat),
                 @"lng" : @(self.shopLgn),
                 };

    }
    
    isServerMiddleOfLoading = YES;
    
    if ([Utils isArrayNull:self.arrShopList]) {
        [self.ibTableView showLoading];
    }
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetSeetoShopNearbyShop parameter:dict appendString:appendString success:^(id object) {
        
            
            self.seetiShopsModel = [[ConnectionManager dataManager]seNearbyShopModel];
            [self.arrShopList addObjectsFromArray:self.seetiShopsModel.shops];
            [self.ibTableView reloadData];
            isServerMiddleOfLoading = NO;
            [self.ibTableView hideAll];


    } failure:^(id object) {
        
            isServerMiddleOfLoading = NO;
            [self.ibTableView hideAll];

        }];
        
}

-(NSMutableArray*)arrShopList
{
    if (!_arrShopList) {
        _arrShopList = [NSMutableArray new];
    }
    return _arrShopList;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= self.view.frame.size.height/2) {
        
        if(![Utils isStringNull:self.seetiShopsModel.paging.next])
        {
            [self.ibTableView startFooterLoadingView];
            [self requestServerForSeetiShopNearbyShop];
        }
        else{
            [self.ibTableView stopFooterLoadingView];
        }
    }
}

#pragma mark - Change Language
-(void)changLanguage
{
    self.lblTitle.text = LocalisedString(self.title);
}
@end
