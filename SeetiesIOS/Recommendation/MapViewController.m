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
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
      // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    
    self.ibMapView.delegate = self;
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
        [self.ibMapView addAnnotation:_annotation];


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

@end
