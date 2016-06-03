//
//  HowToRedeemViewController.m
//  Seeties
//
//  Created by Lup Meng Poo on 30/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "HowToRedeemViewController.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "DealRedeemViewController.h"

@interface HowToRedeemViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ibHowToRedeemTitle;
@property (weak, nonatomic) IBOutlet YLImageView *ibFirstImage;
@property (weak, nonatomic) IBOutlet UILabel *ibFirstNumber;
@property (weak, nonatomic) IBOutlet UILabel *ibFirstInstruction;
@property (weak, nonatomic) IBOutlet YLImageView *ibSecondImage;
@property (weak, nonatomic) IBOutlet UILabel *ibSecondNumber;
@property (weak, nonatomic) IBOutlet UILabel *ibSecondInstruction;
@property (weak, nonatomic) IBOutlet YLImageView *ibThirdImage;
@property (weak, nonatomic) IBOutlet UILabel *ibThirdNumber;
@property (weak, nonatomic) IBOutlet UILabel *ibThirdInstruction;
@property (weak, nonatomic) IBOutlet UILabel *ibFooterInstruction;
@property (weak, nonatomic) IBOutlet UIButton *ibNextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibHowToRedeemTopConstraint;

@property(nonatomic) NSUserDefaults *userDefault;
@end

@implementation HowToRedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    [self initSelfView];
    
    CGRect screenSize = [Utils getDeviceScreenSize];
    if (screenSize.size.height > 480) {
        self.ibHowToRedeemTopConstraint.constant = 60;
    }
    else{
        self.ibHowToRedeemTopConstraint.constant = 8;
    }
    [self.view refreshConstraint];
}

-(void)initSelfView{
    [self.ibFirstNumber setRoundedBorder];
    [self.ibSecondNumber setRoundedBorder];
    [self.ibThirdNumber setRoundedBorder];
    [Utils setRoundBorder:self.ibNextBtn color:[UIColor clearColor] borderRadius:self.ibNextBtn.frame.size.height/2];
    
    self.ibFirstImage.image = [YLGIFImage imageNamed:@"HowToRedeem1.gif"];
    self.ibSecondImage.image = [YLGIFImage imageNamed:@"HowToRedeem2.gif"];
    self.ibThirdImage.image = [YLGIFImage imageNamed:@"HowToRedeem3.gif"];
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
    [self.userDefault setBool:YES forKey:@"ShownRedeemTutorial"];
}

-(void)changeLanguage{
    self.ibHowToRedeemTitle.text = LocalisedString(@"Redeem in 3 simple steps");
    self.ibFirstInstruction.text = LocalisedString(@"Approach the shop personnel when you order.");
    self.ibSecondInstruction.text = LocalisedString(@"Flash the Redeem Voucher screen");
    self.ibThirdInstruction.text = LocalisedString(@"Swipe right to redeem!");
    self.ibFooterInstruction.text = LocalisedString(@"Limited to one redemption per swipe");
    [self.ibNextBtn setTitle:LocalisedString(@"Next") forState:UIControlStateNormal];
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

- (IBAction)btnNextClicked:(id)sender {
    DealRedeemViewController *redeemVC = [DealRedeemViewController new];
    [redeemVC initWithTutorial];
    [self.navigationController pushViewController:redeemVC animated:YES];
}

#pragma mark - Declaration
-(NSUserDefaults *)userDefault{
    
    if (!_userDefault) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefault;
}

@end
