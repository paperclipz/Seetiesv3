//
//  ShopListingTableViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 07/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ShopListingTableViewController.h"
#import "ProfilePageCollectionTableViewCell.h"
#import "ShopTableViewCell.h"
@interface ShopListingTableViewController (){
}
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@end

@implementation ShopListingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSelfView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initSelfView
{

    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
        
    if ([self.TabType isEqualToString:@"Shops"]) {
        [self.ibTableView registerClass:[ShopTableViewCell class] forCellReuseIdentifier:@"ShopTableViewCell"];
    }else{
    
        [self.ibTableView registerClass:[ProfilePageCollectionTableViewCell class] forCellReuseIdentifier:@"ProfilePageCollectionTableViewCell"];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.TabType isEqualToString:@"Shops"]) {
        
        if (indexPath.row == 2) {
            return [ShopTableViewCell getHeightWithoutImage];

        }
        else{
            return [ShopTableViewCell getHeight];

        }
    }else{
        return [ProfilePageCollectionTableViewCell getHeight];
    }
    
    
}
#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.TabType isEqualToString:@"Shops"]) {
        ShopTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopTableViewCell"];
        
        if (indexPath.row == 2) {
           // [cell setIsOpen:model.location.opening_hours.open_now];
            
            cell.ibDealView.hidden = YES;
            
        }else{
            cell.ibDealView.hidden = NO;
        }
        
        return cell;
    }else{
        ProfilePageCollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfilePageCollectionTableViewCell"];
        return cell;
    }
    
    
//    CollectionModel* collModel = self.arrCollections[indexPath.row];
//    
//    NSString* userID = [Utils getUserID];
//    
//    if ([collModel.user_info.uid isEqualToString:userID]) {
//        
//        [cell initData:collModel profileType:ProfileViewTypeOwn];
//    }
//    
//    else{
//        [cell initData:collModel profileType:ProfileViewTypeOthers];
//        
//    }
//    
//    __weak CollectionModel* weakModel =collModel;
//    
//    cell.btnEditClickedBlock = ^(void)
//    {
//        if (_didSelectEdiCollectionRowBlock) {
//            self.didSelectEdiCollectionRowBlock(weakModel);
//        }
//    };
//    
//    cell.btnFollowBlock = ^(void)
//    {
//        [self requestServerToFollowFromOthersCollection:weakModel];
//    };
    
  //  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
//    CollectionModel* model = self.arrCollections[indexPath.row];
//    if (_didSelectDisplayCollectionRowBlock) {
//        self.didSelectDisplayCollectionRowBlock(model);
//    }
}
@end
