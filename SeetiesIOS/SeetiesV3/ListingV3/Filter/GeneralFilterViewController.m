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
@property (strong, nonatomic) NSArray *filterArray;

@end

@implementation GeneralFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.ibFilterCollection registerNib:[UINib nibWithNibName:@"FilterCategoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FilterCategoryCollectionCell"];
    [self.ibFilterCollection registerNib:[UINib nibWithNibName:@"FilterBudgetCell" bundle:nil] forCellWithReuseIdentifier:@"FilterBudgetCell"];
    [self.ibFilterCollection registerNib:[UINib nibWithNibName:@"FilterHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderCollectionReusableView"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _filterArray = nil;
    }
    return self;
}

-(id)initWithFilter:(NSArray *)filterArray{
    self = [super init];
    
    if (self) {
        _filterArray = filterArray;
    }
    
    return self;
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *filterDict = [self.filterArray objectAtIndex:section];
    NSString *type = [filterDict objectForKey:@"type"];
    
    if ([type isEqualToString:@"Price"]) {
        return 1;
    }
    else{
        return ((NSArray*)[filterDict objectForKey:@"array"]).count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSDictionary *filterDict = [self.filterArray objectAtIndex:section];
    NSString *type = [filterDict objectForKey:@"type"];
    
    if ([type isEqualToString:@"Price"]) {
        FilterBudgetCell *budgetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterBudgetCell" forIndexPath:indexPath];
        NSInteger minValue = [[filterDict objectForKey:@"min"] intValue];
        NSInteger maxValue = [[filterDict objectForKey:@"max"] intValue];
        [budgetCell configureSliderWithMinValue:minValue maxValue:maxValue stepValue:5 stepValueContinuously:YES];
        
        return budgetCell;
    }
    else{
        FilterCategoryCollectionCell *categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCategoryCollectionCell" forIndexPath:indexPath];
        NSArray *array = [filterDict objectForKey:@"array"];
        NSString *catText = [array objectAtIndex:row];
        [categoryCell setButtonText:catText];
        
        return categoryCell;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.filterArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSDictionary *filterDict = [self.filterArray objectAtIndex:section];
    NSString *type = [filterDict objectForKey:@"type"];
    
    if ([type isEqualToString:@"Price"]) {
        return CGSizeMake(collectionView.frame.size.width-10, 80);
    }
    else{
        CGFloat width = (collectionView.frame.size.width-20)/3;
        return CGSizeMake(width, 30);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSDictionary *filterDict = [self.filterArray objectAtIndex:section];
    NSString *type = [filterDict objectForKey:@"type"];
    
    FilterHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderCollectionReusableView" forIndexPath:indexPath];
    [header setHeaderText:type];
    
    return header;
}


@end
