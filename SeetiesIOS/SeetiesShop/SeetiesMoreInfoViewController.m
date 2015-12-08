//
//  SeetiesMoreInfoViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeetiesMoreInfoViewController.h"

@interface SeetiesMoreInfoViewController ()<MKMapViewDelegate>
{

    __weak IBOutlet NSLayoutConstraint *constlblAddressDesc_Height;

}
// ============ IBOUTLET======================//
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;

// ---------------- ADDRESS----------------------//
@property (weak, nonatomic) IBOutlet UIView *ibAddressView;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblNearbyDesc;

// ---------------- ADDRESS----------------------//

@property (weak, nonatomic) IBOutlet UIView *ibPhoneNumberView;
@property (weak, nonatomic) IBOutlet UIView *ibHourView;
@property (weak, nonatomic) IBOutlet UIView *ibURLView;
@property (weak, nonatomic) IBOutlet UIView *ibFacebookLinkView;
@property (weak, nonatomic) IBOutlet UIView *ibPriceView;

@property (strong, nonatomic) IBOutlet MKMapView *ibMapView;
@property(nonatomic,assign)MKCoordinateRegion region;
@property(strong,nonatomic)MKPointAnnotation* annotation;
@property (strong, nonatomic) NSMutableArray *arrViews;

@end

@implementation SeetiesMoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self addViews];
    [self adjustView:self.arrViews[self.arrViews.count-1] :(int)(self.arrViews.count - 1)];
    UIView* lastView = [self.arrViews lastObject];
    self.ibScrollView.contentSize = CGSizeMake( self.ibScrollView.frame.size.width, lastView.frame.size.height+ lastView.frame.origin.y);
    
    self.ibMapView.delegate = self;
    
    
    [[SearchManager Instance]getCoordinateFromGPSThenWifi:^(CLLocation *currentLocation) {
        _region.center.longitude = currentLocation.coordinate.longitude;
        _region.center.latitude = currentLocation.coordinate.latitude;
        
        
        [self.annotation setCoordinate:self.region.center];
        
        [self.ibMapView setRegion:self.region animated:YES];
        
    } errorBlock:^(NSString *status) {
        
    }];

}

-(void)setupView
{
    
    self.arrViews = [NSMutableArray new];
    
    [self.arrViews addObject:self.ibMapView];
    [self.ibMapView reloadInputViews];
    [self.arrViews addObject:self.ibAddressView];
    [self.arrViews addObject:self.ibPhoneNumberView];
    [self.arrViews addObject:self.ibHourView];
    [self.arrViews addObject:self.ibURLView];
    [self.arrViews addObject:self.ibFacebookLinkView];
    [self.arrViews addObject:self.ibPriceView];

    self.lblAddressDesc.text =self.seShopModel.location.formatted_address;
    
    [self updateConstraintForLabel:self.lblAddressDesc labelHeightConst:constlblAddressDesc_Height superView:self.ibAddressView lasSubView:self.lblNearbyDesc];
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
