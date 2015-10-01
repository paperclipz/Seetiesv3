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
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@end

@implementation AddNewPlaceViewController

- (IBAction)btnDoneClicked:(id)sender {
        
    if(self.btnPressDoneBlock)
    {
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
    self.lblTitle.text = @"";
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
    lpgr.minimumPressDuration = 0.3f;
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
            [weakSelf.editHoursViewController initData:weakSelf.rModel.arrOperatingHours];
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

-(void)initData:(RecommendationVenueModel*)model
{
    self.rModel = model;
   [self loadData];
    [self reloadData];


}

-(void)loadData
{
    self.addNewPlaceSubView.txtPlaceName.text = self.rModel.name;
    self.addNewPlaceSubView.txtAddress.text = self.rModel.formattedAddress;
    self.addNewPlaceSubView.txtURL.text = self.rModel.url;
    self.addNewPlaceSubView.txtPhoneNo.text = self.rModel.formattedPhone;
    [self.addNewPlaceSubView.btnCurrency setTitle:self.rModel.currency?self.rModel.currency:USD forState:UIControlStateNormal];
    self.addNewPlaceSubView.txtPerPax.text = self.rModel.price;
}

-(void)reloadData
{
   
    [self refreshMapViewWithLatitude:[self.rModel.lat doubleValue] longtitude:[self.rModel.lng doubleValue]];

}


-(void)refreshMapViewWithLatitude:(double)lat longtitude:(double)lont
{
    if ( lat == 0) {
        
        [[SearchManager Instance]getCoordinateFromGPSThenWifi:^(CLLocation *currentLocation) {
            _region.center.longitude = currentLocation.coordinate.longitude;
            _region.center.latitude = currentLocation.coordinate.latitude;
            
            
            [self.annotation setCoordinate:self.region.center];
            
            [self.ibMapView setRegion:self.region animated:YES];
            
        } errorBlock:^(NSString *status) {
            
        }];
    }
    else{
        _region.center.longitude = lont;
        _region.center.latitude = lat;
        
        [self.annotation setCoordinate:self.region.center];
        
        
        [self.ibMapView setRegion:self.region animated:YES];
        
    }
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
      //  pav.draggable = YES;
        pav.canShowCallout = YES;
        pav.image = [UIImage imageNamed:@"PinInMap.png"];

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
            weakSelf.rModel.arrOperatingHours = [arrayOpeningHours mutableCopy];
        
        };
    }
    return _editHoursViewController;
}

#pragma mark - Save Data
-(void)saveData
{
    self.rModel.formattedAddress =  self.addNewPlaceSubView.txtAddress.text;
    self.rModel.formattedPhone =  self.addNewPlaceSubView.txtPhoneNo.text;
    self.rModel.name =  self.addNewPlaceSubView.txtPlaceName.text;
    self.rModel.url =  self.addNewPlaceSubView.txtURL.text;
    self.rModel.price =  self.addNewPlaceSubView.txtPerPax.text;
    self.rModel.currency = self.addNewPlaceSubView.btnCurrency.titleLabel.text;    
}

@end
