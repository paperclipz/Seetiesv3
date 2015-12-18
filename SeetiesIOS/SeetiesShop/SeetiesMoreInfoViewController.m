//
//  SeetiesMoreInfoViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeetiesMoreInfoViewController.h"
#import "SeShopMoreInfoTableViewCell.h"
#import "SeShopFeatureTableViewCell.h"

@interface SeetiesMoreInfoViewController ()<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *constlblAddressDesc_Height;
}

// ============ IBOUTLET======================//
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblShopTitle;

// ---------------- ADDRESS----------------------//
@property (weak, nonatomic) IBOutlet UIView *ibAddressView;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblNearbyDesc;

// ---------------- ADDRESS----------------------//

// ---------------- Contact----------------------//

@property (weak, nonatomic) IBOutlet UIView *ibPhoneNumberView;
@property (weak, nonatomic) IBOutlet UILabel *lblContactDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblURLLinkDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblFacebookLinkDesc;

// ---------------- Contact----------------------//
// ---------------- Price----------------------//
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblAcceptCreditCard;

// ---------------- Price----------------------//
@property (strong, nonatomic) IBOutlet UITableView *ibFeatureTableView;

// ---------------- Features----------------------//

@property (strong, nonatomic) IBOutlet UIView *ibYESHeader;
@property (strong, nonatomic) IBOutlet UIView *ibNoHeader;

// ---------------- Features----------------------//
@property (strong, nonatomic) IBOutlet UIView *ibBestKnownView;

@property (weak, nonatomic) IBOutlet UILabel *lblBestKnown;

@property (strong, nonatomic) IBOutlet UITableView *ibHourTableView;

@property (weak, nonatomic) IBOutlet UIView *ibURLView;
@property (weak, nonatomic) IBOutlet UIView *ibFacebookLinkView;
@property (weak, nonatomic) IBOutlet UIView *ibPriceView;

@property (strong, nonatomic) IBOutlet UIView *ibMapMainView;
@property (strong, nonatomic) IBOutlet MKMapView *ibMapView;
@property(nonatomic,assign)MKCoordinateRegion region;
@property(strong,nonatomic)MKPointAnnotation* annotation;
@property (strong, nonatomic) NSMutableArray *arrViews;


// ----------------     MODEL   ----------------------//

@property(nonatomic,strong)NSArray* arrayHourList;
@property(nonatomic,strong)NSArray* arrayFeatureAvailableList;
@property(nonatomic,strong)NSArray* arrayFeatureUnavailableList;

@end

@implementation SeetiesMoreInfoViewController
- (IBAction)btnMapClicked:(id)sender {
    

    _region.center.latitude = [self.seShopModel.location.lat doubleValue];
    _region.center.longitude = [self.seShopModel.location.lng doubleValue];
    [self.mapViewController initData:self.region EnableRePin:NO];
    [self.navigationController pushViewController:self.mapViewController animated:YES onCompletion:^{
        self.mapViewController.lblTitle.text = LocalisedString(@"MAP");

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSelfView];
    [self setupView];
    [self addViews];
    [self redrawView];
    
    
}

-(void)redrawView
{
    [self adjustView:self.arrViews[self.arrViews.count-1] :(int)(self.arrViews.count - 1)];
    UIView* lastView = [self.arrViews lastObject];
    self.ibScrollView.contentSize = CGSizeMake( self.ibScrollView.frame.size.width, lastView.frame.size.height+ lastView.frame.origin.y);
}

-(void)initSelfView
{
    self.ibMapView.delegate = self;

    [self initTableViewDelegate];
}
-(void)initTableViewDelegate
{
    self.ibHourTableView.delegate = self;
    self.ibHourTableView.dataSource = self;
    [self.ibHourTableView registerClass:[SeShopMoreInfoTableViewCell class] forCellReuseIdentifier:@"SeShopMoreInfoTableViewCell"];
    
    self.ibFeatureTableView.delegate = self;
    self.ibFeatureTableView.dataSource = self;
    [self.ibFeatureTableView registerClass:[SeShopFeatureTableViewCell class] forCellReuseIdentifier:@"SeShopFeatureTableViewCell"];
}
-(void)setupView
{
    
    self.arrViews = [NSMutableArray new];
    
    [self.arrViews addObject:self.ibMapMainView];
    [self.ibMapView reloadInputViews];
    
    self.arrayFeatureAvailableList = self.seShopModel.arrFeatureAvaiable;
    self.arrayFeatureUnavailableList = self.seShopModel.arrFeatureUnavaiable;
    self.lblShopTitle.text = self.seShopModel.name;
    
    if (![Utils stringIsNilOrEmpty:self.seShopModel.location.formatted_address]) {
        [self.arrViews addObject:self.ibAddressView];
        self.lblAddressDesc.text =self.seShopModel.location.formatted_address;

    }

    
    if (self.seShopModel.contact_number.count>0) {
        [self.arrViews addObject:self.ibPhoneNumberView];
        self.lblContactDesc.text = self.seShopModel.contact_number[0];

    }
    
    if ([self.seShopModel.location.opening_hours.period_text allKeys].count >0) {
        [self.arrViews addObject:self.ibHourTableView];
        self.arrayHourList = [self.seShopModel.location.opening_hours.period_text allKeys];
        [self.ibHourTableView setHeight:((int)self.arrayHourList.count*[SeShopMoreInfoTableViewCell getHeight]) + 44 + 5];
        [self.ibHourTableView reloadData];
    }
    
    if (![Utils stringIsNilOrEmpty:self.seShopModel.urlWebsite]) {
        self.lblURLLinkDesc.text = self.seShopModel.urlWebsite;
        [self.arrViews addObject:self.ibURLView];

    }
    
    if (![Utils stringIsNilOrEmpty:self.seShopModel.urlFacebook]) {
        self.lblFacebookLinkDesc.text = self.seShopModel.urlFacebook;
        [self.arrViews addObject:self.ibFacebookLinkView];
        
    }
    
    if (![Utils stringIsNilOrEmpty:self.seShopModel.price.value]) {
        self.lblPrice.text = [NSString stringWithFormat:@"%@ %@",self.seShopModel.price.code,self.seShopModel.price.value];
        self.lblAcceptCreditCard.text = self.seShopModel.price.payment;
        [self.arrViews addObject:self.ibPriceView];
        
    }
    
    if (![self isArrayNull:self.arrayFeatureAvailableList] && ![self isArrayNull:self.arrayFeatureUnavailableList]) {
        float featureHeight = 0;
        
        if (![self isArrayNull:self.arrayFeatureAvailableList]) {
            
            
            featureHeight += (44+ ((int)(self.arrayFeatureAvailableList.count)*[SeShopFeatureTableViewCell getHeight]));
        }
        if (![self isArrayNull:self.arrayFeatureUnavailableList]) {
            featureHeight += (44+ ((int)(self.arrayFeatureUnavailableList.count)*[SeShopFeatureTableViewCell getHeight]));
            
        }
        [self.ibFeatureTableView setHeight:featureHeight + 30];//this 44 is for tableview header
        
        [self.arrViews addObject:self.ibBestKnownView];

        [self.ibFeatureTableView reloadData];

    }
    if (![Utils stringIsNilOrEmpty:self.seShopModel.recommended_information]) {
        self.lblBestKnown.text = self.seShopModel.recommended_information;
        [self.arrViews addObject:self.ibFeatureTableView];

    }

    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.seShopModel.location.lat doubleValue], [self.seShopModel.location.lng doubleValue]);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
    _region = region;
    [self.annotation setCoordinate:self.region.center];
    [self.ibMapView setRegion:self.region animated:YES];
      
    
    self.lblNearbyDesc.text = self.seShopModel.nearby_public_transport;
    [self updateConstraintForLabel:self.lblAddressDesc labelHeightConst:constlblAddressDesc_Height superView:self.ibAddressView lasSubView:self.lblNearbyDesc];
}


