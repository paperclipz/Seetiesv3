//
//  SelectCategoryViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/24/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "SelectCategoryCollectionViewCell.h"

@interface SelectCategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property(nonatomic)NSArray* arrCategories;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@end

@implementation SelectCategoryViewController

- (IBAction)btnDoneClicked:(id)sender {
    
    if (![self processSelectedCategory]) {
        [TSMessage showNotificationInViewController:self title:@"" subtitle:LocalisedString(@"PleaseSelectatleast1category") type:TSMessageNotificationTypeError];
    }else{
        [self requestServerToUpdateUserInfo:self.arrCategories];
    }
}

#pragma mark - Declaration

-(NSArray*)arrCategories
{
    if (!_arrCategories) {
        _arrCategories = [NSArray new];
    }
    
    return _arrCategories;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    [[ConnectionManager Instance]requestServerForAppInfo:^(id object) {
        
        @try {
            AppInfoModel* model = [[ConnectionManager dataManager]appInfoModel];
            self.arrCategories = model.categories;
            
            [self.ibCollectionView reloadData];
        }
        @catch (NSException *exception) {
            
        }
       
        
        
    } FailBlock:^(id object) {
        
        SLog(@"Fail to load");
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[SelectCategoryCollectionViewCell class] forCellWithReuseIdentifier:@"SelectCategoryCollectionViewCell"];
    
    self.ibCollectionView.backgroundColor = [UIColor clearColor];
    
    [self changeLanguage];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrCategories.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCategoryCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectCategoryCollectionViewCell" forIndexPath:indexPath];
    
    CategoryModel* cModel = self.arrCategories[indexPath.row];
    [cell initData:cModel];
    
 //   cell.SelectCategoryCollectionViewCell sd_setImageWithURL:[NSURL URLWithString:cModel.]
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [Utils getDeviceScreenSize];
    
    float width = (frame.size.width/3);
    
    return CGSizeMake(width, 140.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel* model = self.arrCategories[indexPath.row];
    
    model.isSelected = !model.isSelected;
    
    [collectionView reloadData];
}


-(BOOL)processSelectedCategory
{
    
    for (int i = 0; i<self.arrCategories.count; i++) {
        CategoryModel* model = self.arrCategories[i];
        
        if (model.isSelected) {
            return YES;
        }
    }
    
    return NO;
   
}
-(void)changeLanguage
{
    [self.btnDone setTitle:LocalisedString(@"Done") forState:UIControlStateNormal];
}


#pragma mark - Request Server
-(void)requestServerToUpdateUserInfo:(NSArray*)arrCategories
{
    
    NSMutableArray* array = [NSMutableArray new];
    for (int i = 0; i<arrCategories.count; i++) {
        CategoryModel* model = arrCategories[i];
        
        if (model.isSelected) {
            [array addObject:@(model.category_id)];
        }
    }
    
    NSString * result = [[array valueForKey:@"description"] componentsJoinedByString:@","];
    
    CLLocation* location = [[SearchManager Instance]getAppLocation];
    
    
    NSArray* arrLanguages = @[[Utils getDeviceAppLanguageCode]];
    NSDictionary* dict;
    @try {
        
        dict = @{@"uid" : [Utils getUserID],
                               @"categories" : result,
                               @"system_language" : [Utils getDeviceAppLanguageCode],
                               @"languages" :arrLanguages,
                               @"lat" : @(location.coordinate.latitude),
                               @"lng" : @(location.coordinate.longitude),
                               @"token":[Utils getAppToken],
                 };
    }
    @catch (NSException *exception) {
        SLog(@"fail to get dictionary");
    }
    
    NSString* appendString = [NSString stringWithFormat:@"%@/provisioning",[Utils getUserID]];
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostProvisioning param:dict appendString:appendString completeHandler:^(id object) {
       
        if (self.didFinishProvisioningBlock) {
            self.didFinishProvisioningBlock();
        }

    } errorBlock:^(id object) {
        
    }];
    
}

@end
