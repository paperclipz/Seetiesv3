//
//  VoucherListingViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "VoucherListingViewController.h"

@interface VoucherListingViewController ()
@property NSArray *voucherArray;
@property (weak, nonatomic) IBOutlet UILabel *ibUserLocationLbl;
@property (weak, nonatomic) IBOutlet UITableView *ibVoucherTable;
@property (weak, nonatomic) IBOutlet UIView *ibFilterView;

@end

@implementation VoucherListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _voucherArray = @[@"1",@"2",@"3",@"4"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.voucherArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoucherCell *voucherCell = [tableView dequeueReusableCellWithIdentifier:@"VoucherCell"];
    
    if (!voucherCell) {
        [tableView registerNib:[UINib nibWithNibName:@"VoucherCell" bundle:nil] forCellReuseIdentifier:@"VoucherCell"];
        voucherCell = [tableView dequeueReusableCellWithIdentifier:@"VoucherCell"];
    }
    
    return voucherCell;
}

- (IBAction)filterClicked:(id)sender {
    NSInteger filterTag = 1001;
    UIView *filterView = [self.view viewWithTag:filterTag];
    
    if (filterView == nil) {
        GeneralFilterViewController *filterController = [[GeneralFilterViewController alloc] init];
        CGFloat yOrigin = self.ibFilterView.frame.origin.y + self.ibFilterView.frame.size.height;
        CGFloat filterHeight = self.view.frame.size.height - yOrigin;
        CGRect filterRect = CGRectMake(0, yOrigin, self.view.frame.size.width, filterHeight);
        filterController.view.frame = filterRect;
        filterController.view.tag = filterTag;
        [self.view addSubview:filterController.view];
    }
    else{
        if (filterView.hidden) {
            filterView.hidden = NO;
        }
        else{
            filterView.hidden = YES;
        }
    }
}

@end
