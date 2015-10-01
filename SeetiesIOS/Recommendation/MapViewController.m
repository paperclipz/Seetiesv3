//
//  MapViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/25/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property(nonatomic,assign)MKCoordinateRegion region;
@property(nonatomic,strong)MKPointAnnotation* annotation;


@end

@implementation MapViewController
- (IBAction)btnBackClicked:(id)sender {
    
    
    if (self.viewDidDismissBlock) {
        self.viewDidDismissBlock(self.region);
    }
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
      // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.3f;
    [self.ibMapView addGestureRecognizer:lpgr];
    self.ibMapView.delegate = self;

    self.ibMapView.delegate = self;
    [self.ibMapView addAnnotation:self.annotation];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.ibMapView setRegion:self.region animated:YES];
    
    
    [self.annotation setCoordinate:self.region.center];

}

-(MKPointAnnotation*)annotation
{
    if(!_annotation)
    {
        _annotation = [MKPointAnnotation new];
        [_annotation setCoordinate:self.region.center];
        [_annotation setTitle:@"is This the Location?"]; //You can set the subtitle too
      

    }
    return _annotation;
}

-(void)initData:(MKCoordinateRegion)tempRegion
{
    _region = tempRegion;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MAP VIEW DELEGATE


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"pin";

    MKAnnotationView *pav = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pav == nil)
    {
        pav = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pav.draggable = YES;
        pav.canShowCallout = YES;
        pav.image = [UIImage imageNamed:@"PinInMap.png"];
        pav.calloutOffset = CGPointMake(0, 0);
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

@end
