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
        self.btnPressDoneBlock(nil);
}
- (IBAction)btnViewLargeMapClicke:(id)sender {
    
    if (self.navigationController) {
        [self.mapViewController initData:self.region];
        [self.navigationController pushViewController:self.mapViewController animated:YES];
    }
}

- (IBAction)btnBackClicked:(id)sender {
    
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];

    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
  //  [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.lblTitle.text = self.title;
    
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
    _region.span.latitudeDelta = 0.01;
    _region.span.longitudeDelta = 0.01;

    
    switch (self.searchType) {
        default:

        case SearchTypeFourSquare:
            
            break;
        case SearchTypeGoogle:

            break;
    }
}

-(AddNewPlaceSubView*)addNewPlaceSubView
{
    if(!_addNewPlaceSubView)
    {
    
        _addNewPlaceSubView = [AddNewPlaceSubView initializeCustomView];
        __weak typeof(self)weakSelf = self;
        _addNewPlaceSubView.btnEditHourClickedBlock = ^(id sender)
        {
            [weakSelf presentViewController:weakSelf.editHoursViewController animated:YES completion:nil];
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

-(void)initDataFrom4Square:(VenueModel*)model
{
    self.searchType = SearchTypeFourSquare;
    self.fsModel = model;
    [self reloadData];
}


-(void)reloadData
{
    
    switch (self.searchType) {
        default:
        case SearchTypeGoogle:
            self.addNewPlaceSubView.txtPlaceName.text = self.gooModel.name;
            self.addNewPlaceSubView.txtAddress.text = self.gooModel.formatted_address;
            self.addNewPlaceSubView.txtURL.text = self.gooModel.website;
            self.addNewPlaceSubView.txtPhoneNo.text = self.gooModel.formatted_phone_number;

            break;
        case SearchTypeFourSquare:
       
            self.addNewPlaceSubView.txtPlaceName.text = self.fsModel.name;
            self.addNewPlaceSubView.txtAddress.text = self.fsModel.address;
            self.addNewPlaceSubView.txtURL.text = @"";
            self.addNewPlaceSubView.txtPhoneNo.text = self.fsModel.phone;

        break;
    
    }
  
}

#pragma mark - Request Sever
-(void)requestForGoogleMapDetails
{
    
    NSDictionary* dict = @{@"placeid":self.placeID,@"key":GOOGLE_API_KEY};
    [[ConnectionManager Instance] requestServerwithAppendString:GOOGLE_PLACE_DETAILS_API requestType:ServerRequestTypeGoogleSearchWithDetail param:dict completionHandler:^(id object) {
        
        self.gooModel = [[DataManager Instance] googleSearchDetailModel];
        [self reloadData];
    } errorHandler:^(NSError *error) {
    }];

}


-(void)refreshMapViewWithLatitude:(double)lat longtitude:(double)lont
{
    _region.span.latitudeDelta = 0.01;
    _region.span.longitudeDelta = 0.01;
    _region.center.longitude = lont;
    _region.center.latitude = lat;
    
    if (_annotation) {
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
            [weakSelf refreshMapViewWithLatitude:region.center.latitude longtitude:region.center.longitude];
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
-(EditHoursViewController*)editHoursViewController
{
    
    if(!_editHoursViewController)
    {
        _editHoursViewController = [EditHoursViewController new];
    }
    return _editHoursViewController;
}
@end
