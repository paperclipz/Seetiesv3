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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnDoneClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSMutableArray*)arrOpeningTime
{
    
    if (!_arrOpeningTime) {
        NSMutableArray* arr = [NSMutableArray new];
        
        for (int i = 0; i<7; i++) {
            EditHourModel* model = [EditHourModel new];
            model.fromTime = @"7:00 AM";
            model.toTime = @"5:00 PM";
            model.day = [Utils getWeekName:i+1];
            [arr addObject:model];
            
        }
        
        _arrOpeningTime = arr;

    }
       return _arrOpeningTime;
}


@end
