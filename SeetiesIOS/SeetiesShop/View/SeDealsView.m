//
//  SeDealsView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeDealsView.h"
#import "SeDealsTableViewCell.h"

#define HeaderHeight 44.0f
@interface SeDealsView()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (strong, nonatomic)NSArray *arrList;

@end
@implementation SeDealsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initSelfView
{
    [self initTableViewDelegate];
    self.arrList = @[@"1"];
    float height = HeaderHeight+ ((int)self.arrList.count * [SeDealsTableViewCell getHeight]);
    [self setHeight:height];
    [self layoutIfNeeded];
    
    
    //self.frame = CGRectMake(0, 0, 200, 500);
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[SeDealsTableViewCell class] forCellReuseIdentifier:@"SeDealsTableViewCell"];
    self.ibTableView.frame = CGRectMake(0, 50, 200, 200);
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeDealsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeDealsTableViewCell"];
    return cell;
}

#pragma mark - Request Server
//-(void)requestServerForSeetiShopDeals
//{
//    NSDictionary* param;
//    NSString* appendString = @"56397e301c4d5be92e8b4711";
//    
//    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetiShopDetail param:param appendString:appendString completeHandler:^(id object) {
//        
//        
//        self.seShopModel = [[ConnectionManager dataManager] seShopDetailModel];
//        self.arrayList = self.seShopModel.arrayInformation;
//        [self.ibTableView reloadData];
//        [self setupViewWithData];
//        
//        if (self.viewDidFinishLoadBlock) {
//            self.viewDidFinishLoadBlock();
//        }
//    } errorBlock:^(id object) {
//        
//        
//    }];
//}
@end
