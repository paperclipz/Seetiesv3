//
//  DealRedeemViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/29/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealRedeemViewController.h"
#import "DealExpiryDateModel.h"
#import "HowToRedeemViewController.h";

@interface DealRedeemViewController ()
{
    
    float oldX, oldY;
    BOOL dragging;
    CGRect oldFrame;
    float activationDistance;
    BOOL activateDropEffect;
    CGRect oldBottomViewFrame;


}

@property (weak, nonatomic) IBOutlet UIImageView *ibImgDeal;
@property (weak, nonatomic) IBOutlet UIView *ibDescBorderView;
@property (weak, nonatomic) IBOutlet UIView *ibSwipeView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIView *ibBottomView;
@property (weak, nonatomic) IBOutlet UILabel *ibRedeemDateTime;
@property (weak, nonatomic) IBOutlet UIImageView *ibShopImg;
@property (weak, nonatomic) IBOutlet UILabel *ibShopTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibShopAddress;
@property (weak, nonatomic) IBOutlet UILabel *ibDealTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibSwipeBtn;
@property (weak, nonatomic) IBOutlet UIView *ibSwipeBg;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibBottomDesc;
@property (weak, nonatomic) IBOutlet UILabel *ibSwipeToRedeem;
@property (weak, nonatomic) IBOutlet UIButton *ibHowToRedeem;
@property (weak, nonatomic) IBOutlet UIImageView *ibGuideIndicatorImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibTopConstraint;

@property(nonatomic) HowToRedeemViewController *howToRedeemViewController;

@property(nonatomic) DealModel *dealModel;
@property(nonatomic) NSString *referralID;
@property(nonatomic) DealManager *dealManager;
@property(nonatomic) BOOL isRedeeming;
@property(nonatomic) BOOL hasRedeemed;
@property(nonatomic) NSUserDefaults *userDefault;
@property(nonatomic) NSTimer *timer;
@end

@implementation DealRedeemViewController

- (IBAction)btnIntroClicked:(id)sender {
    self.howToRedeemViewController = nil;
//    UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:self.howToRedeemViewController];
    [self presentViewController:self.howToRedeemViewController animated:YES completion:nil];
}

- (IBAction)btnDirectionClicked:(id)sender {
    
    [[MapManager Instance]showMapOptions:self.view LocationLat:self.dealModel.voucher_info.shop_info.location.lat LocationLong:self.dealModel.voucher_info.shop_info.location.lng];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self changeLanguage];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5
                                                  target:self
                                                selector:@selector(animateSwipe)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self stopSwipeAnimation];
}

-(void)animateSwipe
{
    
    self.ibGuideIndicatorImg.hidden = NO;

    [UIView animateWithDuration:1.5 animations:^{
        
        [self.ibGuideIndicatorImg setX:self.ibSwipeBg.frame.size.width - 20];
    } completion:^(BOOL finished) {
        
        
        [self.ibGuideIndicatorImg setX:30];

        
        [UIView animateWithDuration:1.5 animations:^{
            
            [self.ibGuideIndicatorImg setX:self.ibSwipeBg.frame.size.width - 20];

            
        } completion:^(BOOL finished) {
            
            [self.ibGuideIndicatorImg setX:30];

        }];
        
        

    }];
}

