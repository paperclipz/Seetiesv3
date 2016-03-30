
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
#import "NSDictionary+Extra.h"
#import "SeDealsFeaturedTblCell.h"
#import "DealHeaderView.h"

#define MapMainViewHeight 203;

@interface SeShopDetailView()<UITableViewDataSource,UITableViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate,MKMapViewDelegate>
{

    __weak IBOutlet NSLayoutConstraint *constDealTableTop;
    __weak IBOutlet NSLayoutConstraint *constDealHeight;
    __weak IBOutlet NSLayoutConstraint *constantMapMainView;
    __weak IBOutlet NSLayoutConstraint *photoHeightConstraint;
    __weak IBOutlet UILabel *lblPhotoCount;
    __weak IBOutlet NSLayoutConstraint *tableviewConstraint;
    BOOL isTranslated;
    BOOL inTranslatedLanguage;
    
    NSString* nearbyPubTransport_Translated;
    NSString* bestKnownFor_Translated;
    NSString* bestKnownFor_NotTranslated;


}

//==================  title label =================//
@property (weak, nonatomic) IBOutlet UILabel *lblInformation;
@property (weak, nonatomic) IBOutlet UIButton *btnMoreInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblNearbyPubTransport;
@property (weak, nonatomic) IBOutlet UIButton *btnSeeAll;
@property (weak, nonatomic) IBOutlet UILabel *lblImageCount;

//================== Detail =======================//
@property (weak, nonatomic) IBOutlet UILabel *lblShopCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageVerified;
@property (weak, nonatomic) IBOutlet UILabel *lblOpenNow;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfile;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfileBackground;

//================== Detail =======================//

@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImageView;
@property(nonatomic,strong)NSArray* arrayList;
@property(nonatomic,assign)int counter;
@property(nonatomic,strong)NSMutableArray* arrayCell;
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *ibBtnInformationDetails;
@property (weak, nonatomic) IBOutlet UIView *ibPhotoView;
//@property (weak, nonatomic) IBOutlet UILabel *lblNearbyTransport;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

//================== MAP =======================//

@property (weak, nonatomic) IBOutlet UILabel *lblNearbyPublicTransport;
@property (weak, nonatomic) IBOutlet UITableView *ibDealTableView;

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
@property(nonatomic,assign)float shoplat;
@property(nonatomic,assign)float shopLgn;

@property(nonatomic,copy)NSArray* arrListTranslated;
@property(nonatomic,copy)NSArray* arrListNonTranslated;

@property(nonatomic,copy)DealsModel* dealsModel;

@end

@implementation SeShopDetailView
- (IBAction)btnImageClicked:(id)sender {
    
    if (self.didSelectMorePhotosBlock) {
        self.didSelectMorePhotosBlock(self.seShopPhotoModel);
    }
}
- (IBAction)btnDealSeeAllClicked:(id)sender {
    
    if (self.didSelectDealSeeAllBlock) {
        self.didSelectDealSeeAllBlock();
    }
}

