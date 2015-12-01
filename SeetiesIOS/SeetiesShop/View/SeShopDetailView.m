//
//  SeShopDetailView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeShopDetailView.h"
#import "SeShopDetailTableViewCell.h"
#import "PhotoCollectionViewCell.h"

@interface SeShopDetailView()<UITableViewDataSource,UITableViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    __weak IBOutlet NSLayoutConstraint *tableviewConstraint;
}

@property (weak, nonatomic) IBOutlet UIView *ibInformationMainView;
@property (weak, nonatomic) IBOutlet UIView *ibInformationContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImageView;
@property(nonatomic,strong)NSArray* arrayList;
@property(nonatomic,assign)int counter;
@property(nonatomic,strong)NSMutableArray* arrayCell;
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *ibBtnInformationDetails;
@property (weak, nonatomic) IBOutlet UIView *ibPhotoView;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@end

@implementation SeShopDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initSelfView
{
    //[self initTableViewDelegate];
    [self initCollectionViewDelegate];
    [self initTableViewDelegate];
    [self.ibProfileImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.venusbuzz.com/wp-content/uploads/rekindle-ss2-review-2.jpg"]];
    [self setupViewWithData:10];
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[SeShopDetailTableViewCell class] forCellReuseIdentifier:@"SeShopDetailTableViewCell"];
}
-(void)initCollectionViewDelegate
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    self.ibCollectionView.backgroundColor = [UIColor clearColor];
}

-(void)setupViewWithData:(int)counter
{
    
    tableviewConstraint.constant = (10*[SeShopDetailTableViewCell getHeight]) + 44;
    [self layoutIfNeeded];

    [self setHeight:self.ibTableView.frame.size.height + self.ibTableView.frame.origin.y + VIEW_PADDING];
   // CGRect lastRowRect= [self.ibTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
   // CGFloat contentHeight = lastRowRect.origin.y + lastRowRect.size.height;
    //tableviewConstraint.constant = 700;
  //  [self setHeight:[self getPositionYBelowView:self.ibTableView]];
    
//    self.counter = counter;
//    
//    self.arrayCell = [NSMutableArray new];
//    for (int i = 0; i<counter; i++) {
//        SeShopDetailTableViewCell* cell = [[SeShopDetailTableViewCell alloc]init];
//        [cell setY:i* [SeShopDetailTableViewCell getHeight]];
//        [self.arrayCell addObject:cell];
//    }
//    
//    for (int i = 0; i<self.arrayCell.count; i++) {
//        
//        [self.ibInformationContentView addSubview:self.arrayCell[i]];
//    }
//    
//    if (self.arrayCell) {
//        
//        CGRect rect = [[self.arrayCell lastObject] frame];
//       
//    }
}

-(float)getPositionYBelowView:(UIView*)view
{ 
    float value = view.frame.size.height + view.frame.origin.y;
    return value;
}

-(BOOL)isAvailable
{
    if (self.arrayCell) {
        return YES;
    }
    
    return NO;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeShopDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeShopDetailTableViewCell"];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}



@end
