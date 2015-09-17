//
//  AddNewPlaceViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "AddNewPlaceViewController.h"
#import "MapViewController.h"

@interface AddNewPlaceViewController ()


@property (strong, nonatomic)SearchLocationDetailModel* gooModel;// google
@property (strong, nonatomic)VenueModel* fsModel;// 4square
@property (strong, nonatomic)RecommendationVenueModel* rModel;


@property (weak, nonatomic) IBOutlet MKMapView *ibMapView;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (strong, nonatomic) MapViewController *mapViewController;

@property(strong,nonatomic)MKPointAnnotation* annotation;
@property(nonatomic,assign)MKCoordinateRegion region;

@property(nonatomic,strong)NSString* placeID;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@end

@implementation AddNewPlaceViewController

- (IBAction)btnDoneClicked:(id)sender {
        
    if(self.btnPressDoneBlock)
    {

        switch (self.searchType) {
            case SearchTypeGoogle:
            {
                
                
                [self.rModel processGoogleModel:(SearchLocationDetailModel*)self.gooModel];
            }
                break;
                
            case SearchTypeFourSquare:
                
                [self.rModel  processFourSquareModel:(VenueModel*)self.fsModel];

                break;
                
            default:
               
                break;
        }
        
        [self saveData];
        
        self.btnPressDoneBlock(self.rModel);
    }
}


- (IBAction)btnViewLargeMapClicke:(id)sender {
    
    if (self.navigationController) {
        [self.mapViewController initData:self.region];
        [self.navigationController pushViewController:self.mapViewController animated:YES];
    }
}

- (IBAction)btnBackClicked:(id)sender {
    
    if (_btnBackBlock) {
        self.btnBackBlock(self);
    }
    
    
  //  [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.lblTitle.text = self.title;
    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    //[self requestForGoogleMapDetails];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    
    [self.ibScrollView addSubview:self.addNewPlaceSubView];
    self.ibScrollView.contentSize = self.addNewPlaceSubView.frame.size;
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    [self.ibMapView addGestureRecognizer:lpgr];
    self.ibMapView.delegate = self;

    
}

-(AddNewPlaceSubView*)addNewPlaceSubView
{
    if(!_addNewPlaceSubView)
    {
    
        _addNewPlaceSubView = [AddNewPlaceSubView initializeCustomView];
        __weak typeof(self)weakSelf = self;
        _addNewPlaceSubView.btnEditHourClickedBlock = ^(id sender)
        {
            _editHoursViewController = nil;
            [weakSelf.editHoursViewController initData:weakSelf.rModel.arrOpeningHours];
            [weakSelf presentViewController:weakSelf.editHoursViewController animated:YES completion:^{
            }];
        };
    }
    
    return _addNewPlaceSubView;
}

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

//The event handling method
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)return;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.ibMapView];
    CLLocationCoordinate2D touchCoordinate =
    [self.ibMapView convertPoint:touchPoint toCoordinateFromView:self.ibMapView];
    NSLog(@"%f, %f", touchCoordinate.latitude, touchCoordinate.longitude);
    _region.center.latitude = touchCoordinate.latitude;
    _region.center.longitude = touchCoordinate.longitude;
    [self.annotation setCoordinate:self.region.center];

}

-(void)initDataFromGogle:(NSString*)placeid
{
    self.searchType = SearchTypeGoogle;
    self.placeID = placeid;
    [self requestForGoogleMapDetails];


}

-(void)initData:(RecommendationVenueModel*)model
{
    self.searchType = SearchTypeDefault;
    self.rModel = model;
   // [self reloadData];

}

-(void)initDataFrom4Square:(VenueModel*)model
{
    self.searchType = SearchTypeFourSquare;
    self.fsModel = model;
   // [self reloadData];

}


