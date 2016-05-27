//
//  PromoCodeViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 26/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PromoPopOutViewController.h"
#import "UIView+Toast.h"
#import "AMPopTip.h"

@interface PromoPopOutViewController ()
{
    NSCharacterSet *alphaNumericSet;
    NSCharacterSet *numericSet;
}

@property (nonatomic, strong) AMPopTip *popTip;

@property (strong, nonatomic) IBOutlet UIView *ibEnterPromoView;
@property (weak, nonatomic) IBOutlet UITextField *ibPromoCodeText;
@property (weak, nonatomic) IBOutlet UILabel *ibTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *ibEnterPromoContentView;
@property (weak, nonatomic) IBOutlet UIButton *ibEnterPromoSubmitBtn;

@property (strong, nonatomic) IBOutlet UIView *ibRedemptionSuccessfulView;
@property (weak, nonatomic) IBOutlet UIView *ibRedemptionSuccessfulContentView;
@property (weak, nonatomic) IBOutlet UIButton *ibRedemptionSuccessfulBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibRedemptionSuccessfulTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibRedemptionSuccessfulDesc;
@property (weak, nonatomic) IBOutlet UIView *ibRedemptionSuccessfulVoucherContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibVoucherContentHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibChooseShopView;
@property (weak, nonatomic) IBOutlet UIView *ibChooseShopContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibShopTable;
@property (weak, nonatomic) IBOutlet UILabel *ibShopDealLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibShopConfirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibChooseShopRedeemAt;

@property (strong, nonatomic) IBOutlet UIView *ibChangeVerifiedPhoneView;
@property (weak, nonatomic) IBOutlet UIView *ibChangeVerifiedPhoneContentView;
@property (weak, nonatomic) IBOutlet UIButton *ibChangeVerifiedPhoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibChangeVerifiedPhoneNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibChangeVerifiedPhoneDescLbl;

@property (strong, nonatomic) IBOutlet UIView *ibEnterPhoneView;
@property (weak, nonatomic) IBOutlet UIView *ibEnterPhoneContentView;
@property (weak, nonatomic) IBOutlet UIButton *ibEnterPhoneConfirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *ibEnterPhoneTxtField;
@property (weak, nonatomic) IBOutlet UILabel *ibEnterPhoneDesc;
@property (weak, nonatomic) IBOutlet UILabel *ibEnterPhoneTitle;
@property (weak, nonatomic) IBOutlet UIView *ibEnterPhoneCountryCodeView;
@property (weak, nonatomic) IBOutlet UILabel *ibEnterPhoneCountryCodeLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibEnterPhoneCountryCodeBtn;

@property (strong, nonatomic) IBOutlet UIView *ibConfirmPhoneView;
@property (weak, nonatomic) IBOutlet UIView *ibConfirmPhoneContentView;
@property (weak, nonatomic) IBOutlet UIButton *ibConfirmPhoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibConfirmPhoneNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibConfirmPhoneDescLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibConfirmPhoneChangeBtn;

@property (strong, nonatomic) IBOutlet UIView *ibEnterVerificationView;
@property (weak, nonatomic) IBOutlet UIView *ibEnterVerificationContentView;
@property (weak, nonatomic) IBOutlet UIButton *ibEnterVerificationConfirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *ibEnterVerificationTxtField;
@property (weak, nonatomic) IBOutlet UILabel *ibEnterVerificationDesc;
@property (weak, nonatomic) IBOutlet UILabel *ibEnterVerificationTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibEnterVerificationResendBtn;

@property (strong, nonatomic) IBOutlet UIView *ibVerifiedView;
@property (weak, nonatomic) IBOutlet UIView *ibVerifiedContentView;
@property (weak, nonatomic) IBOutlet UIButton *ibVerifiedOkBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibVerifiedTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibVerifiedDesc;

@property (strong, nonatomic) IBOutlet UIView *ibErrorView;
@property (weak, nonatomic) IBOutlet UIView *ibErrorContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibErrorTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibErrorDesc;
@property (weak, nonatomic) IBOutlet UILabel *ibErrorDateDay;
@property (weak, nonatomic) IBOutlet UILabel *ibErrorTime;
@property (weak, nonatomic) IBOutlet UIButton *ibErrorOkBtn;

@property (strong, nonatomic) IBOutlet UIView *ibThankYouView;
@property (weak, nonatomic) IBOutlet UIView *ibThankYouContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibThankYouTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibThankYouDesc;
@property (weak, nonatomic) IBOutlet UIButton *ibThankYouOkBtn;

@property (strong, nonatomic) IBOutlet UIView *ibMessageView;
@property (weak, nonatomic) IBOutlet UIView *ibMessageContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibMessageLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibMessageOkBtn;

