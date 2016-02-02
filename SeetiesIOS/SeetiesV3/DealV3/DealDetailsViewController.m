//
//  DealDetailsViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 29/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealDetailsViewController.h"

@interface DealDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderSubTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *ibMainContentView;

@property (weak, nonatomic) IBOutlet UIView *ibHeaderContentView;
@property (weak, nonatomic) IBOutlet UIView *ibDealDetailsContentView;
@property (weak, nonatomic) IBOutlet UIView *ibAvailabilityContentView;
@property (weak, nonatomic) IBOutlet UIView *ibShopContentView;
@property (weak, nonatomic) IBOutlet UIView *ibTnCContentView;
@property (weak, nonatomic) IBOutlet UIView *ibDealsContentView;
@property (weak, nonatomic) IBOutlet UIView *ibNearbyShopContentView;
@property (weak, nonatomic) IBOutlet UIView *ibReportContentView;
@end

@implementation DealDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
- (IBAction)buttonShareClicked:(id)sender {
}
- (IBAction)buttonTranslateClicked:(id)sender {
}

@end
