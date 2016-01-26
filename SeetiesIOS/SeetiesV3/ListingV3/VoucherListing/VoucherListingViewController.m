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
@property (strong, nonatomic)GeneralFilterViewController* filterController;
@end

@implementation VoucherListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _voucherArray = @[@"1",@"2",@"3",@"4"];
    [self.ibVoucherTable registerNib:[UINib nibWithNibName:@"VoucherCell" bundle:nil] forCellReuseIdentifier:@"VoucherCell"];
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
    
    return voucherCell;
}

- (IBAction)filterClicked:(id)sender {
    
    
    GeneralFilterViewController *filterController = [[GeneralFilterViewController alloc] initWithFilter:[self getDummy]];
    
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:filterController];
    [self presentViewController:nav animated:YES completion:nil];
//    self.filterController.view.hidden =  !self.filterController.view.hidden;
}

-(NSArray*)getDummy{
    NSDictionary *catFilter = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"Category", @"type",
                               @[@"1", @"2", @"3", @"4", @"5"], @"array", nil];
    NSDictionary *sortFilter = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"Sort", @"type",
                               @[@"1", @"2", @"3"], @"array", nil];
    NSDictionary *priceFilter = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"Price", @"type",
                               @"0", @"min",
                               @"100", @"max", nil];
    
    NSDictionary *priceFilter1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Price", @"type",
                                 @"0", @"min",
                                 @"100", @"max", nil];

    
    NSDictionary *priceFilter2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Price", @"type",
                                 @"0", @"min",
                                 @"100", @"max", nil];

    
    NSDictionary *priceFilter3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Price", @"type",
                                 @"0", @"min",
                                 @"100", @"max", nil];

    
    NSDictionary *priceFilter4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Price", @"type",
                                 @"0", @"min",
                                 @"100", @"max", nil];

    
    NSArray *filterArray = @[sortFilter, catFilter, priceFilter,priceFilter1,priceFilter2,priceFilter3,priceFilter4];
    return filterArray;
}

-(GeneralFilterViewController*)filterController
{
    if (!_filterController) {
        _filterController = [GeneralFilterViewController new];
        
        [self.view addSubview:_filterController.view];
        
        _filterController.view.hidden = YES;
        CGFloat yOrigin = self.ibFilterView.frame.origin.y + self.ibFilterView.frame.size.height;
        [_filterController.view setY:yOrigin];
        [_filterController.view setHeight:self.view.frame.size.height - yOrigin];        
        [_filterController.view setWidth:self.view.frame.size.width];

    }
    
    return _filterController;
}
@end
