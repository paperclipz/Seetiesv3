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

@end

@implementation GeneralFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.ibFilterCollection registerNib:[UINib nibWithNibName:@"FilterCategoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FilterCategoryCollectionCell"];
    [self.ibFilterCollection registerNib:[UINib nibWithNibName:@"FilterBudgetCell" bundle:nil] forCellWithReuseIdentifier:@"FilterBudgetCell"];
    [self.ibFilterCollection registerNib:[UINib nibWithNibName:@"FilterHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderCollectionReusableView"];
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
    if (section==0) {
        return 1;
    }
    else{
        return 6;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section==0 && row == 0) {
        FilterBudgetCell *budgetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterBudgetCell" forIndexPath:indexPath];
        [budgetCell configureSliderWithMinValue:0 maxValue:100 stepValue:5 stepValueContinuously:YES];
        
        return budgetCell;
    }
    else{
        FilterCategoryCollectionCell *categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCategoryCollectionCell" forIndexPath:indexPath];
    
        return categoryCell;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    if (section==0) {
        return CGSizeMake(collectionView.frame.size.width-10, 80);
    }
    else{
        CGFloat width = (collectionView.frame.size.width-20)/3;
        return CGSizeMake(width, 30);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    FilterHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeaderCollectionReusableView" forIndexPath:indexPath];
    
    return header;
}


@end
