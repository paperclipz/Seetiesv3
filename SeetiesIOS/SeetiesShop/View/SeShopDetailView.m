
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

#define Info_Footer_HEader_Height 44+44;
#define MaxDistance 100000

@interface SeShopDetailView()<UITableViewDataSource,UITableViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate,MKMapViewDelegate>
{
   
    __weak IBOutlet UILabel *lblPhotoCount;
    __weak IBOutlet NSLayoutConstraint *tableviewConstraint;
}
//================== Detail =======================//
@property (weak, nonatomic) IBOutlet UILabel *lblShopCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageVerified;
@property (weak, nonatomic) IBOutlet UILabel *lblOpenNow;

//================== Detail =======================//

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
@property (weak, nonatomic) IBOutlet UILabel *lblNearbyTransport;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

//================== MAP =======================//

@property (weak, nonatomic) IBOutlet UILabel *lblNearbyPublicTransport;

@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property(nonatomic,assign)MKCoordinateRegion region;
@property(strong,nonatomic)MKPointAnnotation* annotation;
@property (weak, nonatomic) IBOutlet MKMapView *ibMapView;
@property (weak, nonatomic) IBOutlet UIView *ibMapMainView;
@property (weak, nonatomic) IBOutlet UIView *ibMapInfoView;
// ================== MODEL ======================/
@property(nonatomic,strong)SeShopDetailModel* seShopModel;
@property(nonatomic,strong)SeShopPhotoModel* seShopPhotoModel;


@property(nonatomic,strong)NSString* seetiesID;
@property(nonatomic,strong)NSString* placeID;
@property(nonatomic,strong)NSString* postID;

@end

@implementation SeShopDetailView

- (void)handleTapPress:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.btnMapClickedBlock) {
        self.btnMapClickedBlock(self.seShopModel);
    }
}

- (IBAction)btnMorePhotoClicked:(id)sender {
    
    if (self.didSelectMorePhotosBlock) {
        self.didSelectMorePhotosBlock(self.seShopPhotoModel);
    }
}