@property (strong, nonatomic) IBOutlet UIView *ibReferralSuccessfulView;
@property (weak, nonatomic) IBOutlet UIView *ibReferralSuccessfulContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibReferralSuccessfulTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibReferralSuccessfulDesc;
@property (weak, nonatomic) IBOutlet UIButton *ibReferralSuccessfulOkBtn;

@property(nonatomic,assign)PopOutViewType viewType;
@property(nonatomic,assign)PopOutCondition popOutCondition;
@property(nonatomic) NSArray<SeShopDetailModel> *shopArray;
@property(nonatomic) NSString *selectedCountryCode;
@property(nonatomic) NSString *enteredPhoneNumber;
@property(nonatomic) NSString *enteredPromoCode;
@property(nonatomic) SeShopDetailModel *selectedShop;
@property(nonatomic) DealModel *dealModel;
@property(nonatomic) DealsModel *dealsModel;
@property(nonatomic) BOOL isLoading;
@property(nonatomic) BOOL isVerified;
@property(nonatomic) BOOL hasRequestedTotp;
@property(nonatomic) BOOL hasRequestedPromo;
@property(nonatomic) BOOL hasRedeemed;
@property(nonatomic) BOOL isReferral;
@property(nonatomic) NSString *message;

@end

@implementation PromoPopOutViewController

-(instancetype)init{
    self = [super init];
    
    if (self) {
        _viewType = PopOutViewTypeEnterPromo;
        self.contentSizeInPopup = CGSizeMake(300, 400);
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    alphaNumericSet = [NSCharacterSet alphanumericCharacterSet];
    numericSet = [NSCharacterSet decimalDigitCharacterSet];
    self.isLoading = NO;
    self.isVerified = NO;
    self.hasRequestedTotp = NO;
    self.hasRequestedPromo = NO;
    self.hasRedeemed = NO;
    self.isReferral = NO;
    self.ibPromoCodeText.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self setMainViewToDisplay];
   
    // Do any additional setup after loading the view from its nib.
//    self.contentSizeInPopup = [self getMainView].frame.size;

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

-(void)setViewType:(PopOutViewType)viewType{
    _viewType = viewType;
    
    switch (self.viewType) {
//        case PopOutViewTypeEnterPromo:
//        case PopOutViewTypeVerified:
//        case PopOutViewTypeConfirmPhone:
//        case PopOutViewTypeChangeVerifiedPhone:
//        case PopOutViewTypeRedemptionSuccessful:
//        case PopOutViewTypeThankYou:
//            self.contentSizeInPopup = CGSizeMake([Utils getDeviceScreenSize].size.width - 40, [Utils getDeviceScreenSize].size.height - 270);
//            break;
//            
//        case PopOutViewTypeError:
//        case PopOutViewTypeEnterVerification:
//        case PopOutViewTypeEnterPhone:
//            self.contentSizeInPopup = CGSizeMake([Utils getDeviceScreenSize].size.width - 40, [Utils getDeviceScreenSize].size.height - 208);
//            break;
            
        default:
            self.contentSizeInPopup = CGSizeMake(300, 400);
            break;
    }
}

-(void)setPopOutCondition:(PopOutCondition)popOutCondition{
    _popOutCondition = popOutCondition;
}

-(void)setShopArray:(NSArray<SeShopDetailModel> *)array{
    _shopArray = array;
    
    int counter = 4;
    float headerAndFooterHeight = 140;
    float tableHeight = self.shopArray.count>counter? [PromoOutletCell getHeight]*counter : [PromoOutletCell getHeight]*self.shopArray.count;
    
    self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, tableHeight+headerAndFooterHeight);
}

-(void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
}

-(void)setDealsModel:(DealsModel *)dealsModel{
    _dealsModel = dealsModel;
}

-(void)setSelectedCountryCode:(NSString *)selectedCountryCode{
    _selectedCountryCode = selectedCountryCode;
}

-(void)setEnteredPhoneNumber:(NSString *)enteredPhoneNumber{
    _enteredPhoneNumber = enteredPhoneNumber;
}

-(void)setEnteredPromoCode:(NSString *)enteredPromoCode{
    _enteredPromoCode = enteredPromoCode;
}

-(void)setSelectedShop:(SeShopDetailModel *)selectedShop{
    _selectedShop = selectedShop;
}

-(void)setMessage:(NSString *)message{
    _message = message;
}

-(void)setMainViewToDisplay{
    [self setView:[self getMainView]];
    [self.view setNeedsLayout];
}

