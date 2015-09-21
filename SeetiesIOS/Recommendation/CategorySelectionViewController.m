//
//  CategorySelectionViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/3/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CategorySelectionViewController.h"
#import "CategoryCollectionViewCell.h"
@interface CategorySelectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation CategorySelectionViewController
- (IBAction)btnBackClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)btnDoneClicked:(id)sender {
    
    if (_doneClickBlock) {
        
        for (CategoryModel* model in self.arrCategories) {
            if (model.isSelected) {
                self.doneClickBlock(self.arrCategories);
                break;
            }
        }
        
    }
    
    [self btnBackClicked:sender];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    
    [self initTableViewWithDelegate:self];
    [Utils setRoundBorder:self.contentView color:[Utils defaultTextColor] borderRadius:8.0f];
}

-(void)initTableViewWithDelegate:(id)delegate
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:@"CategoryCollectionViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrCategories.count;

}

#define CellSpacing 2.5
#define ViewLeftiRighPadding (20+ 20 + 2)

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGRect frame = [Utils getDeviceScreenSize];
//    float temp = (frame.size.width-CellSpacing-ViewLeftiRighPadding-20)/3;
//    CGSize cellSize = CGSizeMake(temp, temp);
//    return cellSize;
//    
//    return CGSizeZero;
//}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionViewCell" forIndexPath:indexPath];
    CategoryModel* model = [[[DataManager Instance]categoriesModel] categories][indexPath.row];
    cell.lblTitle.text = model.multiple_line[CHINESE_CODE];
    [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.defaultImageUrl] placeholderImage:nil];
    cell.ibContentView.backgroundColor = [UIColor colorWithHexValue:model.background_color];
    [cell initData:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel* model = [[[DataManager Instance]categoriesModel] categories][indexPath.row];
    model.isSelected = !model.isSelected;
    
    CategoryCollectionViewCell* cell = (CategoryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.ibTickImageView.hidden = !model.isSelected;
    
}


@end
