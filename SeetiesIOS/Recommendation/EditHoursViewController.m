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
@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblTo;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

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

-(NSArray*)arrOpeningTime
{
    if (!_arrOpeningTime) {
        
        NSMutableArray* array = [NSMutableArray new];
        
        for (int i = 0; i< 7; i++) {
            OperatingHoursModel* model = [OperatingHoursModel new];
            model.open = [self getDayTimeModel:i];
            model.close = [self getDayTimeModel:i];
            model.isOpen = NO;
            [array addObject:model];
        }
        _arrOpeningTime = array;
        
    }
    return _arrOpeningTime;
}

-(DayTimeModel*)getDayTimeModel:(int)day
{
    DayTimeModel* model = [DayTimeModel new];
    model.day = day;
    model.time = 1200;
    
    return model;
}

-(void)processOperatingHour:(NSArray*)array
{

    if (![Utils isArrayNull:array]) {

        NSMutableArray* arrayTemp = [[NSMutableArray alloc]initWithArray:self.arrOpeningTime];
        
        for (int j = 0; j<array.count; j++) {
       
            OperatingHoursModel* modelOutter  = array[j];
            modelOutter.isOpen = YES;
            for (int i  = 0; i<arrayTemp.count; i++) {
                OperatingHoursModel* model  = arrayTemp[i];
                if (modelOutter.open.day == model.open.day) {
                    model = modelOutter;
                   [arrayTemp replaceObjectAtIndex:i withObject:modelOutter];
                    break;
                }
                
            }
            
        }
        
        [self.arrOpeningTime removeAllObjects];
        [self.arrOpeningTime addObjectsFromArray:arrayTemp];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self changeLanguage];
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{

    [self initTableViewWithDelegate:self];
    
   
}

-(void)initData:(NSMutableArray*)arrayModel
{
    NSArray* tempArray;
    if (arrayModel) {
        tempArray = [arrayModel sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            
            
            OperatingHoursModel* first = (OperatingHoursModel*)obj1;
            OperatingHoursModel* second = (OperatingHoursModel*)obj2;
            
            if (first.open.day < second.open.day)
                return NSOrderedAscending;
            else if (first.open.day > second.open.day)
                return NSOrderedDescending;
            else
                return NSOrderedSame;

        }];
        
       // self.arrOpeningTime = [[NSMutableArray alloc]initWithArray:tempArray];

    }
    [self processOperatingHour:tempArray];
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
        
        OperatingHoursModel* model = [cell saveData];
        
        
        if (model.isOpen) {
            [array addObject:[cell saveData]];

        }
    }
    return array;
}

#pragma mark - change language
-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Edit Business Hours");
    self.lblTime.text = LocalisedString(@"Business hours as per local time");
    self.lblFrom.text = LocalisedString(@"From");
    self.lblTo.text = LocalisedString(@"To");

}

@end
