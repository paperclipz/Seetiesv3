
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

#define Info_Title_Height 44.0f;
@interface SeShopDetailView()<UITableViewDataSource,UITableViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate,MKMapViewDelegate>
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

//================== MAP =======================//
@property(nonatomic,assign)MKCoordinateRegion region;
@property(strong,nonatomic)MKPointAnnotation* annotation;
@property (weak, nonatomic) IBOutlet MKMapView *ibMapView;
@property (weak, nonatomic) IBOutlet UIView *ibMapMainView;
@property (weak, nonatomic) IBOutlet UIView *ibMapInfoView;

@end

@implementation SeShopDetailView

- (IBAction)btnMapClicked:(id)sender {
    if (self.btnMapClickedBlock) {
        self.btnMapClickedBlock();
    }
}

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
    
    self.arrayList = @[@"1",@"2",@"3",@"4",@"5"];
    [self setupViewWithData];
    
    self.ibMapView.delegate = self;
    [Utils setRoundBorder:self.ibMapInfoView color:[UIColor clearColor] borderRadius:5.0f];

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

-(void)setupViewWithData
{
    
    tableviewConstraint.constant = (self.arrayList.count*[SeShopDetailTableViewCell getHeight]) + Info_Title_Height;
    //tableviewConstraint.constant = 0;
    [self layoutIfNeeded];

    [self setHeight:self.ibMapMainView.frame.size.height + self.ibMapMainView.frame.origin.y + VIEW_PADDING];
    
 
    [[SearchManager Instance]getCoordinateFromGPSThenWifi:^(CLLocation *currentLocation) {
        _region.center.longitude = currentLocation.coordinate.longitude;
        _region.center.latitude = currentLocation.coordinate.latitude;
        
        
        [self.annotation setCoordinate:self.region.center];
        
        [self.ibMapView setRegion:self.region animated:YES];
        
    } errorBlock:^(NSString *status) {
        
    }];

   
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
    return self.arrayList.count;
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

#pragma mark - Map
-(MKPointAnnotation*)annotation
{
    if(!_annotation)
    {
        _annotation = [MKPointAnnotation new];
        [_annotation setTitle:@"is This the Location?"]; //You can set the subtitle too
        [self.ibMapView addAnnotation:_annotation];
        
        
    }
    return _annotation;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"pin";
    
    MKAnnotationView *pav = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pav == nil)
    {
        pav = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pav.draggable = NO;
        pav.canShowCallout = NO;
        pav.calloutOffset = CGPointMake(0, 0);
    }
    else
    {
        pav.annotation = annotation;
    }
    pav.image = [UIImage imageNamed:@"PinInMap.png"];
    
    return pav;
}

@end