-(UIView*)getMainView{
    switch (self.viewType) {
        case PopOutViewTypeEnterPromo:
        {
            self.ibTitleLbl.text = LocalisedString(@"Enter a promo code");
            self.ibPromoCodeText.placeholder = LocalisedString(@"Enter here");
            [self.ibEnterPromoSubmitBtn setTitle:LocalisedString(@"Submit") forState:UIControlStateNormal];
            
            self.ibPromoCodeText.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            [self.view refreshConstraint];
            [self.ibEnterPromoContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            [Utils setRoundBorder: self.ibPromoCodeText color:[UIColor clearColor] borderRadius:self.ibPromoCodeText.frame.size.height/2];
        }
            return self.ibEnterPromoView;
            
        case PopOutViewTypeChooseShop:
        {
            [self.ibShopTable registerClass:[PromoOutletCell class] forCellReuseIdentifier:@"PromoOutletCell"];
            
            self.ibChooseShopRedeemAt.text = LocalisedString(@"Select outlet to redeem from");
            [self.ibShopConfirmBtn setTitle:LocalisedString(@"Confirm") forState:UIControlStateNormal];
            
//            int counter = 4;
//            float headerAndFooterHeight = 140;
//            float tableHeight = self.shopArray.count>counter? [PromoOutletCell getHeight]*counter : [PromoOutletCell getHeight]*self.shopArray.count;
//            
//            self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, tableHeight+headerAndFooterHeight);
            [Utils setRoundBorder:self.ibChooseShopContentView color:[UIColor clearColor] borderRadius:8.0f];
            
            if (self.dealModel) {
                if ([Utils isStringNull:self.dealModel.cover_title]) {
                    self.ibShopDealLbl.text = self.dealModel.title;
                }
                else{
                    self.ibShopDealLbl.text = self.dealModel.cover_title;
                }
            }
            else if (self.dealsModel){
                DealModel *deal = self.dealsModel.arrDeals[0];
                if ([Utils isStringNull:deal.cover_title]) {
                    self.ibShopDealLbl.text = deal.title;
                }
                else{
                    self.ibShopDealLbl.text = deal.cover_title;
                }
            }
        }
            return self.ibChooseShopView;
            
        case PopOutViewTypeRedemptionSuccessful:
        {
            self.ibRedemptionSuccessfulTitle.text = LocalisedString(@"Yay!");
            self.ibRedemptionSuccessfulDesc.text = LocalisedString(@"is now in your wallet!");
            [self.ibRedemptionSuccessfulBtn setTitle:LocalisedString(@"View voucher details") forState:UIControlStateNormal];
            
            if (self.dealsModel) {
                int numberOfLines = 0;
                float fontSize = 15.0f;
                float heightPerLine = 15.0f;
                NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
                switch (self.dealsModel.arrDeals.count) {
                    case 1:
                        numberOfLines = 0;
                        break;
                    case 2:
                        numberOfLines = 3;
                        break;
                    case 3:
                        numberOfLines = 2;
                        break;
                    default:
                        numberOfLines = 1;
                        break;
                }
                float maxHeight = numberOfLines == 0? CGFLOAT_MAX : heightPerLine*numberOfLines;
                
                CGFloat yOrigin = 0;
                CGFloat padding = 5;
                for (DealModel *deal in self.dealsModel.arrDeals) {
                    NSString *displayString = [NSString stringWithFormat:@"\u2022 %@", deal.title];
                    CGRect voucherRect = [displayString boundingRectWithSize:CGSizeMake(self.ibRedemptionSuccessfulVoucherContent.frame.size.width, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
                    
                    UILabel *voucherLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, yOrigin, voucherRect.size.width, voucherRect.size.height)];
                    voucherLbl.font = [UIFont systemFontOfSize:fontSize];
                    voucherLbl.textColor = DEVICE_COLOR;
                    voucherLbl.numberOfLines = numberOfLines;
                    voucherLbl.textAlignment = NSTextAlignmentCenter;
                    voucherLbl.text = displayString;
                    
                    [self.ibRedemptionSuccessfulVoucherContent addSubview:voucherLbl];
                    yOrigin += voucherRect.size.height + padding;
                }
                
                self.ibVoucherContentHeightConstraint.constant = yOrigin;
                [self.view layoutIfNeeded];
            }
            CGFloat heightDiff = self.ibVoucherContentHeightConstraint.constant - 15;
            self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, 400 + heightDiff);
            [Utils setRoundBorder:self.ibRedemptionSuccessfulContentView color:[UIColor clearColor] borderRadius:8.0f];
        }
            return self.ibRedemptionSuccessfulView;
            
        case PopOutViewTypeChangeVerifiedPhone:
        {
            self.ibChangeVerifiedPhoneDescLbl.text = LocalisedString(@"Your phone number has been verified");
            [self.ibChangeVerifiedPhoneBtn setTitle:LocalisedString(@"Change Phone Number") forState:UIControlStateNormal];
            
            [self.ibChangeVerifiedPhoneContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            ProfileModel* model = [[ConnectionManager dataManager]getCurrentUserProfileModel];
            
            if (![Utils isStringNull:model.contact_no]) {
                self.ibChangeVerifiedPhoneNumberLbl.text = [NSString stringWithFormat:@"+%@", model.contact_no];

            }
            else
            {
                self.ibVerifiedTitle.text = LocalisedString(@"Phone Number Verified");

            }
        }
            return self.ibChangeVerifiedPhoneView;
            
        case PopOutViewTypeEnterPhone:
        {
            self.ibEnterPhoneTitle.text = LocalisedString(@"Enter Phone Number");
            self.ibEnterPhoneDesc.text = LocalisedString(@"Please verify your phone number to collect the voucher.");
            self.ibEnterPhoneCountryCodeLbl.text = LocalisedString(@"Select Country Code");
            self.ibEnterPhoneTxtField.placeholder = LocalisedString(@"eg. 1x xxx xxxx");
            [self.ibEnterPhoneConfirmBtn setTitle:LocalisedString(@"Confirm") forState:UIControlStateNormal];
            
            self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, 470);
            [self.ibEnterPhoneContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            [Utils setRoundBorder:self.ibEnterPhoneTxtField color:[UIColor clearColor] borderRadius:self.ibEnterPhoneTxtField.frame.size.height/2];
            [Utils setRoundBorder:self.ibEnterPhoneCountryCodeView color:DEVICE_COLOR borderRadius:self.ibEnterPhoneCountryCodeView.frame.size.height/2];
        }
            return self.ibEnterPhoneView;
            
        case PopOutViewTypeConfirmPhone:
        {
            self.ibConfirmPhoneDescLbl.text = LocalisedString(@"Is this your phone number?");
            [self.ibConfirmPhoneChangeBtn setTitle:LocalisedString(@"Change Phone Number") forState:UIControlStateNormal];
            [self.ibConfirmPhoneBtn setTitle:LocalisedString(@"Confirm") forState:UIControlStateNormal];
            
            [self.ibConfirmPhoneContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            [Utils setRoundBorder:self.ibConfirmPhoneChangeBtn color:DEVICE_COLOR borderRadius:self.ibConfirmPhoneChangeBtn.frame.size.height/2];
            if (![Utils isStringNull:self.selectedCountryCode] && ![Utils isStringNull:self.enteredPhoneNumber]) {
                self.ibConfirmPhoneNumberLbl.text = [NSString stringWithFormat:@"+%@%@", self.selectedCountryCode, self.enteredPhoneNumber];
            }
        }
            return self.ibConfirmPhoneView;
            
        case PopOutViewTypeEnterVerification:
        {
            self.ibEnterVerificationTitle.text = LocalisedString(@"Enter Verification Code");
            [self.ibEnterVerificationResendBtn setTitle:LocalisedString(@"Resend Code") forState:UIControlStateNormal];
            [self.ibEnterVerificationConfirmBtn setTitle:LocalisedString(@"Confirm") forState:UIControlStateNormal];
            self.ibEnterVerificationTxtField.placeholder = LocalisedString(@"Enter 7-digit verification code");
            
            [self.ibEnterVerificationContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            [Utils setRoundBorder:self.ibEnterVerificationTxtField color:[UIColor clearColor] borderRadius:self.ibEnterVerificationTxtField.frame.size.height/2];
            [Utils setRoundBorder:self.ibEnterVerificationResendBtn color:DEVICE_COLOR borderRadius:self.ibEnterVerificationResendBtn.frame.size.height/2];
            [self.ibEnterVerificationResendBtn setTitleColor:DEVICE_COLOR forState:UIControlStateNormal];
            [self.ibEnterVerificationResendBtn setTitleColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1] forState:UIControlStateDisabled];
            if (![Utils isStringNull:self.selectedCountryCode] && ![Utils isStringNull:self.enteredPhoneNumber]) {
                NSString *phoneNumber = [NSString stringWithFormat:@"+%@%@", self.selectedCountryCode, self.enteredPhoneNumber];
                self.ibEnterVerificationDesc.text = [LanguageManager stringForKey:@"Please enter the 7-digit verification code that was sent to {!contact number} Code will expire in 30mins." withPlaceHolder:@{@"{!contact number}": phoneNumber?phoneNumber:@""}];
            }
        }
            return self.ibEnterVerificationView;
            
        case PopOutViewTypeVerified:
        {
            self.ibVerifiedTitle.text = LocalisedString(@"Phone number verification.");
            self.ibVerifiedDesc.text = LocalisedString(@"Thank you for verifying your phone number!");
            [self.ibVerifiedOkBtn setTitle:LocalisedString(@"Okay!") forState:UIControlStateNormal];
            
            [self.ibVerifiedContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
        }
            return self.ibVerifiedView;
            
        case PopOutViewTypeError:
        {
            self.ibErrorTitle.text = LocalisedString(@"Sorry! This voucher is currently not available for redemption.");
            self.ibErrorDesc.text = LocalisedString(@"This deal can only be redeemed on ");
            [self.ibErrorOkBtn setTitle:LocalisedString(@"Okay!") forState:UIControlStateNormal];
            
            [self.ibErrorContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            NSString *nextAvailability = [self.dealModel getNextAvailableRedemptionDateString];
            NSArray *stringArray = [nextAvailability componentsSeparatedByString:@"\n"];
            
            if (stringArray.count == 2) {
                self.ibErrorDateDay.text = stringArray[0];
                self.ibErrorTime.text = stringArray[1];
            }
            else{
                self.ibErrorDateDay.text = @"";
                self.ibErrorTime.text = @"";
            }
        }
            return self.ibErrorView;
            
        case PopOutViewTypeThankYou:
        {
            self.ibThankYouTitle.text = LocalisedString(@"Thank you for your suggestion!");
            self.ibThankYouDesc.text = LocalisedString(@"We'll get back to you soonest possible with an email update on your suggested place.");
            [self.ibThankYouOkBtn setTitle:LocalisedString(@"Okay!") forState:UIControlStateNormal];
            [Utils setRoundBorder:self.ibThankYouContentView color:[UIColor clearColor] borderRadius:8.0f];
        }
            return self.ibThankYouView;
            
        case PopOutViewTypeMessage:
        {
            self.ibMessageLbl.text = LocalisedString(self.message);
            [self.ibMessageOkBtn setTitle:LocalisedString(@"Okay!") forState:UIControlStateNormal];
            
            CGRect messageRect = [self.message boundingRectWithSize:CGSizeMake(self.ibMessageLbl.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
            
            CGFloat contentHeight = messageRect.size.height + self.ibMessageOkBtn.frame.size.height + 60 + 32;
            self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, contentHeight);
            [Utils setRoundBorder:self.ibMessageContentView color:[UIColor clearColor] borderRadius:8.0f];
        }
            return self.ibMessageView;
            
        case PopOutViewTypeReferralSuccessful:
        {
            self.ibReferralSuccessfulTitle.text = LocalisedString(@"Yay!");
            self.ibReferralSuccessfulDesc.text = LocalisedString(@"Collect your reward via your notification.");
            [self.ibReferralSuccessfulOkBtn setTitle:LocalisedString(@"Okay") forState:UIControlStateNormal];
            
            [Utils setRoundBorder:self.ibReferralSuccessfulContentView color:[UIColor clearColor] borderRadius:8.0f];
        }
            return self.ibReferralSuccessfulView;
            
        default:
        {
            [self.ibEnterPromoContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
        }
            return self.ibEnterPromoView;
    }
}

-(NSMutableArray*)getFormattedCountriesCode{
    CountriesModel *countries = [[DataManager Instance] appInfoModel].countries;
    if (!countries || [Utils isArrayNull:countries.countries]) {
        return nil;
    }
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (CountryModel *country in countries.countries) {
        if (country.home_filter_display) {
            NSString *formattedCountryCode = [NSString stringWithFormat:@"%@ (%@)", country.name, country.phone_country_code];
            [tempArr addObject:formattedCountryCode];
        }
    }
    return tempArr;
}

#pragma mark - Declaration

-(AMPopTip*)popTip
{
    if (!_popTip) {
        _popTip = [AMPopTip popTip];
        _popTip.shouldDismissOnTap = YES;
        _popTip.offset = -15;
        _popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        _popTip.popoverColor = SELECTED_RED;
    }
    
    return _popTip;
}

#pragma mark - IBAction

- (IBAction)selectCountryCodeBtnClicked:(id)sender {
    
    NSArray *formattedCountriesCode;

    @try {
        formattedCountriesCode = [self getFormattedCountriesCode];
        
    } @catch (NSException *exception) {
        
    }
    
    if (formattedCountriesCode) {
        
        CountriesModel *countriesModel = [[DataManager Instance] appInfoModel].countries;
        [ActionSheetStringPicker showPickerWithTitle:LocalisedString(@"Select Country Code")
                                                rows:formattedCountriesCode? formattedCountriesCode : [NSArray new]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               
                                               CountryModel *countryModel = countriesModel.countries[selectedIndex];
                                               NSString *countryCode = countryModel.phone_country_code;
                                               self.selectedCountryCode = [countryCode substringFromIndex:1];
                                               self.ibEnterPhoneCountryCodeLbl.text = formattedCountriesCode[selectedIndex];
                                               
                                           } cancelBlock:^(ActionSheetStringPicker *picker) {
                                               
                                           } origin:sender];

    }
    
}

- (IBAction)resendCodeBtnClicked:(id)sender {
    self.isVerified = NO;
    [self requestServerToGetTotp];
    self.ibEnterVerificationResendBtn.enabled = NO;
    [Utils setRoundBorder:self.ibEnterVerificationResendBtn color:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1] borderRadius:self.ibEnterVerificationResendBtn.frame.size.height/2];
}

- (IBAction)changePhoneNumberBtnClicked:(id)sender {
    [self.popupController popViewControllerAnimated:YES];
}

- (IBAction)buttonSubmitClicked:(id)sender {
  
    PromoPopOutViewController* nextVC = [PromoPopOutViewController new];
 
    switch (self.viewType) {
        case PopOutViewTypeEnterPromo:
        {
            if (self.hasRequestedPromo) {
                if (self.isReferral) {
                    [Utils requestServerForNotificationCount];
                    [nextVC setViewType:PopOutViewTypeReferralSuccessful];
                    break;
                }
                
                [nextVC setDealsModel:self.dealsModel];
                [nextVC setEnteredPromoCode:self.enteredPromoCode];
                nextVC.promoPopOutDelegate = self.promoPopOutDelegate;
                
                if (![Utils isArrayNull:self.dealsModel.arrDeals]) {
                    DealModel *deal = self.dealsModel.arrDeals[0];
                    if (deal.shops.count > 1) {
                        [nextVC setViewType:PopOutViewTypeChooseShop];
                        [nextVC setShopArray:deal.available_shops];
                    }
                    else{
                        if (self.hasRedeemed) {
                            [nextVC setSelectedShop:self.selectedShop];
                            [nextVC setViewType:PopOutViewTypeRedemptionSuccessful];
                        }
                        else{
                            self.selectedShop = deal.shops[0];
                            [self requestServerToRedeemPromoCode];
                            return;
                        }
                    }
                }
                
            }
            else{
                self.enteredPromoCode = self.ibPromoCodeText.text;
                [self requestServerToGetPromoCode];
                return;
            }
        }
            break;
            
        case PopOutViewTypeRedemptionSuccessful:
        {
            if (self.promoPopOutDelegate && [self.promoPopOutDelegate respondsToSelector:@selector(viewDealDetailsClicked:)]) {
                [self.promoPopOutDelegate viewDealDetailsClicked:self.dealsModel];
            }
            [nextVC setViewType:PopOutViewTypeQuit];
            
        }
            break;
            
        case PopOutViewTypeChooseShop:
        {
            NSIndexPath *selectedIndexPath = [self.ibShopTable indexPathForSelectedRow];
            if (selectedIndexPath) {
                self.selectedShop = [self.shopArray objectAtIndex:selectedIndexPath.row];
            }
            else{
                return;
            }
            
            if (self.popOutCondition == PopOutConditionChooseShopOnly) {
                if (self.promoPopOutDelegate && [self.promoPopOutDelegate respondsToSelector:@selector(chooseShopConfirmClicked:forShop:)]) {
                    [self.promoPopOutDelegate chooseShopConfirmClicked:self.dealModel forShop:self.selectedShop];
                    [nextVC setViewType:PopOutViewTypeQuit];
                }
            }
            else{
                if (self.hasRedeemed) {
                    nextVC.promoPopOutDelegate = self.promoPopOutDelegate;
                    [nextVC setSelectedShop:self.selectedShop];
                    [nextVC setDealsModel:self.dealsModel];
                    [nextVC setEnteredPromoCode:self.enteredPromoCode];
                    [nextVC setViewType:PopOutViewTypeRedemptionSuccessful];
                }
                else{
                    [self requestServerToRedeemPromoCode];
                }
            }
        }
            break;
            
        case PopOutViewTypeChangeVerifiedPhone:
        {
            if (YES) {
                [nextVC setViewType:PopOutViewTypeEnterPhone];
            }
        }
            break;

        case PopOutViewTypeEnterPhone:
        {
            if (![Utils isStringNull:self.ibEnterPhoneTxtField.text] && ![Utils isStringNull:self.selectedCountryCode]) {
                [nextVC setViewType:PopOutViewTypeConfirmPhone];
                [nextVC setSelectedCountryCode:self.selectedCountryCode];
                [nextVC setEnteredPhoneNumber:self.ibEnterPhoneTxtField.text];
            }
            else{
                [MessageManager showMessageInPopOut:LocalisedString(@"system")  subtitle:LocalisedString(@"Please enter your phone number and country code")];
//                [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Please enter your phone number and country code") Type:TSMessageNotificationTypeError];
                return;
            }
        }
            break;
            
        case PopOutViewTypeConfirmPhone:
        {
            if (self.hasRequestedTotp) {
                [nextVC setViewType:PopOutViewTypeEnterVerification];
                [nextVC setSelectedCountryCode:self.selectedCountryCode];
                [nextVC setEnteredPhoneNumber:self.enteredPhoneNumber];
            }
            else{
                [self requestServerToGetTotp];
                return;
            }
        }
            break;
            
        case PopOutViewTypeEnterVerification:
        {
            if (self.isVerified) {
                [nextVC setViewType:PopOutViewTypeVerified];
            }
            else{
                if (![Utils isStringNull:self.ibEnterVerificationTxtField.text]) {
                    [self requestServerToVerifyTotp];
                }
                
                return;
            }
            
        }
            break;
            
        case PopOutViewTypeVerified:
        {
            [nextVC setViewType:PopOutViewTypeQuit];
            
        }
            break;
            
        case PopOutViewTypeError:
        {
            if (YES) {
                [nextVC setViewType:PopOutViewTypeQuit];
            }
        }
            break;
            
        case PopOutViewTypeThankYou:
        {
            if (YES) {
                [nextVC setViewType:PopOutViewTypeQuit];
            }
        }
            break;
            
        case PopOutViewTypeMessage:
        {
            if (YES) {
                [nextVC setViewType:PopOutViewTypeQuit];
            }
        }
            break;
            
        case PopOutViewTypeReferralSuccessful:
        {
            if (YES) {
                [nextVC setViewType:PopOutViewTypeQuit];
            }
        }
            break;
            
        case PopOutViewTypeQuit:
        {
            if (YES) {
                [nextVC setViewType:PopOutViewTypeQuit];
            }
        }
            break;

        default:
            [nextVC setViewType:PopOutViewTypeQuit];

            break;
    }
    
    if (nextVC.viewType == PopOutViewTypeQuit) {
        [self.popupController dismiss];
    }
    else{
        [self.popupController pushViewController:nextVC animated:YES];

    }
    
}

- (IBAction)buttonCloseClicked:(id)sender{
    [self.popupController dismiss];
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![Utils isArrayNull:self.shopArray]) {
        return self.shopArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
    return [PromoOutletCell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PromoOutletCell *outletCell = [tableView dequeueReusableCellWithIdentifier:@"PromoOutletCell"];
    [outletCell setCellType:PromoOutletCellTypeSelection];
    SeShopDetailModel *shopModel = [self.shopArray objectAtIndex:indexPath.row];
    [outletCell setShopModel:shopModel];
    
    return outletCell;
}

#pragma mark - TextField
- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    if (textField == self.ibEnterVerificationTxtField) {
        [Utils setRoundBorder:self.ibEnterVerificationTxtField color:[UIColor clearColor] borderRadius:self.ibEnterVerificationTxtField.frame.size.height/2];
        self.ibEnterVerificationTxtField.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
        self.ibEnterVerificationTxtField.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    }
    else if (textField == self.ibPromoCodeText){
        [Utils setRoundBorder:self.ibPromoCodeText color:[UIColor clearColor] borderRadius:self.ibPromoCodeText.frame.size.height/2];
        self.ibPromoCodeText.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
        self.ibPromoCodeText.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.ibPromoCodeText) {
        BOOL isAlphaNumeric = [string rangeOfCharacterFromSet:alphaNumericSet].location != NSNotFound;
        BOOL isBackspace = [string isEqualToString:@""]? YES : NO;
        return (isAlphaNumeric || isBackspace);
    }
    else if (textField == self.ibEnterPhoneTxtField || textField == self.ibEnterVerificationTxtField){
        BOOL isNumeric = [string rangeOfCharacterFromSet:numericSet].location != NSNotFound;
        BOOL isBackspace = [string isEqualToString:@""]? YES : NO;
        return (isNumeric || isBackspace);
    }
    return YES;
}

#pragma mark - RequestServer

-(void)requestServerToGetTotp{
    if (self.isLoading) {
        return;
    }
    
    NSDictionary *dict = @{@"token": [Utils getAppToken],
                           @"phone_number": self.enteredPhoneNumber,
                           @"country_code": self.selectedCountryCode
                           };
    [LoadingManager show];
    self.isLoading = YES;
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostTOTP parameter:dict appendString:nil success:^(id object) {

        self.hasRequestedTotp = YES;
        [LoadingManager hide];
        self.isLoading = NO;
        if (self.viewType == PopOutViewTypeConfirmPhone) {
            [self buttonSubmitClicked:self.ibEnterPhoneConfirmBtn];
        }
        
    } failure:^(id object) {
        self.hasRequestedTotp = NO;
        self.isLoading = NO;
        [LoadingManager hide];
    }];
}

-(void)requestServerToVerifyTotp{
    if (self.isLoading) {
        return;
    }
    
    NSDictionary *dict = @{@"token": [Utils getAppToken],
                           @"code": self.ibEnterVerificationTxtField.text
                           };
    [LoadingManager show];
    self.isLoading = YES;
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostVerifyTOTP parameter:dict appendString:nil success:^(id object) {

        self.isVerified = YES;
        [LoadingManager hide];
        self.isLoading = NO;
        [self buttonSubmitClicked:self.ibConfirmPhoneBtn];
        
    } failure:^(id object) {
        [Utils setRoundBorder:self.ibEnterVerificationTxtField color:[UIColor colorWithRed:254/255.0f green:106/255.0f blue:106/255.0f alpha:1] borderRadius:self.ibEnterVerificationTxtField.frame.size.height/2];
        self.ibEnterVerificationTxtField.backgroundColor = [UIColor whiteColor];
        self.ibEnterVerificationTxtField.textColor = [UIColor colorWithRed:254/255.0f green:106/255.0f blue:106/255.0f alpha:1];
        [MessageManager showMessageInPopOut:LocalisedString(@"system") subtitle:LocalisedString(@"The verification code entered is invalid. Please check and try again.")];
//        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"The verification code entered is invalid. Please check and try again.") Type:TSMessageNotificationTypeError];
        self.isVerified = NO;
        self.isLoading = NO;
        [LoadingManager hide];
        
    }];
}

-(void)requestServerToGetPromoCode{
    if (self.isLoading) {
        return;
    }
    
    if ([Utils isStringNull:self.enteredPromoCode]) {
        return;
    }
    
    NSString *appendString = self.enteredPromoCode;
    NSDictionary *dict = @{@"promo_code": self.enteredPromoCode,
                           @"token": [Utils getAppToken]
                           };
    [LoadingManager show];
    self.isLoading = YES;
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetPromoCode parameter:dict appendString:appendString success:^(id object) {
        self.dealsModel = [[ConnectionManager dataManager] dealsModel];
        self.hasRequestedPromo = YES;
        [LoadingManager hide];
        self.isLoading = NO;
        
        @try {
            NSDictionary *dict = object[@"data"];
            NSString *type = dict[@"type"];
            
            self.isReferral = [type isEqualToString:VOUCHER_TYPE_REFERRAL];
        } @catch (NSException *exception) {
            self.isReferral = NO;
        }
        [self buttonSubmitClicked:self.ibEnterPromoSubmitBtn];
        
    } failure:^(id object) {
        [Utils setRoundBorder:self.ibPromoCodeText color:[UIColor colorWithRed:254/255.0f green:106/255.0f blue:106/255.0f alpha:1] borderRadius:self.ibPromoCodeText.frame.size.height/2];
        self.ibPromoCodeText.backgroundColor = [UIColor whiteColor];
        self.ibPromoCodeText.textColor = [UIColor colorWithRed:254/255.0f green:106/255.0f blue:106/255.0f alpha:1];
        [LoadingManager hide];
        self.isLoading = NO;
        self.hasRequestedPromo = NO;
        
        
        
        
        if ([ConnectionManager isNetworkAvailable]) {
            
            
            [self.popTip showText:[NSString stringWithFormat:@"%@",object] direction:AMPopTipDirectionUp maxWidth:self.ibEnterPromoView.frame.size.width inView:self.ibEnterPromoView fromFrame:self.ibPromoCodeText.frame duration:2.0f];
            
        }
        else{
            
            NSError* error = object;
            
            if (error) {
                [self.popTip showText:[NSString stringWithFormat:@"%@",error.localizedDescription] direction:AMPopTipDirectionUp maxWidth:self.ibEnterPromoView.frame.size.width inView:self.ibEnterPromoView fromFrame:self.ibPromoCodeText.frame duration:2.0f];

            }
            
        }
        

    }];
}

-(void)requestServerToRedeemPromoCode{
    if (self.isLoading) {
        return;
    }
    
    if([Utils isStringNull:self.enteredPromoCode])
    {
        return;
    }

    NSString *appendString = [NSString stringWithFormat:@"%@/redeem", self.enteredPromoCode];
   
    NSDictionary *dict = @{@"promo_code": self.enteredPromoCode?self.enteredPromoCode:@"",
                           @"token": [Utils getAppToken],
                           @"shop_id": self.selectedShop.seetishop_id?self.selectedShop.seetishop_id:@""
                           };
    [LoadingManager show];
    self.isLoading = YES;
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostRedeemPromoCode parameter:dict appendString:appendString success:^(id object) {

        self.dealsModel = [[ConnectionManager dataManager] dealsModel];
        self.hasRedeemed = YES;
        [LoadingManager hide];
        self.isLoading = NO;
        [self buttonSubmitClicked:self.ibEnterPromoSubmitBtn];
        if (self.promoPopOutDelegate && [self.promoPopOutDelegate respondsToSelector:@selector(promoHasBeenRedeemed:)]) {
            [self.promoPopOutDelegate promoHasBeenRedeemed:self.dealsModel];
        }
        
    } failure:^(id object) {
        [Utils setRoundBorder:self.ibPromoCodeText color:[UIColor colorWithRed:254/255.0f green:106/255.0f blue:106/255.0f alpha:1] borderRadius:self.ibPromoCodeText.frame.size.height/2];
        self.ibPromoCodeText.backgroundColor = [UIColor whiteColor];
        self.ibPromoCodeText.textColor = [UIColor colorWithRed:254/255.0f green:106/255.0f blue:106/255.0f alpha:1];
        [MessageManager showMessageInPopOut:LocalisedString(@"system") subtitle:LocalisedString(@"The promo code entered is invalid. Please check and try again.")];
//        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"The promo code entered is invalid. Please check and try again.") Type:TSMessageNotificationTypeError];
        self.hasRedeemed = NO;
        [LoadingManager hide];
        self.isLoading = NO;
    }];
}

@end
