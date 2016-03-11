//
//  PromoCodeViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 26/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PromoPopOutViewController.h"

@interface PromoPopOutViewController ()
@property (strong, nonatomic) IBOutlet UIView *ibEnterPromoView;
@property (weak, nonatomic) IBOutlet UITextField *ibPromoCodeText;
@property (weak, nonatomic) IBOutlet UILabel *ibTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *ibEnterPromoContentView;

@property (strong, nonatomic) IBOutlet UIView *ibRedemptionSuccessfulView;
@property (weak, nonatomic) IBOutlet UIView *ibRedemptionSuccessfulContentView;

@property (strong, nonatomic) IBOutlet UIView *ibChooseShopView;
@property (weak, nonatomic) IBOutlet UIView *ibChooseShopContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibShopTable;
@property (weak, nonatomic) IBOutlet UILabel *ibShopDealLbl;

@property (strong, nonatomic) IBOutlet UIView *ibChangeVerifiedPhoneView;
@property (weak, nonatomic) IBOutlet UIView *ibChangeVerifiedPhoneContentView;
@property (weak, nonatomic) IBOutlet UIButton *ibChangeVerifiedPhoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibChangeVerifiedPhoneNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibChangeVerifiedPhoneDescLbl;

@property (strong, nonatomic) IBOutlet UIView *ibEnterPhoneView;
@property (weak, nonatomic) IBOutlet UIView *ibEnterPhoneContentView;
@property (weak, nonatomic) IBOutlet UIButton *ibEnterPhoneConfirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibEnterPhoneNote;
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

@property(nonatomic,assign)PopOutViewType viewType;
@property(nonatomic,assign)PopOutCondition popOutCondition;
@property(nonatomic) NSArray *shopArray;
@property(nonatomic) NSArray<CountryModel> *countryArray;
@property(nonatomic) NSMutableArray *countryCodeArray;
@property(nonatomic) NSString *selectedCountryCode;
@property(nonatomic) NSString *enteredPhoneNumber;
@property(nonatomic) DealModel *dealModel;
@property(nonatomic) BOOL isLoading;
@property(nonatomic) BOOL isVerified;
@property(nonatomic) BOOL hasRequestedTotp;

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
    self.isLoading = NO;
    self.isVerified = NO;
    self.hasRequestedTotp = NO;
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
    
}

-(void)setPopOutCondition:(PopOutCondition)popOutCondition{
    _popOutCondition = popOutCondition;
}

-(void)setShopArray:(NSArray *)array{
    _shopArray = array;
}

-(void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
}

-(void)setSelectedCountryCode:(NSString *)selectedCountryCode{
    _selectedCountryCode = selectedCountryCode;
}

-(void)setEnteredPhoneNumber:(NSString *)enteredPhoneNumber{
    _enteredPhoneNumber = enteredPhoneNumber;
}

-(void)setMainViewToDisplay{
    [self setView:[self getMainView]];
    [self.view setNeedsLayout];
}

