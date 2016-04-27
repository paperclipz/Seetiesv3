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

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIImageView *ibBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *ibFullContentView;

@end

@implementation CategorySelectionViewController
- (IBAction)btnBackClicked:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];

    [self hide];
}
- (IBAction)btnDoneClicked:(id)sender {
    
    if (_doneClickBlock) {
        
        for (CategoryModel* model in self.arrCategories) {
            if (model.isSelected) {
                self.doneClickBlock(self.arrCategories);
                [self btnBackClicked:sender];
                break;
            }
        }
        
       // [TSMessage showNotificationInViewController:self title:@"System" subtitle:LOCALIZATION(@"No Categories Selected") type:TSMessageNotificationTypeWarning];
        
    }
    

}

-(void)setPreSelectedCategories:(NSArray*)selectedArray
{
    for (int i = 0; i<self.arrCategories.count; i++) {
        CategoryModel* model = self.arrCategories[i];
        int selected;
        int categories = model.category_id;

        for (int j= 0; j<selectedArray.count; j++) {
            selected = [selectedArray[j] intValue];
            SLog(@"array : %d || categories : %d",selected,categories);
            model.isSelected = NO;

            if (selected == categories) {
                
                model.isSelected = YES;
                [self.arrCategories replaceObjectAtIndex:i withObject:model];
                break;
            }
            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self changeLanguage];
    self.view.hidden = true;

    // Do any additional setup after loading the view from its nib.
}

-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Select 2 categories");
    [self.btnDone setTitle:LocalisedString(@"Publish Now") forState:UIControlStateNormal];

}

-(void)initSelfView
{
    CGRect frame = [Utils getDeviceScreenSize];
    self.view.frame = frame;
    [self initTableViewWithDelegate:self];
    [Utils setRoundBorder:self.contentView color:[UIColor clearColor] borderRadius:8.0f];
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
    CategoryModel* model = self.arrCategories[indexPath.row];
    
   
    NSString* defaultLangCode = [Utils getDeviceDefaultLanguageCode];

    cell.lblTitle.text = model.single_line[defaultLangCode];
    [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.selectedImageUrl] placeholderImage:nil];
    cell.ibContentView.backgroundColor = [UIColor colorWithHexValue:model.background_color];
    [cell initData:model];
    cell.ibTickImageView.hidden = !model.isSelected;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel* model = self.arrCategories[indexPath.row];

    if (model.isSelected) {
        model.isSelected = !model.isSelected;
        
        CategoryCollectionViewCell* cell = (CategoryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.ibTickImageView.hidden = !model.isSelected;
    }
    else{
        if ( ![self checkExceedLimitOfSelection]) {
            model.isSelected = !model.isSelected;
            
            CategoryCollectionViewCell* cell = (CategoryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            cell.ibTickImageView.hidden = !model.isSelected;
            
        }
        else
        {
            [TSMessage showNotificationInViewController:self title:@"System" subtitle:@"Exceed Number Of Categories" type:TSMessageNotificationTypeWarning duration:1.0f];
        }

    }
    
   
}


-(BOOL)checkExceedLimitOfSelection
{
    int maxCategoriesLimit = 2;
    int counter = 0;
    for (int i = 0; i< self.arrCategories.count; i++) {
        CategoryModel* model = self.arrCategories[i];
        if (model.isSelected) {
            counter +=1;
        }
        
        if (counter>=maxCategoriesLimit) {
            return YES;
        }
    }
    return false;

}


-(void)show
{
    
    [self show:self.view transparentView:self.ibBackgroundView MovingContentView:self.ibFullContentView];
}

-(void)hide
{
    [self hideWithAnimation:YES MainView:self.view transparentView:self.ibBackgroundView MovingContentView:self.ibFullContentView];
    
}

-(void)show:(UIView*)mainView transparentView:(UIView*)transparentView MovingContentView:(UIView*)mvView
{
    if (mainView.hidden) {
        mainView.hidden = false;
        transparentView.alpha = 0;
        mvView.frame = CGRectMake(0, self.view.frame.size.height,  self.view.frame.size.width,  self.view.frame.size.height);

        [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            mvView.frame = CGRectMake(0, 0,  self.view.frame.size.width,  self.view.frame.size.height);
            transparentView.alpha = 1.0f;
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

-(void)hideWithAnimation:(BOOL)isAnimate MainView:(UIView*)mainView transparentView:(UIView*)transparentView MovingContentView:(UIView*)mvView
{
    if (!mainView.hidden) {
        transparentView.alpha = 1.0f;
        
        [UIView animateWithDuration:isAnimate?ANIMATION_DURATION:0 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            mvView.frame = CGRectMake(0, self.view.frame.size.height,  self.view.frame.size.width,  self.view.frame.size.height);
            transparentView.alpha = 0;
            
        } completion:^(BOOL finished) {
            mainView.hidden = true;
            
        }];
    }
    
    
}
@end
