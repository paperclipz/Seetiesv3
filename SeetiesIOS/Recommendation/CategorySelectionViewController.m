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
{
    BOOL isShow;

}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIImageView *ibBackgroundView;

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
        int categories = model.id;

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
    // Do any additional setup after loading the view from its nib.
}

-(void)changeLanguage
{
    self.lblTitle.text = LocalisedString(@"Select 2 categories");
    [self.btnDone setTitle:LocalisedString(@"Publish Now") forState:UIControlStateNormal];

}

-(void)initSelfView
{
    isShow =false;
    CGRect frame = [Utils getDeviceScreenSize];
    self.view.frame = CGRectMake(0, frame.size.height,  frame.size.width,  frame.size.height);
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* langOne = [defaults objectForKey:@"UserData_SystemLanguage"];
    cell.lblTitle.text = model.multiple_line[[Utils getLanguageCode:langOne]];
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
    
    if (!isShow) {
        
        self.ibBackgroundView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = CGRectMake(0, 0,  self.view.frame.size.width,  self.view.frame.size.height);
            self.ibBackgroundView.alpha = 1.0f;

        }];
        isShow = true;
    }
    
}

-(void)hide
{
    if (isShow) {
        self.ibBackgroundView.alpha = 1.0f;

        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = CGRectMake(0, self.view.frame.size.height,  self.view.frame.size.width,  self.view.frame.size.height);
            isShow = false;
            self.ibBackgroundView.alpha = 0;

        }];
    }
    
    
}


@end
