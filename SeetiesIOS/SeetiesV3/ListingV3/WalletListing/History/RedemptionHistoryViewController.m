//
//  RedemptionHistoryViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 05/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "RedemptionHistoryViewController.h"

@interface RedemptionHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ibHistoryTable;

@property(nonatomic) NSArray *voucherArray;

@end

@implementation RedemptionHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    
    [self.ibHistoryTable registerNib:[UINib nibWithNibName:@"RedemptionHistoryCell" bundle:nil] forCellReuseIdentifier:@"RedemptionHistoryCell"];
    self.ibHistoryTable.estimatedRowHeight = [RedemptionHistoryCell getHeight];
    self.ibHistoryTable.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    NSArray *dummyArray = @[@"",@"",@"",@"",@"",@"",@""];
    
    _voucherArray = @[dummyArray, dummyArray, dummyArray, dummyArray];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray*)[self.voucherArray objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedemptionHistoryCell *voucherCell = [tableView dequeueReusableCellWithIdentifier:@"RedemptionHistoryCell"];
    return voucherCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.voucherArray.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    WalletHeaderCell *header = [tableView dequeueReusableCellWithIdentifier:@"WalletHeaderCell"];
    
    if (!header) {
        [tableView registerNib:[UINib nibWithNibName:@"WalletHeaderCell" bundle:nil] forCellReuseIdentifier:@"WalletHeaderCell"];
        header = [tableView dequeueReusableCellWithIdentifier:@"WalletHeaderCell"];
    }
    
    return header;
}

@end
