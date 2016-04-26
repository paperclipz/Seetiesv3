//
//  MapViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/25/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//



typedef void (^ViewDidDismissBlock)(MKCoordinateRegion object);
@interface MapViewController : CommonViewController<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *ibMapView;
@property (strong, nonatomic) CLLocation *location;

@property(nonatomic,copy)ViewDidDismissBlock viewDidDismissBlock;
-(void)initData:(MKCoordinateRegion)tempRegion;
-(void)initData:(MKCoordinateRegion)tempRegion EnableRePin:(BOOL)repin;

@end