-(UIView*)getMainView{
    switch (self.viewType) {
        case PopOutViewTypeEnterPromo:
            [self.ibEnterPromoContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibEnterPromoView;
            
        case PopOutViewTypeChooseShop:
            [self.ibShopTable registerClass:[PromoOutletCell class] forCellReuseIdentifier:@"PromoOutletCell"];
//            self.ibShopTable.estimatedRowHeight = [PromoOutletCell getHeight];
//            self.ibShopTable.rowHeight = UITableViewAutomaticDimension;
            
            int counter = 4;
            float headerAndFooterHeight = 140;
            float tableHeight = self.shopArray.count>counter? [PromoOutletCell getHeight]*counter : [PromoOutletCell getHeight]*self.shopArray.count;
            
            self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, tableHeight+headerAndFooterHeight);
            [self.ibChooseShopContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            
            if ([Utils isStringNull:self.dealModel.cover_title]) {
                self.ibShopDealLbl.text = self.dealModel.title;
            }
            else{
                self.ibShopDealLbl.text = self.dealModel.cover_title;
            }
            return self.ibChooseShopView;
            
        case PopOutViewTypeRedemptionSuccessful:
            [self.ibRedemptionSuccessfulContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibRedemptionSuccessfulView;
            
        case PopOutViewTypeChangeVerifiedPhone:
            [self.ibChangeVerifiedPhoneContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibChangeVerifiedPhoneView;
            
        case PopOutViewTypeEnterPhone:
            self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, 470);
            [self.ibEnterPhoneContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            [Utils setRoundBorder:self.ibEnterPhoneTxtField color:[UIColor clearColor] borderRadius:self.ibEnterPhoneTxtField.frame.size.height/2];
            [Utils setRoundBorder:self.ibEnterPhoneCountryCodeView color:DEVICE_COLOR borderRadius:self.ibEnterPhoneCountryCodeView.frame.size.height/2];
            [self requestServerToGetHomeCountry];
            return self.ibEnterPhoneView;
            
        case PopOutViewTypeConfirmPhone:
            [self.ibConfirmPhoneContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            [Utils setRoundBorder:self.ibConfirmPhoneChangeBtn color:DEVICE_COLOR borderRadius:self.ibConfirmPhoneChangeBtn.frame.size.height/2];
            if (![Utils isStringNull:self.selectedCountryCode] && ![Utils isStringNull:self.enteredPhoneNumber]) {
                self.ibConfirmPhoneNumberLbl.text = [NSString stringWithFormat:@"+%@%@", self.selectedCountryCode, self.enteredPhoneNumber];
            }
            return self.ibConfirmPhoneView;
            
        case PopOutViewTypeEnterVerification:
            [self.ibEnterVerificationContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            [Utils setRoundBorder:self.ibEnterVerificationTxtField color:[UIColor clearColor] borderRadius:self.ibEnterVerificationTxtField.frame.size.height/2];
            [Utils setRoundBorder:self.ibEnterVerificationResendBtn color:DEVICE_COLOR borderRadius:self.ibEnterVerificationResendBtn.frame.size.height/2];
            if (![Utils isStringNull:self.selectedCountryCode] && ![Utils isStringNull:self.enteredPhoneNumber]) {
                NSString *phoneNumber = [NSString stringWithFormat:@"+%@%@", self.selectedCountryCode, self.enteredPhoneNumber];
                self.ibEnterVerificationDesc.text = [NSString stringWithFormat:@"%@ %@", @"Enter the 6 digits that we have send to", phoneNumber];
            }
            return self.ibEnterVerificationView;
            
        case PopOutViewTypeVerified:
            [self.ibVerifiedContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibVerifiedView;
            
        case PopOutViewTypeError:
            [self.ibErrorContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibErrorView;
            
        default:
            [self.ibEnterPromoContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibEnterPromoView;
    }
}

-(void)formatCountryCodeArray{
    if (![Utils isArrayNull:self.countryArray]) {
        for (CountryModel *country in self.countryArray) {
            NSString *formattedCountryCode = [NSString stringWithFormat:@"%@ (%@)", country.name, country.phone_country_code];
            [self.countryCodeArray addObject:formattedCountryCode];
        }
    }
}

#pragma mark - Declaration
-(NSArray<CountryModel> *)countryArray{
    if (!_countryArray) {
        _countryArray = [[NSArray<CountryModel> alloc] init];
    }
    return _countryArray;
}

-(NSMutableArray *)countryCodeArray{
    if (!_countryCodeArray) {
        _countryCodeArray = [[NSMutableArray alloc] init];
    }
    return _countryCodeArray;
}

#pragma mark - IBAction

- (IBAction)selectCountryCodeBtnClicked:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:LocalisedString(@"Select country code")
                                            rows:self.countryCodeArray
                                initialSelection:0
                                doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                    
                                    CountryModel *country = self.countryArray[selectedIndex];
                                    self.selectedCountryCode = [country.phone_country_code substringFromIndex:1];
                                    self.ibEnterPhoneCountryCodeLbl.text = self.countryCodeArray[selectedIndex];
                                    
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}

- (IBAction)resendCodeBtnClicked:(id)sender {
    self.isVerified = NO;
    [self requestServerToGetTotp];
}

- (IBAction)changePhoneNumberBtnClicked:(id)sender {
    [self.popupController popViewControllerAnimated:YES];
}

- (IBAction)buttonSubmitClicked:(id)sender {
  
    PromoPopOutViewController* nextVC = [PromoPopOutViewController new];
 
    switch (self.viewType) {
        case PopOutViewTypeEnterPromo:
        {
            if (YES) {
                [nextVC setViewType:PopOutViewTypeChooseShop];
            }
        }
            break;
            
        case PopOutViewTypeRedemptionSuccessful:
        {
            if (YES) {
                [nextVC setViewType:PopOutViewTypeQuit];
            }
        }
            break;
        case PopOutViewTypeChooseShop:
        {
            if (self.popOutCondition == PopOutConditionChooseShopOnly) {
                if (self.promoPopOutDelegate) {
                    NSIndexPath *selectedIndexPath = [self.ibShopTable indexPathForSelectedRow];
                    if (selectedIndexPath) {
                        SeShopDetailModel *shopModel = [self.shopArray objectAtIndex:selectedIndexPath.row];
                        [self.promoPopOutDelegate chooseShopConfirmClicked:self.dealModel forShop:shopModel];
                        [nextVC setViewType:PopOutViewTypeQuit];
                    }
                }
            }
            else{
                [nextVC setViewType:PopOutViewTypeEnterPhone];
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
        }
            break;
            
        case PopOutViewTypeConfirmPhone:
        {
            if (self.hasRequestedTotp) {
                [nextVC setViewType:PopOutViewTypeEnterVerification];
                [nextVC setSelectedCountryCode:self.selectedCountryCode];
                [nextVC setEnteredPhoneNumber:self.ibEnterPhoneTxtField.text];
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
            
        case PopOutViewTypeQuit:
        {
            if (YES) {
                [nextVC setViewType:PopOutViewTypeQuit];
            }
        }
            break;

        default:
            [nextVC setViewType:PopOutViewTypeEnterPromo];

            break;
    }
    
    if (nextVC.viewType == PopOutViewTypeQuit) {
        [self.popupController dismiss];
    }
    else{
//        self.popupController.containerView.backgroundColor = [UIColor clearColor];
        [self.popupController pushViewController:nextVC animated:YES];

    }
    
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.shopArray) {
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
        self.ibEnterVerificationTxtField.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    }
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
    
    [[ConnectionManager Instance] requestServerWithPost:ServerRequestTypePostTOTP param:dict completeHandler:^(id object) {
        self.hasRequestedTotp = YES;
        if (self.viewType == PopOutViewTypeConfirmPhone) {
            [self buttonSubmitClicked:self.ibEnterPhoneConfirmBtn];
        }
        
        [LoadingManager hide];
        self.isLoading = NO;
    } errorBlock:^(id object) {
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
    
    [[ConnectionManager Instance] requestServerWithPost:ServerRequestTypePostVerifyTOTP param:dict completeHandler:^(id object) {
        self.isVerified = YES;
        [self buttonSubmitClicked:self.ibConfirmPhoneBtn];
        self.isLoading = NO;
        [LoadingManager hide];
    } errorBlock:^(id object) {
        [Utils setRoundBorder:self.ibEnterVerificationTxtField color:[UIColor colorWithRed:254/255.0f green:106/255.0f blue:106/255.0f alpha:1] borderRadius:self.ibEnterVerificationTxtField.frame.size.height/2];
        self.ibEnterVerificationTxtField.textColor = [UIColor colorWithRed:254/255.0f green:106/255.0f blue:106/255.0f alpha:1];
        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Invalid verification code, make sure the code you enter is right") Type:TSMessageNotificationTypeError];
        self.isVerified = NO;
        self.isLoading = NO;
        [LoadingManager hide];
    }];
}

-(void)requestServerToGetHomeCountry{
    ProfileModel *profile = [[DataManager Instance] userProfileModel];
    NSString *langCode = profile.system_language.language_code;
    NSDictionary *dict = @{@"language_code": langCode
                           };
    [LoadingManager show];
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetHomeCountry param:dict appendString:nil completeHandler:^(id object) {
        CountriesModel *countriesModel = [[ConnectionManager dataManager] countriesModel];
        self.countryArray = countriesModel.countries;
        [self.countryCodeArray removeAllObjects];
        [self formatCountryCodeArray];
        [LoadingManager hide];
    } errorBlock:^(id object) {
        [LoadingManager hide];
    }];
}

@end