-(void)removeViewFromArray:(UIView*)view
{
    if (![self.arrViews containsObject:view]) {
        [self.arrViews removeObject:view];
    }
    
}

-(BOOL)isArrayNull:(NSArray*)array
{
    if (array && array.count>0) {
        return NO;
    }
    return YES;
}
-(void)updateConstraintForLabel:(UILabel*)label labelHeightConst:(NSLayoutConstraint*)labelHeightConst superView:(UIView*)sView lasSubView:(UIView*)lastView
{
    float height =  [label.text heightForWidth:label.frame.size.width usingFont:label.font];
    labelHeightConst.constant = height;
    
    [lastView layoutIfNeeded];
    
    float viewheight = (lastView.frame.size.height + lastView.frame.origin.y) + VIEW_PADDING;
    [sView setHeight:viewheight];
    
}

-(void)addViews
{
    for (int i = 0; i< self.arrViews.count; i++) {
        UIView* view = self.arrViews[i];
        [view adjustToScreenWidth];
        [view layoutIfNeeded];
        [self.ibScrollView addSubview:view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// readjust view from top to bottom
-(UIView*)adjustView:(UIView*)view :(int)count
{
    
    if (count <=0) {
        
        return view;
        
    }
    else{
        count--;
        
        UIView *previousView = [self adjustView:self.arrViews[count] :count];
        float height = previousView.frame.origin.y + previousView.frame.size.height;
        [view setY:height];
        
        return view;
    }
    
}

#pragma mark - Declaration

-(MapViewController*)mapViewController
{
    if (!_mapViewController) {
        _mapViewController = [MapViewController new];

    }
    return _mapViewController;
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

#pragma mark - UITableView Delegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.ibFeatureTableView) {
        
        if (section == 0) {
            return self.ibYESHeader;
        }
        else{
            return self.ibNoHeader;

        }
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.ibHourTableView) {
        return self.arrayHourList.count;

    }
    else if (tableView  == self.ibFeatureTableView){
        
        if (section == 0) {
            return self.arrayFeatureAvailableList.count;
        }
        else{
            return self.arrayFeatureUnavailableList.count;

        }
    }
    else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    int i = 0;
    if (self.ibFeatureTableView == tableView) {
        
        if (self.arrayFeatureAvailableList && self.arrayFeatureUnavailableList.count>0) {
            i+=1;
        }
        if (self.arrayFeatureUnavailableList && self.arrayFeatureUnavailableList.count>0) {
            i+=1;

        }
        
        return i;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.ibHourTableView) {
        SeShopMoreInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeShopMoreInfoTableViewCell"];
        
        NSString* day = self.arrayHourList[indexPath.row];
        cell.lblDay.text = day;
        cell.lblOpening.text = [self.seShopModel.location.opening_hours.period_text objectForKey:day];
        
        return cell;

    }
    else{
        SeShopFeatureTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeShopFeatureTableViewCell"];
        
        
        if (indexPath.section == 0) {
            NSString* feature = self.arrayFeatureAvailableList[indexPath.row];
            cell.lblTitle.text = feature;

        }
        else{
            NSString* feature = self.arrayFeatureUnavailableList[indexPath.row];
            cell.lblTitle.text = feature;
        }
        
        return cell;
    }
   

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
