//
//  CT3_EnableLocationViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/25/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_EnableLocationViewController.h"
#import "SearchLocationViewController.h"


@interface CT3_EnableLocationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAllowAccess;
@property (weak, nonatomic) IBOutlet UIButton *btnNotNow;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;


@property(nonatomic,strong)SearchLocationViewController* searchLocationViewController;
@end

@implementation CT3_EnableLocationViewController
- (IBAction)btnAllowAccessClicked:(id)sender {
    
    
    if ([SearchManager isDeviceGPSTurnedOn]) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

    }

//    [[SearchManager Instance]startSearchGPSLocation:^(CLLocation * location){
//        
//        if (self.didFinishSearchLocationBlock) {
//            self.didFinishSearchLocationBlock();
//        }
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    self.lblDesc.text = LocalisedString(@"You can change this setting in your Location Service");
    self.lblTitle.text = LocalisedString(@"Hey there! Do enable location to give & receive the best recommendations and deals near you.");
    [self.btnAllowAccess setTitle:LocalisedString(@"Allow location access") forState:UIControlStateNormal];
    [self.btnNotNow setTitle:LocalisedString(@"Not now") forState:UIControlStateNormal];

}
- (IBAction)btnNotNowClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Declaration

-(SearchLocationViewController*)searchLocationViewController
{
    if (!_searchLocationViewController) {
        _searchLocationViewController = [SearchLocationViewController new];
    }
    
    return _searchLocationViewController;
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

@end
