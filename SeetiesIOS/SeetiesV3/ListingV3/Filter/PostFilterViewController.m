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
    [self.ibFilterTable registerNib:[UINib nibWithNibName:@"PostFilterSortCell.h" bundle:nil] forCellReuseIdentifier:@"PostFilterSortCell"];
    [self.ibFilterTable registerNib:[UINib nibWithNibName:@"PostFilterCategoryCell.h" bundle:nil] forCellReuseIdentifier:@"PostFilterCategoryCell"];
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)changeLanguage{
    self.ibFilterTitle.text = LocalisedString(@"Filter");
    [self.ibApplyFilterBtn setTitle:LocalisedString(@"ApplyFilter") forState:UIControlStateNormal];
    [self.ibResetBtn setTitle:LocalisedString(@"Reset") forState:UIControlStateNormal];
}

-(void)initFilterData{
    self.filtersModel = [[FiltersModel alloc] init];
    self.filtersModel.filterCategories = [[NSMutableArray<FilterCategoryModel> alloc] init];
    self.filtersModel.filterViewType = FilterViewTypeSearchShop;
    
    //Sort
    FilterCategoryModel *sortCategory = [[FilterCategoryModel alloc] init];
    sortCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    sortCategory.categoryName = LocalisedString(@"Sort by");
    sortCategory.filterCategoryType = FilterTypeSort;
    
    FilterModel *latest = [[FilterModel alloc] init];
    latest.name = LocalisedString(@"Popular");
    latest.isSelected = YES;
    latest.sortType = SortTypeMostPopular;
    
    FilterModel *distance = [[FilterModel alloc] init];
    distance.name = LocalisedString(@"Distance");
    distance.isSelected = NO;
    distance.sortType = SortTypeNearest;
    
    [sortCategory.filtersArray addObject:latest];
    [sortCategory.filtersArray addObject:distance];
    
    //Category
    FilterCategoryModel *catCategory = [[FilterCategoryModel alloc] init];
    catCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    catCategory.categoryName = LocalisedString(@"Filter by");
    catCategory.filterCategoryType = FilterTypeCat;
    
    AppInfoModel *appInfoModel = [[DataManager Instance] appInfoModel];
    for (CategoryModel *categoryModel in appInfoModel.categories) {
        FilterModel *filter = [[FilterModel alloc] init];
        NSString *languageCode = [Utils getDeviceAppLanguageCode];
        NSString *name = categoryModel.single_line[languageCode];
        filter.name = name? name : @"";
        filter.filterId = [NSString stringWithFormat:@"%d", categoryModel.category_id];
        filter.isSelected = NO;
        filter.imageUrl = categoryModel.defaultImageUrl;
        [catCategory.filtersArray addObject:filter];
    }
    
    [self.filtersModel.filterCategories addObject:sortCategory];
    [self.filtersModel.filterCategories addObject:catCategory];
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
    }
    else if (filterCategoryModel.filterCategoryType == FilterTypeCat){
        PostFilterCategoryCell *catCell = [tableView dequeueReusableCellWithIdentifier:@"PostFilterCategoryCell"];
        [catCell initFilter:filterModel];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
@end
