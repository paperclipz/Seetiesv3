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
@property (weak, nonatomic) IBOutlet UIButton *ibReferralDetailsBtn;

@property(nonatomic) NSString *referral;
@property(nonatomic) PromoPopOutViewController *promoPopoutViewController;
@property(nonatomic) InviteFriendModel *inviteFriendModel;
@end

@implementation CT3_ReferalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [Utils setRoundBorder:self.ibReferralCodeView color:[UIColor whiteColor] borderRadius:8.0f borderWidth:2];
    [Utils setRoundBorder:self.ibInviteFriendsBtn color:[UIColor clearColor] borderRadius:self.ibInviteFriendsBtn.frame.size.height/2];
    
    //Dummy referral code
    self.referral = @"SAMUEL5372";
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)changeLanguage{
    self.ibHeaderTitle.text = LocalisedString(@"Invite Friends & Get Reward");
    self.ibReferralDesc.text = LocalisedString(@"Tap to copy");
    
    NSString *languageCode = [Utils getDeviceAppLanguageCode];
    NSString *message = self.inviteFriendModel.message[languageCode]? self.inviteFriendModel.message[languageCode] : @"";
    self.ibCampaignDesc.text = LocalisedString(message);
    
    self.ibCampaignExpiry.text = LocalisedString(@"10 days left, hurry up");
    [self.ibInviteFriendsBtn setTitle:LocalisedString(@"Invite Friends") forState:UIControlStateNormal];
    [self.ibReferralDetailsBtn setTitle:LocalisedString(@"Details") forState:UIControlStateNormal];
   
    if (self.referral) {
        NSString *refCode = [LanguageManager stringForKey:@"Share your promo code\n{!referral}" withPlaceHolder:@{@"{!referral}":self.referral}];
        //    NSString *refCode = [NSString stringWithFormat:@"%@ is your referral code", self.referral];
        NSMutableAttributedString *attrRefCode = [[NSMutableAttributedString alloc] initWithString:refCode];
        NSRange refRange = [refCode rangeOfString:self.referral];
        [attrRefCode beginEditing];
        [attrRefCode addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30.0f] range:refRange];
        [attrRefCode addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:254/255.0f green:236/255.0f blue:108/255.0f alpha:1] range:refRange];
        [attrRefCode endEditing];
        self.ibReferralCode.attributedText = attrRefCode;
    }
   
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

#pragma mark - IBAction
- (IBAction)btnInviteFriendsClicked:(id)sender {
    CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
    dataToPost.shareType = ShareTypeReferralInvite;
    dataToPost.shareID = self.referral;     //To be changed
    [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];
}

- (IBAction)btnCampaignDescClicked:(id)sender {
    self.promoPopoutViewController = nil;
    [self.promoPopoutViewController setViewType:PopOutViewTypeMessage];
    [self.promoPopoutViewController setPopOutCondition:PopOutConditionChooseShopOnly];
    NSString *languageCode = [Utils getDeviceAppLanguageCode];
    NSString *message = self.inviteFriendModel.desc[languageCode]? self.inviteFriendModel.desc[languageCode] : @"";
    [self.promoPopoutViewController setMessage:message];
    
    STPopupController *popOutController = [[STPopupController alloc]initWithRootViewController:self.promoPopoutViewController];
    popOutController.containerView.backgroundColor = [UIColor clearColor];
    [popOutController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    [popOutController presentInViewController:self];
    [popOutController setNavigationBarHidden:YES];
}

- (IBAction)btnCopyReferralClicked:(id)sender {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:self.referral];
    [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Referral code copied") Type:TSMessageNotificationTypeMessage];
}

-(IBAction)backgroundViewDidTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Declaration
-(PromoPopOutViewController *)promoPopoutViewController{
    if (!_promoPopoutViewController) {
        _promoPopoutViewController = [PromoPopOutViewController new];
    }
    return _promoPopoutViewController;
}

-(InviteFriendModel *)inviteFriendModel{
    if (!_inviteFriendModel) {
        CountriesModel *countries = [[DataManager Instance] appInfoModel].countries;
        _inviteFriendModel = countries.current_country.invite_friend_banner;
    }
    return _inviteFriendModel;
}

@end
