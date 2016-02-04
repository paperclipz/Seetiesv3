//
//  WalletListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "WalletListingViewController.h"

@interface WalletListingViewController ()
@property NSArray *voucherArray;
@property NSArray *filterArray;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *ibFooterBtn;
@property (weak, nonatomic) IBOutlet UITableView *ibFilterTable;
@property (weak, nonatomic) IBOutlet UIView *ibFilterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibFilterTableHeightConstraint;

@end

@implementation WalletListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _voucherArray = @[@"1",@"2",@"1",@"2"];
    _filterArray = @[@"1",@"2",@"3",@"4",@"5"];
    
    //[self initData];
    self.ibTableView.estimatedRowHeight = [WalletVoucherCell getHeight];
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    if (!self.voucherArray) {
        self.voucherArray = [[NSMutableArray alloc] init];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.ibTableView) {
//        return self.voucherArray.count;
        return 20;

    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ibTableView) {
        WalletVoucherCell *voucherCell = [tableView dequeueReusableCellWithIdentifier:@"WalletVoucherCell"];
        
        if (!voucherCell) {
            [tableView registerNib:[UINib nibWithNibName:@"WalletVoucherCell" bundle:nil] forCellReuseIdentifier:@"WalletVoucherCell"];
            voucherCell = [tableView dequeueReusableCellWithIdentifier:@"WalletVoucherCell"];
        }
        
        return voucherCell;
    }
    else if (tableView == self.ibFilterTable){
        VoucherFilterCellTableViewCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"VoucherFilterCell"];
        
        if (!filterCell) {
            [tableView registerNib:[UINib nibWithNibName:@"VoucherFilterCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"VoucherFilterCell"];
            filterCell = [tableView dequeueReusableCellWithIdentifier:@"VoucherFilterCell"];
        }
        
        return filterCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (IBAction)filterBtnClicked:(id)sender {
    if (self.ibFilterView.hidden) {
        self.ibFilterView.hidden = NO;
        [self adjustHeightOfFilterTable];
    }
    else{
        self.ibFilterView.hidden = YES;
    }
}

- (IBAction)footerBtnClicked:(id)sender {
}

- (void)adjustHeightOfFilterTable
{
    CGFloat height = self.ibFilterTable.contentSize.height;
    CGFloat maxHeight = self.ibFilterTable.superview.frame.size.height - self.ibFilterTable.frame.origin.y;
    
    // if the height of the content is greater than the maxHeight of
    // total space on the screen, limit the height to the size of the
    // superview.
    
    if (height > maxHeight)
        height = maxHeight;
    
    // now set the height constraint accordingly
    
    [UIView animateWithDuration:0.25 animations:^{
        self.ibFilterTableHeightConstraint.constant = height;
        [self.view setNeedsUpdateConstraints];
    }];
}
@end
