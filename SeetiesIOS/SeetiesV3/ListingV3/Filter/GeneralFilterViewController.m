//
//  GeneralFilterViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "GeneralFilterViewController.h"

@interface GeneralFilterViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *ibFilterCollection;
@property (weak, nonatomic) IBOutlet UILabel *ibFilterTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibFilterResetBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibApplyFilterBtn;
@property (nonatomic) FiltersModel *filtersModel;
@property (nonatomic) SortType initialSort;
@property (nonatomic) NSString *initialCat;
@end

@implementation GeneralFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.ibFilterCollection registerNib:[UINib nibWithNibName:@"FilterCategoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FilterCategoryCollectionCell"];
    [self.ibFilterCollection registerNib:[UINib nibWithNibName:@"FilterBudgetCell" bundle:nil] forCellWithReuseIdentifier:@"FilterBudgetCell"];
    [self.ibFilterCollection registerNib:[UINib nibWithNibName:@"FilterAvailabilityCell" bundle:nil] forCellWithReuseIdentifier:@"FilterAvailabilityCell"];
    [self.ibFilterCollection registerNib:[UINib nibWithNibName:@"FilterHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderCollectionReusableView"];
//    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)changeLanguage{
    self.ibFilterTitleLbl.text = LocalisedString(@"Filter");
    [self.ibApplyFilterBtn setTitle:LocalisedString(@"ApplyFilter") forState:UIControlStateNormal];
    [self.ibFilterResetBtn setTitle:LocalisedString(@"Reset") forState:UIControlStateNormal];
}

-(void)initWithFilter:(FiltersModel *)filtersModel{
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
                
            case FilterTypeCat:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        self.initialCat = filter.filterId;
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

-(void)updateFooterView{
    BOOL enableFilter = NO;
    for (FilterCategoryModel *filterCategory in self.filtersModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeCat:
            {
                for (FilterModel *filterModel in filterCategory.filtersArray) {
                    if (filterModel.isSelected) {
                        enableFilter = YES;
                        break;
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    if (enableFilter) {
        self.ibApplyFilterBtn.enabled = YES;
        self.ibApplyFilterBtn.backgroundColor = DEVICE_COLOR;
    }
    else{
        self.ibApplyFilterBtn.enabled = NO;
        self.ibApplyFilterBtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
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

#pragma mark - IBAction
- (IBAction)applyFilterBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(applyFilterClicked:)]) {
        [self.delegate applyFilterClicked:self.filtersModel];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
                    if ([filter.filterId isEqualToString:self.initialCat]) {
                        filter.isSelected = YES;
                    }
                    else{
                        filter.isSelected = NO;
                    }
                }
            }
                break;
                
            case FilterTypePrice:
            {
                FilterModel *priceModel = filterCategory.filtersArray[0];
                priceModel.filterPrice.selectedMin = priceModel.filterPrice.min;
                priceModel.filterPrice.selectedMax = priceModel.filterPrice.max;
            }
                break;
                
            case FilterTypeIsOpen:
            {
                FilterModel *filter = filterCategory.filtersArray[0];
                filter.isSelected = NO;
            }
                
            default:
                break;
        }
    }
    [self.ibFilterCollection reloadData];
}

#pragma mark - DelegateImplementation
-(void)switchValueChanged:(FilterModel *)filterModel{
    for (FilterCategoryModel *filterCategory in self.filtersModel.filterCategories) {
        if (filterCategory.filterCategoryType == FilterTypeIsOpen) {
            filterCategory.filtersArray[0] = filterModel;
            break;
        }
    }
}

-(void)sliderChangedValue:(FilterModel *)filterModel{
    for (FilterCategoryModel *filterCategory in self.filtersModel.filterCategories) {
        if (filterCategory.filterCategoryType == FilterTypePrice) {
            filterCategory.filtersArray[0] = filterModel;
            break;
        }
    }
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    FilterCategoryModel *filterCategory = self.filtersModel.filterCategories[section];
    return filterCategory.filtersArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    FilterCategoryModel *filterCategory = self.filtersModel.filterCategories[section];
    
    switch (filterCategory.filterCategoryType) {
        case FilterTypeSort:
        {
            FilterCategoryCollectionCell *sortCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCategoryCollectionCell" forIndexPath:indexPath];
            [sortCell initCellData:filterCategory.filtersArray[row]];
            return sortCell;
        }
            
        case FilterTypeCat:
        {
            FilterCategoryCollectionCell *catCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCategoryCollectionCell" forIndexPath:indexPath];
            [catCell initCellData:filterCategory.filtersArray[row]];
            return catCell;
        }
            
        case FilterTypePrice:
        {
            FilterBudgetCell *priceCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterBudgetCell" forIndexPath:indexPath];
            [priceCell initCellData:filterCategory.filtersArray[row]];
            return priceCell;
        }
            
        case FilterTypeIsOpen:
        {
            FilterAvailabilityCell *availabilityCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterAvailabilityCell" forIndexPath:indexPath];
            [availabilityCell initCellData:filterCategory.filtersArray[row]];
            return availabilityCell;
        }
            
        default:
            return nil;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.filtersModel.filterCategories.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    FilterCategoryModel *filterCategory = self.filtersModel.filterCategories[section];
    
    switch (filterCategory.filterCategoryType) {
        case FilterTypePrice:
            return CGSizeMake(collectionView.frame.size.width, 80);
            
        case FilterTypeIsOpen:
            return CGSizeMake(collectionView.frame.size.width, 50);
            
        default:
        {
            CGFloat width = (collectionView.frame.size.width-64)/3;
            return CGSizeMake(width, 52);
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    FilterCategoryModel *filterCategory = self.filtersModel.filterCategories[section];
    
    FilterHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderCollectionReusableView" forIndexPath:indexPath];
    [header initHeaderData:filterCategory];
    
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    FilterCategoryModel *filterCategory = self.filtersModel.filterCategories[section];

    if (filterCategory.filterCategoryType == FilterTypeIsOpen) {
        return CGSizeMake(0, 0);
    }
    else{
        return CGSizeMake(collectionView.frame.size.width, 42);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    FilterCategoryModel *filterCategory = self.filtersModel.filterCategories[section];
    
    if (filterCategory.filterCategoryType == FilterTypeCat) {
        FilterModel *filter = filterCategory.filtersArray[row];
        filter.isSelected = !filter.isSelected;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        if (self.filtersModel.filterViewType == FilterViewTypeShop || self.filtersModel.filterViewType == FilterViewTypeCollection) {
            [self updateFooterView];
        }
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
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
    }
}

@end
