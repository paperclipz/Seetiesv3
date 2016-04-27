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
    
    BOOL BTranslation;
}
@property (weak, nonatomic) IBOutlet UIButton *btnTranslate;
//============= title desc ====================//
@property (weak, nonatomic) IBOutlet UILabel *ilblAddress;
@property (weak, nonatomic) IBOutlet UILabel *ilblPubTransport;
@property (weak, nonatomic) IBOutlet UILabel *ilblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *ilblHour;
@property (weak, nonatomic) IBOutlet UILabel *ilblLink;

@property (weak, nonatomic) IBOutlet UILabel *ilblFacebook;
@property (weak, nonatomic) IBOutlet UILabel *ilblPrice;
@property (weak, nonatomic) IBOutlet UILabel *ilblBestKnownFor;
@property (weak, nonatomic) IBOutlet UILabel *ilblFeature;

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
@property(nonatomic,strong)SeShopDetailModel* seShopModel;

@property(nonatomic,strong)NSMutableArray* arrayHourList;
@property(nonatomic,strong)NSArray* arrayFeatureAvailableList;
@property(nonatomic,strong)NSArray* arrayFeatureUnavailableList;

@property(nonatomic,strong)NSString* seetiesID;
@property(nonatomic,strong)NSString* placeID;

@property(nonatomic,strong)NSString* strTranslationBestKnown;
@property(nonatomic,strong)NSString* strTranslationNearbyDesc;
@end

@implementation SeetiesMoreInfoViewController

- (IBAction)btnMapDirectionClicked:(id)sender {
  
    [[MapManager Instance]showMapOptions:self.view LocationLat:self.seShopModel.location.lat LocationLong:self.seShopModel.location.lng];
}
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
    BTranslation = NO;
    [self initTableViewDelegate];
    
    self.btnTranslate.hidden = [Utils isStringNull:self.seShopModel.seetishop_id];
    
    if ([self.seShopModel.language isEqualToString:[Utils getDeviceAppLanguageCode]]) {
        self.btnTranslate.hidden = YES;
    }
    
    [self changeLanguage];
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
        [self formatOpeningHours];
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
      
    
    self.lblNearbyDesc.text = [Utils isStringNull:self.seShopModel.nearby_public_transport]? @"-" : self.seShopModel.nearby_public_transport;
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

-(void)formatOpeningHours{
    if (self.seShopModel.location.opening_hours.period_text) {
        self.arrayHourList = [[NSMutableArray alloc] init];
        for (int i=0 ; i<7; i++) {
            NSString *day;
            switch (i) {
                case 0:
                    day = @"Sunday";
                    break;
                    
                case 1:
                    day = @"Monday";
                    break;
                    
                case 2:
                    day = @"Tuesday";
                    break;
                    
                case 3:
                    day = @"Wednesday";
                    break;
                    
                case 4:
                    day = @"Thursday";
                    break;
                    
                case 5:
                    day = @"Friday";
                    break;
                    
                case 6:
                    day = @"Saturday";
                    break;
                    
                default:
                    day = @"";
                    break;
            }
            
            NSString *time = [self.seShopModel.location.opening_hours.period_text objectForKey:day];
            if (time) {
                NSDictionary *period = @{@"day" : LocalisedString(day),
                                         @"time" : time};
                [self.arrayHourList addObject:period];
            }
        }
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
        
        NSDictionary* period = self.arrayHourList[indexPath.row];
        cell.lblDay.text = LocalisedString(period[@"day"]);
        cell.lblOpening.text = LocalisedString(period[@"time"]);
        
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
-(void)initData:(SeShopDetailModel*)shopModel
{
    self.seShopModel = shopModel;
    self.seetiesID = self.seShopModel.seetishop_id;
    self.placeID = self.seShopModel.location.place_id;
    

}

- (IBAction)btnTranslationClicked:(id)sender{

    if (BTranslation == NO) {
        if ([self.strTranslationBestKnown isEqual:[NSNull null]] || [self.strTranslationBestKnown length] == 0) {

            [self getTranslation];
        }else{
            self.lblBestKnown.text = self.strTranslationBestKnown;
            self.lblNearbyDesc.text = [Utils isStringNull:self.strTranslationNearbyDesc]? @"-" : self.strTranslationNearbyDesc;
        }
      //  [self getTranslation];
        BTranslation = YES;
    }else{
        self.lblBestKnown.text = self.seShopModel.recommended_information;
        self.lblNearbyDesc.text = [Utils isStringNull:self.seShopModel.nearby_public_transport]? @"-" : self.seShopModel.nearby_public_transport;;
        BTranslation = NO;
    }
    
}
-(void)getTranslation
{
    [self requestServerForTransalation];
}
-(void)requestServerForTransalation
{
    
    NSDictionary* dict = @{@"token":[Utils getAppToken],
                           @"seetishop_id":self.seetiesID,
                           };
    
    NSString* appendString;
    
    appendString = [NSString stringWithFormat:@"%@/translate",self.seetiesID];
    
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetoShopTranslation param:dict appendString:appendString completeHandler:^(id object) {
        
        [self triggerLanguageChanged:[[NSDictionary alloc]initWithDictionary:object[@"data"]]];
    } errorBlock:^(id object) {
        
        
    }];
    
}
-(void)triggerLanguageChanged:(NSDictionary*)dict
{
    NSArray* allKeys = [dict allKeys];
    NSLog(@"allKeys == %@",allKeys);
    self.lblBestKnown.text = dict[Recommended_Information];
    self.lblNearbyDesc.text = dict[Nearby_Public_Transport];
    
    self.strTranslationBestKnown = dict[Recommended_Information];
    self.strTranslationNearbyDesc = dict[Nearby_Public_Transport];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Change Language
-(void)changeLanguage
{
    
    self.ilblAddress.text = LocalisedString(@"Address");
    self.ilblPubTransport.text = LocalisedString(@"Nearby public transport station");
    self.ilblPhoneNumber.text = LocalisedString(@"Phone Number");
    self.ilblHour.text = LocalisedString(@"Hours");
    self.ilblLink.text = LocalisedString(@"URL/Link");
    self.ilblFacebook.text = LocalisedString(@"Facebook");
    self.ilblPrice.text = LocalisedString(@"Price");
    self.ilblBestKnownFor.text = LocalisedString(@"Best known for");
    self.ilblFeature.text = LocalisedString(@"Features");
    
}

@end
