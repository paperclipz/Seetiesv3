//
//  DealRedeemViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/29/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealRedeemViewController.h"
#import "YLImageView.h"
#import "YLGIFImage.h"

@interface DealRedeemViewController ()
{
    
    float oldX, oldY;
    BOOL dragging;
    CGRect oldFrame;
    float activationDistance;
    BOOL activateDropEffect;

}
@property (strong, nonatomic) IBOutlet UIView *ibGifContentView;
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

@property(nonatomic) DealModel *dealModel;
@property(nonatomic) DealManager *dealManager;
@property(nonatomic) BOOL isRedeeming;
@property(nonatomic) BOOL hasRedeemed;
@property(nonatomic) NSUserDefaults *userDefault;
@end

@implementation DealRedeemViewController
- (IBAction)btnIntroClicked:(id)sender {
    
    CGRect frame = [Utils getDeviceScreenSize];
    [self.view addSubview:self.ibGifContentView];
    self.ibGifContentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (IBAction)btnHowToRedeemCloseClicked:(id)sender {
    [self.ibGifContentView removeFromSuperview];
    [self.userDefault setBool:YES forKey:@"ShownRedeemTutorial"];
}

- (IBAction)btnDirectionClicked:(id)sender {
    [[MapManager Instance]showMapOptions:self.view LocationLat:self.dealModel.voucher_info.shop_info.location.lat LocationLong:self.dealModel.voucher_info.shop_info.location.lng];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self changeLanguage];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
}

-(void)initSelfView{
    [self.ibSwipeBg setSideCurveBorder];
    [self.ibSwipeBtn setSideCurveBorder];
    
    [self.ibFirstNumber setRoundedBorder];
    [self.ibSecondNumber setRoundedBorder];
    [self.ibThirdNumber setRoundedBorder];
    
    self.ibFirstImage.image = [YLGIFImage imageNamed:@"HowToRedeem1.gif"];
    self.ibSecondImage.image = [YLGIFImage imageNamed:@"HowToRedeem2.gif"];
    self.ibThirdImage.image = [YLGIFImage imageNamed:@"HowToRedeem3.gif"];
    
    if (self.dealModel) {
        SeShopDetailModel *shopModel = self.dealModel.voucher_info.shop_info;
        self.ibShopTitle.text = shopModel.name;
        self.ibShopAddress.text = shopModel.location.formatted_address;
        
       
        @try {
            NSString* imageURL = shopModel.profile_photo[@"picture"];
            [self.ibShopImg sd_setImageCroppedWithURL:[NSURL URLWithString:imageURL] completed:nil];
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
    self.ibSwipeToRedeem.text = LocalisedString(@"Swipe to Redeem");
    NSString *formattedStr = LocalisedString(@"You must redeem in front of \n a shop personnel.");
    self.ibBottomDesc.text = [NSString stringWithFormat:@"%@", formattedStr];
    [self.ibHowToRedeem setTitle:LocalisedString(@"How to Redeem") forState:UIControlStateNormal];
    
    self.ibHowToRedeemTitle.text = LocalisedString(@"How to Redeem");
    self.ibFirstInstruction.text = LocalisedString(@"When you order");
    self.ibSecondInstruction.text = LocalisedString(@"Flash the redeem voucher screen");
    self.ibThirdInstruction.text = LocalisedString(@"Swipe right to redeem in front of a shop personnel");
    self.ibFooterInstruction.text = LocalisedString(@"Only one redemption per swipe");
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
                [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Are you sure you want to redeem this voucher") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"No") otherButtonTitles:@[LocalisedString(@"Yes")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self dropBottomView];
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
                [self dropBottomView];

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
    }];
    
    [self requestServerToRedeemVoucher];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy, hh:mmaa"];
    self.ibRedeemDateTime.text = [formatter stringFromDate:[[NSDate alloc] init]];
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

#pragma mark - RequestServer
-(void)requestServerToRedeemVoucher{
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
    
    NSDictionary *voucherDict = @{@"deal_id": self.dealModel.dID,
                                  @"voucher_id": self.dealModel.voucher_info.voucher_id,
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
    
    [[ConnectionManager Instance] requestServerWithPut:ServerRequestTypePutRedeemVoucher param:finalDict appendString:nil completeHandler:^(id object) {
        //Remove voucher from deal manager if it is not reusable
        if (self.dealModel.total_available_vouchers != -1) {
            [self.dealManager removeCollectedDeal:self.dealModel.dID];
        }
        if (self.dealRedeemDelegate) {
            [self.dealRedeemDelegate onDealRedeemed:self.dealModel];
        }
        
        self.isRedeeming = NO;
        
    } errorBlock:^(id object) {
        self.isRedeeming = NO;
    }];
}

@end