- (IBAction)btnMapDirectionClicked:(id)sender {
    
    [[MapManager Instance]showMapOptions:self LocationLat:self.seShopModel.location.lat LocationLong:self.seShopModel.location.lng];
    
}

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
    isTranslated = NO;
    inTranslatedLanguage = NO;
    [Utils setRoundBorder:self.ibImgProfile color:UIColorFromRGB(255, 255, 255, 1) borderRadius:self.ibImgProfile.frame.size.width/2 borderWidth:0.0f];
    self.ibMapInfoView.alpha = 0;

    constantMapMainView.constant = 0;
    tableviewConstraint.constant = 0;
    photoHeightConstraint.constant = 0;
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
    [self.btnSeeAll setSquareBorder];
    [self.btnMoreInfo setSquareBorder];

    [self changeLanguage];
    
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[SeShopDetailTableViewCell class] forCellReuseIdentifier:@"SeShopDetailTableViewCell"];
    
    self.ibDealTableView.delegate = self;
    self.ibDealTableView.dataSource = self;
    [self.ibDealTableView registerClass:[SeDealsFeaturedTblCell class] forCellReuseIdentifier:@"SeDealsFeaturedTblCell"];
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
    self.ibImgProfileBackground.image = [UIImage imageNamed:@"SSDefaultCoverPhoto.png"];

    [UIView animateWithDuration:1.0 animations:^{
        self.ibMapInfoView.alpha = 1;
    }];

    if (self.seShopModel.wallpapers.count >0) {
        NSDictionary* wallpaperDict = self.seShopModel.wallpapers[0];
        
        [self.ibImgProfileBackground sd_setImageCroppedWithURL:[NSURL URLWithString:[wallpaperDict objectForKey:@"m"]] completed:^(UIImage *image){
            
            if (!image) {
                self.ibImgProfileBackground.image = [UIImage imageNamed:@"SSDefaultCoverPhoto.png"];
            }
            if (self.imageDidFinishLoadBlock) {
                self.imageDidFinishLoadBlock(image);
            }
        }];
    }
    
    if (self.seShopModel.profile_photo) {
        
        [self.ibImgProfile sd_setImageCroppedWithURL:[NSURL URLWithString:self.seShopModel.profile_photo[@"picture"]] completed:^(UIImage *image){
           
            if (!image) {
                self.ibImgProfile.image = [UIImage imageNamed:@"SsDefaultDisplayPhoto.png"];
            }
        }];
    }
    
    // 10 for bottom padding 54 each for top and bottom bar
    float constantHeight =  (self.arrayList.count*[SeShopDetailTableViewCell getHeight]) + 52;
    tableviewConstraint.constant = constantHeight;
    
    if (self.arrayList.count == 0) {
        tableviewConstraint.constant = 0;
    }
    
    if (self.seShopPhotoModel.photos.count == 0) {
        photoHeightConstraint.constant = 0;
    }
    else{
        photoHeightConstraint.constant = 230;

    }

    if (self.dealsModel.total_count == 0) {
        constDealHeight.constant = 0;
        constDealTableTop.constant = 0;

    }
    else{
        constDealTableTop.constant = 10;

        if (self.dealsModel.total_count > 3) {
            constDealHeight.constant = 52.0f + 52.0f + [SeDealsFeaturedTblCell getHeight]* self.dealsModel.arrDeals.count;

        }
        else{
            constDealHeight.constant = 52.0f + [SeDealsFeaturedTblCell getHeight]* self.dealsModel.arrDeals.count;

        }

    }
    constantMapMainView.constant = MapMainViewHeight;
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    [self setHeight:self.ibMapMainView.frame.size.height + self.ibMapMainView.frame.origin.y + VIEW_PADDING];
    
    self.lblShopName.text = self.seShopModel.name;
    self.lblShopCategory.text = self.seShopModel.category.title;
    
    self.lblAddress.text = self.seShopModel.location.formatted_address;
    self.lblNearbyPublicTransport.text = self.seShopModel.nearby_public_transport;
    
    self.lblDistance.text = [Utils getDistance:self.seShopModel.location.distance Locality:self.seShopModel.location.locality];
       
    lblPhotoCount.text = [NSString stringWithFormat:@"%@ (%d)",LocalisedString(@"Photos"),self.seShopPhotoModel.total_photos];

    self.lblImageCount.text = [NSString stringWithFormat:@"%d",self.seShopPhotoModel.total_photos];

    
    self.ibImageVerified.hidden = !self.seShopModel.is_collaborate;
    
    if (self.seShopModel.location.opening_hours.open_now) {
        self.lblOpenNow.textColor = UIColorFromRGB(156, 204, 101, 1);
        self.lblOpenNow.text = LocalisedString(@"Open Now");
    }
    else{
        self.lblOpenNow.textColor = UIColorFromRGB(248, 76, 76, 1);
        self.lblOpenNow.text = LocalisedString(@"Closed");

    }
    
    self.lblDistanceIndicator.text = self.seShopModel.location.display_address;

    