- (IBAction)btnMoreInfoClicked:(id)sender {
    if (self.btnMoreInfoClickedBlock) {
        self.btnMoreInfoClickedBlock(self.seShopModel);
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
    [self initCollectionViewDelegate];
    [self initTableViewDelegate];
    self.ibMapView.delegate = self;
    
    self.ibMapView.zoomEnabled = NO;
    self.ibMapView.scrollEnabled = NO;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleTapPress:)];
    tgr.numberOfTapsRequired = 1;
    tgr.numberOfTouchesRequired = 1;
    [self.ibMapView addGestureRecognizer:tgr];
   

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
    
    float constant =  (self.arrayList.count*[SeShopDetailTableViewCell getHeight]) + Info_Footer_HEader_Height;
    tableviewConstraint.constant = constant;
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    [self setHeight:self.ibMapMainView.frame.size.height + self.ibMapMainView.frame.origin.y + VIEW_PADDING];

    
    
    self.lblShopName.text = self.seShopModel.name;
    self.lblShopCategory.text = self.seShopModel.category.title;
    
    self.lblAddress.text = self.seShopModel.location.formatted_address;
    self.lblNearbyPublicTransport.text = self.seShopModel.nearby_public_transport;
    if(self.seShopModel.location.distance <= MaxDistance)
    {
        self.lblDistance.text = [NSString stringWithFormat:@"%.1f KM",self.seShopModel.location.distance/100];

    }
    else{
        self.lblDistance.text = self.seShopModel.location.locality;

    }
    
    lblPhotoCount.text = [NSString stringWithFormat:@"%@ (%d)",LocalisedString(@"Photos"),self.seShopPhotoModel.total_photos];

    
    self.ibImageVerified.hidden = [Utils stringIsNilOrEmpty:self.seShopModel.seetishop_id];
    
    if (self.seShopModel.location.opening_hours.open_now) {
        self.lblOpenNow.textColor = UIColorFromRGB(156, 204, 101, 1);
        self.lblOpenNow.text = LocalisedString(@"Open Now");
    }
    else{
        self.lblOpenNow.textColor = UIColorFromRGB(248, 76, 76, 1);
        self.lblOpenNow.text = LocalisedString(@"Closed");

    }
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
    
    
    NSDictionary* dict = self.arrayList[indexPath.row];
    NSArray* keys = [dict allKeys];
    
    NSString* key = keys[0];

    cell.lblTitle.text = key;
    [cell setImage:key];
    cell.lblDesc.text = [dict objectForKey:key];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Assuming view is at zero index of XIB file.
    // this view will contain all lable and other controls
    CGRect myRect = [tableView rectForRowAtIndexPath:indexPath];
    
    if (self.didSelectInformationAtRectBlock) {
        self.didSelectInformationAtRectBlock(tableView,myRect);
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.seShopPhotoModel.photos.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    
    
    SePhotoModel* model = self.seShopPhotoModel.photos[indexPath.row];
    [cell.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:model.imageURL] completed:^(UIImage *image) {
       
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectMorePhotosBlock) {
        self.didSelectMorePhotosBlock(self.seShopPhotoModel);
    }
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

#pragma mark - Server

-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID
{

    self.seetiesID = seetiesID;
    self.placeID = placeID;
    self.postID = postID;
    
    [self.ibProfileImageView sd_setImageCroppedWithURL:[NSURL URLWithString:@"http://www.bangsarbabe.com/wp-content/uploads/2014/05/81.jpg"] completed:^(UIImage *image){
        
        if (self.imageDidFinishLoadBlock) {
            self.imageDidFinishLoadBlock(image);
        }
    }];
    
    [Utils setRoundBorder:self.ibMapInfoView color:[UIColor clearColor] borderRadius:5.0f];
    
    [[SearchManager Instance]getCoordinateFromGPSThenWifi:^(CLLocation *currentLocation) {
        _region.center.longitude = currentLocation.coordinate.longitude;
        _region.center.latitude = currentLocation.coordinate.latitude;
        
        
        [self.annotation setCoordinate:self.region.center];
        
        [self.ibMapView setRegion:self.region animated:YES];
        
    } errorBlock:^(NSString *status) {
        
    }];

    [self requestServerForSeetiShopDetail];
    [self requestServerForSeetiShopPhotos];
}

-(void)requestServerForSeetiShopDetail
{
    NSDictionary* dict;
    NSString* appendString;
    if (![Utils stringIsNilOrEmpty:self.seetiesID]) {
        
        dict = @{@"token":[Utils getAppToken],
                               @"seetishop_id":self.seetiesID,
                               @"lat" : @"1.934400",
                               @"lng" : @"103.358727",
                               };
        appendString = self.seetiesID;

    }
    else{
       
        dict = @{@"token":[Utils getAppToken],
                               @"place_id":self.placeID,
                               @"post_id" : self.postID,
                               @"lat" : @"1.934400",
                               @"lng" : @"103.358727",
                               };
        appendString = self.placeID;

    }
    
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetiShopDetail param:dict appendString:appendString completeHandler:^(id object) {

        self.seShopModel = [[ConnectionManager dataManager] seShopDetailModel];
        self.arrayList = self.seShopModel.arrayInformation;
        [self.ibTableView reloadData];
        [self setupViewWithData];
        
        if (self.viewDidFinishLoadBlock) {
            self.viewDidFinishLoadBlock();
        }
    } errorBlock:^(id object) {
        
        
    }];
}

-(void)requestServerForSeetiShopPhotos
{
    NSDictionary* dict;
    NSString* appendString;

    if (![Utils stringIsNilOrEmpty:self.seetiesID]) {
    
        dict = @{@"token":[Utils getAppToken],
                 };
        
        appendString = [NSString stringWithFormat:@"%@/photos",self.seetiesID];


    }
    else
    {
        dict = @{@"token":[Utils getAppToken],
                 @"post_id":self.postID
                 };
        
        appendString = [NSString stringWithFormat:@"%@/photos",self.placeID];

    }

    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetiShopPhoto param:dict appendString:appendString completeHandler:^(id object) {
        self.seShopPhotoModel = [[ConnectionManager dataManager]seShopPhotoModel];
        
        [UIView transitionWithView:self duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setupViewWithData];
        } completion:nil];
        [self.ibCollectionView reloadData];
        
    } errorBlock:^(id object) {
        
        
    }];

}


@end
