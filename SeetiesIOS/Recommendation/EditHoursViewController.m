//
//  EditHoursViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/27/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditHoursViewController.h"
#import "EditHourTableViewCell.h"
@interface EditHoursViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EditHoursViewController
- (IBAction)btnBackClicked:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (IBAction)btnDoneClicked:(id)sender {
    
    if (_backBlock) {
        self.backBlock([self saveData]);
        [self dismissViewControllerAnimated:YES completion:nil];

    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{

    [self initTableViewWithDelegate:self];
    
    
}

-(void)initData:(NSMutableArray*)arrayModel
{

    if (arrayModel) {
        NSArray* tempArray = [arrayModel sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            
            
            OperatingHoursModel* first = (OperatingHoursModel*)obj1;
            OperatingHoursModel* second = (OperatingHoursModel*)obj2;
            
            if (first.open.day < second.open.day)
                return NSOrderedAscending;
            else if (first.open.day > second.open.day)
                return NSOrderedDescending;
            else
                return NSOrderedSame;

        }];
        
        self.arrOpeningTime = [[NSMutableArray alloc]initWithArray:tempArray];

    }
}

-(void)initTableViewWithDelegate:(id)delegate
{
    self.tableView.delegate = delegate;
    self.tableView.dataSource = delegate;
    [self.tableView registerClass:[EditHourTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EditHourTableViewCell class])];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrOpeningTime.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditHourTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EditHourTableViewCell class])];
    
    
    cell.model = self.arrOpeningTime[indexPath.row];
   
    [cell initData];
    return cell;
}

#pragma mark - Save Data

-(NSArray*)saveData
{
    NSMutableArray* array = [NSMutableArray new];
    for (int i = 0; i<[self.tableView numberOfRowsInSection:0]; i++) {

        EditHourTableViewCell* cell = (EditHourTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [array addObject:[cell saveData]];
    }
    return array;
}

@end
