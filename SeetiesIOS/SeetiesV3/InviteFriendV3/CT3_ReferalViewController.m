//
//  CT3_ReferalViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 20/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_ReferalViewController.h"

@interface CT3_ReferalViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contLeading;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibBackgroundImg;
@property (weak, nonatomic) IBOutlet UIView *ibReferralCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibReferralCodeViewtConstraint;
@property (weak, nonatomic) IBOutlet UILabel *ibReferralCode;
@property (weak, nonatomic) IBOutlet UILabel *ibReferralDesc;

@property (weak, nonatomic) IBOutlet UILabel *ibCampaignExpiry;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibCampaignExpiryConstraint;
@property (weak, nonatomic) IBOutlet UILabel *ibCampaignDesc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibCampaignDescConstraint;
@property (weak, nonatomic) IBOutlet UIButton *ibInviteFriendsBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibReferralDetailsBtn;

@property(nonatomic) ProfileModel *userProfile;
@property(nonatomic) PromoPopOutViewController *promoPopoutViewController;
@property(nonatomic) InviteFriendModel *inviteFriendModel;
@end

@implementation CT3_ReferalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = [Utils getDeviceScreenSize];
    if (frame.size.height <= 480) {
        self.contLeading.constant = 104;
        SLog(@"iphone4");
    }
    else if (frame.size.height <= 667){
        self.contLeading.constant = 74;
        SLog(@"iphone5/6");
    }
    else{
        self.contLeading.constant = 64;
        SLog(@"iphone6+");
    }
    
    self.ibReferralCodeViewtConstraint.constant = (frame.size.height <= 480)?60:88;
    
    // Do any additional setup after loading the view from its nib.
    
    [Utils setRoundBorder:self.ibReferralCodeView color:[UIColor whiteColor] borderRadius:8.0f borderWidth:2];
    [Utils setRoundBorder:self.ibInviteFriendsBtn color:[UIColor clearColor] borderRadius:self.ibInviteFriendsBtn.frame.size.height/2];
    
    if (![Utils isStringNull:self.inviteFriendModel.background_image]) {
        [self.ibBackgroundImg sd_setImageWithURL:[NSURL URLWithString:self.inviteFriendModel.background_image] placeholderImage:[UIImage imageNamed:@"ReferDefaultImg.png"]];
    }
    else{
        [self.ibBackgroundImg setImage:[UIImage imageNamed:@"ReferDefaultImg.png"]];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)changeLanguage{
    self.ibHeaderTitle.text = LocalisedString(@"Invite Friends & Get Rewards");
    self.ibReferralDesc.text = LocalisedString(@"Tap to copy");
    
    
    NSString *languageCode = [LanguageManager getDeviceAppLanguageCode];
    NSString *message = self.inviteFriendModel.message[languageCode]? self.inviteFriendModel.message[languageCode] : @"";
    self.ibCampaignDesc.text = LocalisedString(message);
    [self.ibCampaignDesc sizeToFit];
    self.ibCampaignDescConstraint.constant = self.ibCampaignDesc.frame.size.height;
    
    [self.ibInviteFriendsBtn setTitle:LocalisedString(@"Invite Friends") forState:UIControlStateNormal];
    [self.ibReferralDetailsBtn setTitle:LocalisedString(@"Details") forState:UIControlStateNormal];
   
    if (![Utils isStringNull:self.userProfile.referral_code]) {
        self.userProfile.referral_code = [self.userProfile.referral_code uppercaseString];
        NSString *refCode = [LanguageManager stringForKey:@"Share your referral code\n{!referral code}" withPlaceHolder:@{@"{!referral code}":self.userProfile.referral_code?self.userProfile.referral_code:@""}];
        NSMutableAttributedString *attrRefCode = [[NSMutableAttributedString alloc] initWithString:refCode];
        NSRange refRange = [refCode rangeOfString:self.userProfile.referral_code];
        [attrRefCode beginEditing];
        [attrRefCode addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30.0f] range:refRange];
        [attrRefCode addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0f green:236/255.0f blue:109/255.0f alpha:1] range:refRange];
        [attrRefCode endEditing];
        self.ibReferralCode.attributedText = attrRefCode;
    }
    
    if (self.inviteFriendModel.display_expired_period) {
        NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
        [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [utcDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *expiryDate = [utcDateFormatter dateFromString:self.inviteFriendModel.expired_at];
        
        NSInteger daysLeft = [Utils numberOfDaysLeft:expiryDate];
        self.ibCampaignExpiry.text = [LanguageManager stringForKey:@"Promo ends in {!days} days - don't wait!" withPlaceHolder:@{@"{!days}": @(daysLeft)}];
        self.ibCampaignExpiry.hidden = NO;
        self.ibCampaignExpiryConstraint.constant = 20;
    }
    else{
        self.ibCampaignExpiry.text = @"";
        self.ibCampaignExpiry.hidden = YES;
        self.ibCampaignExpiryConstraint.constant = 0;
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
    if (![Utils isStringNull:self.userProfile.referral_code]) {
        CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
        dataToPost.shareType = ShareTypeReferralInvite;
        dataToPost.shareID = self.userProfile.referral_code;
        [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];
    }
}

- (IBAction)btnCampaignDescClicked:(id)sender {
    self.promoPopoutViewController = nil;
    [self.promoPopoutViewController setViewType:PopOutViewTypeMessage];
    [self.promoPopoutViewController setPopOutCondition:PopOutConditionChooseShopOnly];
    NSString *languageCode = [LanguageManager getDeviceAppLanguageCode];
    NSString *message = self.inviteFriendModel.desc[languageCode]? self.inviteFriendModel.desc[languageCode] : @"";
    [self.promoPopoutViewController setMessage:message];
    
    STPopupController *popOutController = [[STPopupController alloc]initWithRootViewController:self.promoPopoutViewController];
    popOutController.containerView.backgroundColor = [UIColor clearColor];
    [popOutController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    [popOutController presentInViewController:self];
    [popOutController setNavigationBarHidden:YES];
}

- (IBAction)btnCopyReferralClicked:(id)sender {
    if (![Utils isStringNull:self.userProfile.referral_code]) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:self.userProfile.referral_code];
        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Code Copied") Type:TSMessageNotificationTypeSuccess];
    }
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

-(ProfileModel *)userProfile{
    if (!_userProfile) {
        _userProfile = [[DataManager Instance] getCurrentUserProfileModel];
    }
    return _userProfile;
}

@end
