//
//  SearchLTabViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SearchLTabViewController.h"
#import "ProfilePageCollectionTableViewCell.h"
#import "ShopTableViewCell.h"
#import "SeetizensTableViewCell.h"
#import "PostsTableViewCell.h"
@interface SearchLTabViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constFilterHeight;
@property (weak, nonatomic) IBOutlet UIView *FilterView;
@end

@implementation SearchLTabViewController

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
        self.constFilterHeight.constant = 50;
        [self.ibTableView registerClass:[ShopTableViewCell class] forCellReuseIdentifier:@"ShopTableViewCell"];
    }else if ([self.TabType isEqualToString:@"Collection"]){
        self.constFilterHeight.constant = 50;
        [self.ibTableView registerClass:[ProfilePageCollectionTableViewCell class] forCellReuseIdentifier:@"ProfilePageCollectionTableViewCell"];
    }else if ([self.TabType isEqualToString:@"Posts"]){
        self.constFilterHeight.constant = 0;
        [self.ibTableView registerClass:[PostsTableViewCell class] forCellReuseIdentifier:@"PostsTableViewCell"];
    }else{
        self.constFilterHeight.constant = 0;
        [self.ibTableView registerClass:[SeetizensTableViewCell class] forCellReuseIdentifier:@"SeetizensTableViewCell"];
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
    }else if ([self.TabType isEqualToString:@"Collection"]){
        return [ProfilePageCollectionTableViewCell getHeight];
    }else if ([self.TabType isEqualToString:@"Posts"]){
        return [PostsTableViewCell getHeight];
    }else{
        return [SeetizensTableViewCell getHeight];
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
    }else if ([self.TabType isEqualToString:@"Collection"]){
        ProfilePageCollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfilePageCollectionTableViewCell"];
        return cell;
    }else if ([self.TabType isEqualToString:@"Posts"]){
        PostsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PostsTableViewCell"];
        return cell;
    }else{
        SeetizensTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeetizensTableViewCell"];
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
