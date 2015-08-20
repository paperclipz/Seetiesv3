//
//  AddNewPlaceViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "AddNewPlaceViewController.h"

@interface AddNewPlaceViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *ibMapView;
@property (strong, nonatomic)SearchLocationModel* model;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;

@end

@implementation AddNewPlaceViewController

- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
  //  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self requestForGoogleMapDetails];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    self.addNewPlaceSubView = [AddNewPlaceSubView initializeCustomView];
    [self.ibScrollView addSubview:self.addNewPlaceSubView];
  //  self.addNewPlaceSubView.frame = CGRectMake(0, 0, self.ibScrollView.frame.size.width, self.addNewPlaceSubView.frame.size.height);
    
    self.ibScrollView.contentSize = self.addNewPlaceSubView.frame.size;
}

-(void)initData:(SearchLocationModel*)model
{
    self.model = model;
}

-(void)requestForGoogleMapDetails
{

    NSDictionary* dict = @{@"placeid":self.model.place_id,@"key":GOOGLE_API_KEY};
    [[ConnectionManager Instance] requestServerwithAppendString:GOOGLE_PLACE_DETAILS_API param:dict completionHandler:^(id object) {
     
        NSDictionary* dict = object;
        self.model.latitude = dict[@"result"][@"geometry"][@"location"][@"lat"];
        self.model.longitude = dict[@"result"][@"geometry"][@"location"][@"lng"];

        [self refreshMapView];
       // SLog(@"%@",object);
    
    } errorHandler:^(NSError *error) {
    }];

}


-(void)refreshMapView
{
    
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake([self.model.latitude doubleValue], [self.model.longitude doubleValue]);
    MKCoordinateRegion adjustedRegion = [self.ibMapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200)];
    [self.ibMapView setRegion:adjustedRegion animated:YES];
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
