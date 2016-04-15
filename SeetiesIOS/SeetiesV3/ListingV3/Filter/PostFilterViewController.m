//
//  PostFilterViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 14/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PostFilterViewController.h"

@interface PostFilterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ibFilterTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibResetBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibApplyFilterBtn;
@property (weak, nonatomic) IBOutlet UITableView *ibFilterTable;

@property (nonatomic) FiltersModel *filtersModel;
@property (nonatomic) SortType initialSort;
@end

@implementation PostFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.ibFilterTable registerNib:[UINib nibWithNibName:@"PostFilterSortCell" bundle:nil] forCellReuseIdentifier:@"PostFilterSortCell"];
    [self.ibFilterTable registerNib:[UINib nibWithNibName:@"PostFilterCategoryCell" bundle:nil] forCellReuseIdentifier:@"PostFilterCategoryCell"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)changeLanguage{
    self.ibFilterTitle.text = LocalisedString(@"Filter");
    [self.ibApplyFilterBtn setTitle:LocalisedString(@"ApplyFilter") forState:UIControlStateNormal];
    [self.ibResetBtn setTitle:LocalisedString(@"Reset") forState:UIControlStateNormal];
}

-(void)initWithFilter:(FiltersModel*)filtersModel{
    _filtersModel = filtersModel;
    
    for (FilterCategoryModel *filterCategory in self.filtersModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeSort:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        self.initialSort = filter.sortType;
                        break;
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetBtnClicked:(id)sender {
    for (FilterCategoryModel *filterCategory in self.filtersModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeSort:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.sortType == self.initialSort) {
                        filter.isSelected = YES;
                    }
                    else{
                        filter.isSelected = NO;
                    }
                }
            }
                break;
                
            case FilterTypeCat:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    filter.isSelected = NO;
                }
            }
                break;
                
            default:
                break;
        }
    }
    [self.ibFilterTable reloadData];
}

- (IBAction)ibApplyBtnClicked:(id)sender {
    if (self.delegate) {
        [self.delegate postApplyFilterClicked:self.filtersModel];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.filtersModel.filterCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FilterCategoryModel *filterCategoryModel = self.filtersModel.filterCategories[section];
    return filterCategoryModel.filtersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FilterCategoryModel *filterCategoryModel = self.filtersModel.filterCategories[indexPath.section];
    FilterModel *filterModel = filterCategoryModel.filtersArray[indexPath.row];
    
    if (filterCategoryModel.filterCategoryType == FilterTypeSort) {
        PostFilterSortCell *sortCell = [tableView dequeueReusableCellWithIdentifier:@"PostFilterSortCell"];
        [sortCell initFilter:filterModel];
        return sortCell;
    }
    else if (filterCategoryModel.filterCategoryType == FilterTypeCat){
        PostFilterCategoryCell *catCell = [tableView dequeueReusableCellWithIdentifier:@"PostFilterCategoryCell"];
        [catCell initFilter:filterModel];
        return catCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ibFilterTable.frame.size.width, 44)];
    header.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, header.frame.size.width, 21)];
    text.font = [UIFont systemFontOfSize:13];
    text.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    
    FilterCategoryModel *filterCategoryModel = self.filtersModel.filterCategories[section];
    text.text = filterCategoryModel.categoryName;
    
    [header addSubview:text];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    FilterCategoryModel *filterCategory = self.filtersModel.filterCategories[section];
    
    if (filterCategory.filterCategoryType == FilterTypeCat) {
        FilterModel *filter = filterCategory.filtersArray[row];
        filter.isSelected = !filter.isSelected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    else if (filterCategory.filterCategoryType == FilterTypeSort){
        for (int i=0; i<filterCategory.filtersArray.count; i++) {
            FilterModel *filter = filterCategory.filtersArray[i];
            if (i == row) {
                filter.isSelected = YES;
            }
            else{
                filter.isSelected = NO;
            }
        }
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
}
@end