-(void)stopSwipeAnimation{
    [self.timer invalidate];
    self.ibGuideIndicatorImg.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    oldBottomViewFrame = self.ibBottomView.frame;
    CGRect screenSize = [Utils getDeviceScreenSize];
    if (screenSize.size.height > 480) {
        self.ibTopConstraint.constant = 55;
    }
    else{
        self.ibTopConstraint.constant = 10;
    }
    [self.view refreshConstraint];
    
    activationDistance = 200;
    [Utils setRoundBorder:self.ibDescBorderView color:[UIColor whiteColor] borderRadius:5.0f borderWidth:1.0f];
    self.ibDescBorderView.alpha = 0;
    self.isRedeeming = NO;
    self.hasRedeemed = NO;
    
    [self initSelfView];
    
    BOOL shownRedeemTutorial = [self.userDefault boolForKey:@"ShownRedeemTutorial"];
    if (!shownRedeemTutorial) {
        [self btnIntroClicked:self.ibHowToRedeem];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWithDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
    _referralID = nil;
}

-(void)initWithDealModel:(DealModel *)dealModel referralID:(NSString *)referralId{
    _dealModel = dealModel;
    _referralID = referralId;
}

-(void)initSelfView{
    [self.ibSwipeBg setSideCurveBorder];
    [self.ibSwipeBtn setSideCurveBorder];
    
    if (self.dealModel) {
        SeShopDetailModel *shopModel = self.dealModel.voucher_info.shop_info;
        self.ibShopTitle.text = shopModel.name;
        self.ibShopAddress.text = shopModel.location.formatted_address;
        
       
        @try {
            NSString* imageURL = shopModel.profile_photo[@"picture"];
            [self.ibShopImg sd_setImageCroppedWithURL:[NSURL URLWithString:imageURL] withPlaceHolder:[Utils getShopPlaceHolderImage] completed:nil];
            [Utils  setRoundBorder:self.ibShopImg color:OUTLINE_COLOR borderRadius:5.0f];

            PhotoModel *photo = self.dealModel.photos[0];
            if (![Utils isStringNull:photo.imageURL]) {
                [self.ibImgDeal sd_setImageCroppedWithURL:[NSURL URLWithString:photo.imageURL] completed:nil];
            }
            else{
                [self.ibImgDeal setImage:[UIImage imageNamed:@"SsDefaultDisplayPhoto.png"]];
            }
            self.ibDealTitle.text = self.dealModel.title;
        }
        @catch (NSException *exception) {
            SLog(@"assign profile_photo fail");
        }
       
    }
}

-(void)changeLanguage{
    self.ibHeaderTitle.text = LocalisedString(@"Redeem Voucher");
    self.ibSwipeToRedeem.text = LocalisedString(@"Swipe to redeem");
    NSString *formattedStr = LocalisedString(@"Voucher redemptions must be made in front of shop staff");
    self.ibBottomDesc.text = [NSString stringWithFormat:@"%@", formattedStr];
    [self.ibHowToRedeem setTitle:LocalisedString(@"How to Redeem") forState:UIControlStateNormal];
    
}

/*
 #pragma mark - Navigation
 
  In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  Get the new view controller using [segue destinationViewController].
  Pass the selected object to the new view controller.
 }
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[UIView class]]) {
        
        if (touch.view == self.ibSwipeView) {
            [self stopSwipeAnimation];
            
            dragging = YES;
            activateDropEffect = NO;
            oldX = touchLocation.x;
            oldY = touchLocation.y;
            
            UIView *label = touch.view;
            
            oldFrame = label.frame;

        }
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    UIView *label = touch.view;
    dragging = NO;
  
    if(touch.view == self.ibSwipeView){
        if (activateDropEffect) {
            
            if ([self isNeedShowFirstTime]) {
                [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Flash and swipe! Do you want to redeem your voucher now?") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"Maybe not.") otherButtonTitles:@[LocalisedString(@"Yeah!")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self requestServerToRedeemVoucher];
//                        [self dropBottomView];
                    }
                    else if (buttonIndex == 0){
                        [UIView animateWithDuration:0.5 animations:^{
                            label.frame = oldFrame;
                        }];
                    }
                }];

            }
            else
            {
                [self requestServerToRedeemVoucher];
//                [self dropBottomView];

            }
            
        }
        else{
            [UIView animateWithDuration:0.5 animations:^{
                label.frame = oldFrame;
            }];
        }
    }
}

-(BOOL)isNeedShowFirstTime
{
    BOOL isSeemWarningBefore = [[[NSUserDefaults standardUserDefaults]objectForKey:FIRST_TIME_SHOW_DEAL_WARNING]boolValue];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_TIME_SHOW_DEAL_WARNING];
     
     [[NSUserDefaults standardUserDefaults]synchronize];
     
    return !isSeemWarningBefore;
}

-(void)dropBottomView{
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.ibBottomView]];
    gravityBehaviour.gravityDirection = CGVectorMake(0, 5);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ibBottomView]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self.ibBottomView];
    [self.animator addBehavior:itemBehaviour];
    
    [UIView animateWithDuration:1.0f animations:^{
        
        self.ibDescBorderView.alpha = 1;
        
    } completion:^(BOOL finished) {
        self.ibBottomView.hidden = YES;
        [self.animator removeAllBehaviors];
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"dd MMM yyyy"];
    NSString *date = [formatter stringFromDate:[[NSDate alloc] init]];
    [formatter setDateFormat:@"hh:mmaa"];
    NSString *time = [formatter stringFromDate:[[NSDate alloc] init]];
    
    NSString *displayString = [LanguageManager stringForKey:@"Redeemed on {!date}, {!time}" withPlaceHolder:@{@"{!date}":date, @"{!time}":time}];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:displayString];
    NSRange dateRange = [displayString rangeOfString:date];
    NSRange timeRange = [displayString rangeOfString:time];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0f] range:dateRange];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0f] range:timeRange];
    [attrString endEditing];
    
    self.ibRedeemDateTime.attributedText = attrString;
}

-(void)resetBottomView
{
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.ibDescBorderView.alpha = 0;
        self.ibBottomView.hidden = NO;
        self.ibBottomView.frame = oldBottomViewFrame;
        self.ibBottomView.transform = CGAffineTransformIdentity;
        [self.ibBottomView refreshConstraint];

    }];
   
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[UIView class]]) {
        UIView *label = touch.view;
        if (touch.view == self.ibSwipeView) {
            
            if (dragging) {
                CGRect frame = label.frame;
                
                if (frame.origin.x <= self.ibSwipeBg.frame.size.width - frame.size.width -10) {
                    frame.origin.x = label.frame.origin.x + touchLocation.x - oldX;
                }
                
                if (frame.origin.x <oldFrame.origin.x) {
                    frame = oldFrame;
                }
                
                frame.origin.y = label.frame.origin.y;
                
                label.frame = frame;
                
                if (label.frame.origin.x - oldFrame.origin.x > (self.ibSwipeBg.frame.size.width - label.frame.size.width - 20)) {
                  //  SLog(@"activated");
                    activateDropEffect = YES;
                }
            }
        }
        
    }
}

#pragma mark - Declaration
-(DealManager *)dealManager{
    if (!_dealManager) {
        _dealManager = [DealManager Instance];
    }
    return _dealManager;
}

-(NSUserDefaults *)userDefault{
    
    if (!_userDefault) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefault;
}

-(HowToRedeemViewController *)howToRedeemViewController{
    if (!_howToRedeemViewController) {
        _howToRedeemViewController = [HowToRedeemViewController new];
    }
    return _howToRedeemViewController;
}

#pragma mark - RequestServer
-(void)requestServerToRedeemVoucher{
    
    if (![ConnectionManager isNetworkAvailable]) {
        [[OfflineManager Instance]addDealToRedeem:self.dealModel];
        
        [self dropBottomView];

        if ([self.dealRedeemDelegate respondsToSelector:@selector(onDealRedeemed:)]) {
            
            [self.dealRedeemDelegate onDealRedeemed:self.dealModel];
        }
        //get the value only
                
        return;
    }
    
    if (self.isRedeeming) {
        return;
    
    }
    
    
    
    self.isRedeeming = YES;
    
    NSDictionary *dict = @{
                           @"token": [Utils getAppToken]
                           };
    
    CLLocation *userLocation = [[SearchManager Instance] getAppLocation];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDictionary *voucherDict = @{@"deal_id": self.dealModel.dID? self.dealModel.dID : @"",
                                  @"voucher_id": self.dealModel.voucher_info.voucher_id? self.dealModel.voucher_info.voucher_id : @"",
                                  @"datetime": [formatter stringFromDate:[[NSDate alloc] init]],
                                  @"lat": @(userLocation.coordinate.latitude),
                                  @"lng": @(userLocation.coordinate.longitude)
                                  };
    
    
    NSArray *voucherArray = @[voucherDict];
    NSMutableDictionary* finalDict = [[NSMutableDictionary alloc]initWithDictionary:dict];

    
    for (int i = 0; i<voucherArray.count; i++) {
        
        NSDictionary* tempDict = voucherArray[i];
        
        NSDictionary* appendDict = @{[NSString stringWithFormat:@"voucher_info[%d]",i] : tempDict};
        
        [finalDict addEntriesFromDictionary:appendDict];

    }
    
    if (self.referralID) {
        [finalDict setObject:self.referralID forKey:@"referral_u_id"];
    }
    
    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_PUT serverRequestType:ServerRequestTypePutRedeemVoucher parameter:finalDict appendString:nil success:^(id object) {

        NSArray *voucherArray = object[@"data"];
        BOOL hasError = NO;
        for (NSDictionary *voucherDict in voucherArray) {
            BOOL isSuccess = [voucherDict[@"success"] boolValue];
            
            if (!isSuccess) {
                hasError = YES;
                NSString *errorMsg = voucherDict[@"error_message"]? voucherDict[@"error_message"] : @"";
                
                [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(errorMsg) cancelButtonTitle:LocalisedString(@"Okay") otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                break;
            }
        }
        
        if (!hasError) {
            if (self.dealRedeemDelegate && [self.dealRedeemDelegate respondsToSelector:@selector(onDealRedeemed:)]) {
                [self.dealRedeemDelegate onDealRedeemed:self.dealModel];
            }
            
            [self dropBottomView];
        }
        
        self.isRedeeming = NO;
        [LoadingManager hide];
        
    } failure:^(id object) {
        self.isRedeeming = NO;
        [LoadingManager hide];
    }];
}

@end
