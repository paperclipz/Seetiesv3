//
//  CT3_ReferalViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 20/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_ReferalViewController.h"

@interface CT3_ReferalViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
@property (weak, nonatomic) IBOutlet UIView *ibReferralCodeView;
@property (weak, nonatomic) IBOutlet UILabel *ibReferralCode;
@property (weak, nonatomic) IBOutlet UILabel *ibReferralDesc;
@property (weak, nonatomic) IBOutlet UILabel *ibCampaignExpiry;
@property (weak, nonatomic) IBOutlet UILabel *ibCampaignDesc;
@property (weak, nonatomic) IBOutlet UIButton *ibInviteFriendsBtn;

@end

@implementation CT3_ReferalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [Utils setRoundBorder:self.ibReferralCodeView color:[UIColor whiteColor] borderRadius:8.0f borderWidth:2];
    [Utils setRoundBorder:self.ibInviteFriendsBtn color:[UIColor clearColor] borderRadius:self.ibInviteFriendsBtn.frame.size.height/2];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)changeLanguage{
    self.ibHeaderTitle.text = LocalisedString(@"Invite Friends & Get Reward");
    self.ibReferralDesc.text = LocalisedString(@"Tap to copy");
    self.ibCampaignDesc.text = LocalisedString(@"Send friends a mystery gift and you'll get one too. Details");
    [self.ibInviteFriendsBtn setTitle:LocalisedString(@"Invite Friends") forState:UIControlStateNormal];
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
- (IBAction)btnInviteFriendsClicked:(id)sender {
    CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
    dataToPost.shareType = ShareTypeReferralInvite;
    dataToPost.shareID = @"samuel5372";     //To be changed
    [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];
}

- (IBAction)btnCampaignDescClicked:(id)sender {
}

@end