-(void)reloadData
{
    switch (self.searchType) {
        default:
            self.addNewPlaceSubView.txtPlaceName.text = self.rModel.name;
            self.addNewPlaceSubView.txtAddress.text = self.rModel.formattedAddress;
            self.addNewPlaceSubView.txtURL.text = self.rModel.url;
            self.addNewPlaceSubView.txtPhoneNo.text = self.rModel.formattedPhone;
            [self.addNewPlaceSubView.btnCurrency setTitle:self.rModel.currency forState:UIControlStateNormal];
            self.addNewPlaceSubView.txtPerPax.text = self.rModel.price;
            [self refreshMapViewWithLatitude:[self.rModel.lat doubleValue] longtitude:[self.rModel.lng doubleValue]];

            break;
        case SearchTypeGoogle:
            self.addNewPlaceSubView.txtPlaceName.text = self.gooModel.name;
            self.addNewPlaceSubView.txtAddress.text = self.gooModel.formatted_address;
            self.addNewPlaceSubView.txtURL.text = self.gooModel.website;
            self.addNewPlaceSubView.txtPhoneNo.text = self.gooModel.formatted_phone_number;
            [self.addNewPlaceSubView.btnCurrency setTitle:[Utils currencyString:@""] forState:UIControlStateNormal];

            [self refreshMapViewWithLatitude:[self.gooModel.lat doubleValue] longtitude:[self.gooModel.lng doubleValue]];

            break;
        case SearchTypeFourSquare:
       
            self.addNewPlaceSubView.txtPlaceName.text = self.fsModel.name;
            self.addNewPlaceSubView.txtAddress.text = self.fsModel.address;
            self.addNewPlaceSubView.txtURL.text = self.fsModel.url;
            self.addNewPlaceSubView.txtPhoneNo.text = self.fsModel.phone;
            [self.addNewPlaceSubView.btnCurrency setTitle:[Utils currencyString:@""] forState:UIControlStateNormal];

            [self refreshMapViewWithLatitude:[self.fsModel.lat doubleValue] longtitude:[self.fsModel.lng doubleValue]];

        break;
    
    }
  
}

#pragma mark - Request Sever
-(void)requestForGoogleMapDetails
{
    
    NSDictionary* dict = @{@"placeid":self.placeID,@"key":GOOGLE_API_KEY};
    
    [[ConnectionManager Instance] requestServerWithPost:NO customURL:GOOGLE_PLACE_DETAILS_API requestType:ServerRequestTypeGoogleSearchWithDetail param:dict completeHandler:^(id object) {
        
        self.gooModel = [[DataManager Instance] googleSearchDetailModel];
        //[self reloadData];
        [self viewWillAppear:YES];
        
    } errorBlock:nil];

}

-(void)refreshMapViewWithLatitude:(double)lat longtitude:(double)lont
{
    
    _region.center.longitude = lont;
    _region.center.latitude = lat;
    
    if (lat && lont) {
        [self.annotation setCoordinate:self.region.center];
    }

    SLog(@"refreshMapView");
   
    //CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake([self.model.latitude doubleValue], [self.model.longitude doubleValue]);
   // MKCoordinateRegion adjustedRegion = [self.ibMapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200)];
    [self.ibMapView setRegion:self.region animated:YES];
}

#pragma mark - Map
-(MapViewController*)mapViewController
{
    if(!_mapViewController)
    {
        __block typeof (self)weakSelf = self;
        _mapViewController = [MapViewController new];
        _mapViewController.viewDidDismissBlock = ^(MKCoordinateRegion region)
        {
            weakSelf.rModel.lat = [@(region.center.latitude) stringValue];
            weakSelf.rModel.lng = [@(region.center.longitude) stringValue];
        };
    }
    
    return _mapViewController;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pav == nil)
    {
        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pav.draggable = YES;
        pav.canShowCallout = YES;
    }
    else
    {
        pav.annotation = annotation;
    }
    
    return pav;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        _region.center = droppedAt;
        NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
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

#pragma  mark - Declaration
-(RecommendationVenueModel*)rModel
{
    if (!_rModel) {
        _rModel = [RecommendationVenueModel new];
    }
    return _rModel;
}

-(EditHoursViewController*)editHoursViewController
{
    if(!_editHoursViewController)
    {
        __weak typeof (self)weakSelf = self;
        _editHoursViewController = [EditHoursViewController new];
        _editHoursViewController.backBlock = ^(NSArray* arrayOpeningHours)
        {
            weakSelf.rModel.arrOpeningHours = arrayOpeningHours;
        
        };
    }
    return _editHoursViewController;
}

#pragma mark - Save Data
-(void)saveData
{
    self.rModel.address =  self.addNewPlaceSubView.txtAddress.text;
    self.rModel.formattedPhone =  self.addNewPlaceSubView.txtPhoneNo.text;
    self.rModel.name =  self.addNewPlaceSubView.txtPlaceName.text;
    self.rModel.url =  self.addNewPlaceSubView.txtURL.text;
    self.rModel.price =  self.addNewPlaceSubView.txtPerPax.text;
    self.rModel.currency = self.addNewPlaceSubView.btnCurrency.titleLabel.text;    
}

@end