//    if (self.seShopModel.location.distance<1000) {
//        self.lblDistanceIndicator.text = LocalisedString(@"Walk");
//
//    }
//    else if(self.seShopModel.location.distance<30000)
//    {
//        self.lblDistanceIndicator.text = LocalisedString(@"Drive");
//
//    }
//    else{
//        self.lblDistanceIndicator.text = LocalisedString(@"Swim or Fly");
//
//    }
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.seShopModel.location.lat doubleValue], [self.seShopModel.location.lng doubleValue]);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
    
    _region = region;
    
    [self.annotation setCoordinate:self.region.center];
    
    [self.ibMapView setRegion:self.region animated:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (self.ibDealTableView == tableView) {
        return 1;

    }
    else{
        return 1;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (self.ibDealTableView == tableView) {
        
        return 52.0f;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.ibDealTableView == tableView) {
        
        if (self.dealsModel.total_count>3) {
            return 52.0f;

        }
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    DealHeaderView* dealview = [DealHeaderView initializeCustomView];
    [dealview setSquareBorder];
    dealview.btnDeals.hidden = YES;
    dealview.seeMoreBlock = self.didSelectDealSeeAllBlock;
    
    
    return dealview;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.ibDealTableView == tableView) {

        DealHeaderView* view = [DealHeaderView initializeCustomView];
      
        view.seeMoreBlock = self.didSelectDealSeeAllBlock;
       
        [view.btnDeals.titleLabel setFont:[UIFont fontWithName:CustomFontName size:17]];
        
        view.btnSeeMore.hidden = YES;

        [view.btnDeals setTitle:[NSString stringWithFormat:@"%@ (%lu)",LocalisedString(@"Deals"),(unsigned long)self.dealsModel.total_count] forState:UIControlStateNormal];

        [Utils setRoundBorder:view color:OUTLINE_COLOR borderRadius:0];

        [view setSquareBorder];

        return view;
    }
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.ibTableView == tableView) {
      return self.arrayList.count;
    }
    else
    {
        return self.dealsModel.arrDeals.count;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.ibTableView == tableView) {
        SeShopDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeShopDetailTableViewCell"];
        
        NSDictionary* dict = self.arrayList[indexPath.row];
        
        NSArray* keys = [dict allKeys];
        
        NSString* key = keys[0];
        
        cell.lblTitle.text = LocalisedString(key);
        [cell setImage:key];
        cell.lblDesc.text = [dict objectForKey:key];
        
        return cell;

    }

    else if(self.ibDealTableView == tableView)
    {
        SeDealsFeaturedTblCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeDealsFeaturedTblCell"];
        
        DealModel* model = self.dealsModel.arrDeals[indexPath.row];
        
        [cell initData:model];
        
        return cell;

    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Assuming view is at zero index of XIB file.
    // this view will contain all lable and other controls
    
    if (self.ibDealTableView == tableView) {
        
        DealModel* model = self.dealsModel.arrDeals[indexPath.row];
        
        if (self.didSelectDealBlock) {
            self.didSelectDealBlock(model);
        }
    }
    else
    {
        CGRect myRect = [tableView rectForRowAtIndexPath:indexPath];
        
        if (self.didSelectInformationAtRectBlock) {
            self.didSelectInformationAtRectBlock(tableView,myRect);
        }
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

#pragma mark - Change Language
-(void)changeLanguage
{
    self.lblInformation.text = LocalisedString(@"Information");
    [self.btnMoreInfo setTitle:LocalisedString(@"See more") forState:UIControlStateNormal];
  //  self.lblNearbyPubTransport.text = LocalisedString(@"Nearby public transport station");
    [self.btnSeeAll setTitle:LocalisedString(@"See all") forState:UIControlStateNormal];
}

#pragma mark - Server
//-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID  Latitude:(float)lat Longitude:(float)lng
//{
//    self.shoplat = lat;
//    self.shopLgn = lng;
//    self.seetiesID = seetiesID;
//    self.placeID = placeID;
//    self.postID = postID;
//    
//    [self.ibProfileImageView sd_setImageCroppedWithURL:[NSURL URLWithString:@"http://www.bangsarbabe.com/wp-content/uploads/2014/05/81.jpg"] completed:^(UIImage *image){
//        
//        if (self.imageDidFinishLoadBlock) {
//            self.imageDidFinishLoadBlock(image);
//        }
//    }];
//    
//    [Utils setRoundBorder:self.ibMapInfoView color:[UIColor clearColor] borderRadius:5.0f];
//    
//    [[SearchManager Instance]getCoordinateFromGPSThenWifi:^(CLLocation *currentLocation) {
//        _region.center.longitude = currentLocation.coordinate.longitude;
//        _region.center.latitude = currentLocation.coordinate.latitude;
//        
//        
//        [self.annotation setCoordinate:self.region.center];
//        
//        [self.ibMapView setRegion:self.region animated:YES];
//        
//    } errorBlock:^(NSString *status) {
//        
//    }];
//    
//    [self requestServerForSeetiShopDetail];
//    [self requestServerForSeetiShopPhotos];
//}
-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID
{
    
    self.seetiesID = seetiesID;
    self.placeID = placeID;
    self.postID = postID;
    self.shoplat = [[SearchManager Instance]getAppLocation].coordinate.latitude;
    self.shopLgn = [[SearchManager Instance]getAppLocation].coordinate.longitude;
    
    [Utils setRoundBorder:self.ibMapInfoView color:OUTLINE_COLOR borderRadius:5.0f];
    
    
    CLLocation* location = [[SearchManager Instance]getAppLocation];
   
    _region.center.longitude = location.coordinate.longitude;
    _region.center.latitude = location.coordinate.latitude;
    
    
    [self.annotation setCoordinate:self.region.center];
    
    [self.ibMapView setRegion:self.region animated:YES];


    [self requestServerForSeetiShopDetail];

    [self requestServerForShopDeal];
    
    [self requestServerForSeetiShopPhotos];
    
}

-(void)requestServerForSeetiShopDetail
{
    NSDictionary* dict;
    NSString* appendString;
    
    @try {
        if (![Utils stringIsNilOrEmpty:self.seetiesID]) {
            
            dict = @{@"token":[Utils getAppToken],
                     @"seetishop_id":self.seetiesID,
                     @"lat" : @(self.shoplat),
                     @"lng" : @(self.shopLgn),
                     };
            appendString = self.seetiesID;
            
        }
        else{
            
            dict = @{@"token":[Utils getAppToken],
                     @"place_id":self.placeID,
                     @"post_id" : self.postID,
                     @"lat" : @(self.shoplat),
                     @"lng" : @(self.shopLgn),
                     };
            
            appendString = self.placeID;
            
        }

    }
    @catch (NSException *exception) {
        
    }
  
    
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetiShopDetail param:dict appendString:appendString completeHandler:^(id object) {

        self.seShopModel = [[ConnectionManager dataManager] seShopDetailModel];
        self.arrayList = self.seShopModel.arrayInformation;
       
        
        [self setupViewWithData];
        [self.ibTableView reloadData];
        
        if (self.viewDidFinishLoadBlock) {
            self.viewDidFinishLoadBlock(self.seShopModel);
        }
       //[self requestServerForShopDeal];
    } errorBlock:^(id object) {
        
        
    }];
}

-(void)requestServerForShopDeal
{
    NSDictionary* dict;
    @try {
       
        dict = @{@"seetishop_id" : self.seetiesID,
                               @"token" : [Utils getAppToken],
                               @"offset" : @"0",
                               @"limit" : @"3"
                               };
        
    }
    
    @catch (NSException *exception) {
        
    }
   
    NSString* appendString = [NSString stringWithFormat:@"%@/deals",self.seetiesID];
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetSeetiShopDeal param:dict appendString:appendString completeHandler:^(id object) {
        
        DealsModel* model = [[ConnectionManager dataManager]dealsModel];

        self.dealsModel = model;
        [self.ibDealTableView reloadData];
        [self setupViewWithData];


        
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
        
//        [UIView transitionWithView:self duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//
//
//        } completion:nil];
        
        [self setupViewWithData];

        
//        if (self.viewDidFinishLoadBlock) {
//            self.viewDidFinishLoadBlock(self.seShopModel);
//        }
//
        
        [self.ibCollectionView reloadData];
        
    } errorBlock:^(id object) {
        
        
    }];

}

-(void)requestServerForTransalation
{
    
    NSDictionary* dict = @{@"token":[Utils getAppToken],
             @"seetishop_id":[Utils isStringNull:self.seetiesID]?@"":self.seetiesID,
             };
    
    NSString* appendString;

    appendString = [NSString stringWithFormat:@"%@/translate",self.seetiesID];
    SLog(@"%@",appendString);

    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetoShopTranslation param:dict appendString:appendString completeHandler:^(id object) {
    
        NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object[@"data"]];
        NSArray* allKeys = [returnDict allKeys];
        if ([allKeys containsObject:Nearby_Public_Transport]) {
            nearbyPubTransport_Translated = returnDict[Nearby_Public_Transport];

        }
        
        for (int i = 0; i<self.arrayList.count; i++) {
            
            NSDictionary* tempDict = self.arrayList[i];
            if ([tempDict containsKey:BestKnowFor]) {
                bestKnownFor_NotTranslated = tempDict[BestKnowFor];
                if ([allKeys containsObject:Recommended_Information]) {
                    bestKnownFor_Translated = returnDict[Recommended_Information];
                }
            }
            
        }
        
        isTranslated = YES;
        [self switchBwtweenLanguageTranslated];

    } errorBlock:^(id object) {
        
        
    }];

}

-(void)editDictInArrayForKey:(NSString*)key withValue:(NSString*)value array:(NSArray*)array
{
    for (int i = 0; i<array.count; i++) {
        
        NSDictionary* tempDict = array[i];
        if ([tempDict containsKey:BestKnowFor]) {
            
            [tempDict setValue:value forKey:key];
        }
        
    }

}
-(void)switchBwtweenLanguageTranslated
{
    
    inTranslatedLanguage = !inTranslatedLanguage;
    
    if (inTranslatedLanguage) {
        self.lblNearbyPublicTransport.text = nearbyPubTransport_Translated;
        
        [self editDictInArrayForKey:BestKnowFor withValue:bestKnownFor_Translated array:self.arrayList];
    }
    else
    {
        self.lblNearbyPublicTransport.text = self.seShopModel.nearby_public_transport;
        [self editDictInArrayForKey:BestKnowFor withValue:bestKnownFor_NotTranslated array:self.arrayList];

    }
    
 
    [self.ibTableView reloadData];
    
    
}

-(void)getTranslation
{
    
    if (isTranslated) {
        [self switchBwtweenLanguageTranslated];
    }
    else{
        [self requestServerForTransalation];

    }
}


@end
