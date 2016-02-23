//
//  DealRedeemViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/29/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealRedeemViewController.h"

@interface DealRedeemViewController ()
{
    
    float oldX, oldY;
    BOOL dragging;
    CGRect oldFrame;
    float activationDistance;
    BOOL activateDropEffect;

}
@property (weak, nonatomic) IBOutlet UIImageView *ibImgDeal;
@property (weak, nonatomic) IBOutlet UIView *ibDescBorderView;

@property (weak, nonatomic) IBOutlet UIView *ibSwipeView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIView *ibBottomView;
@property (weak, nonatomic) IBOutlet UILabel *ibRedeemDateTime;
@property (weak, nonatomic) IBOutlet UIView *ibTopView;
@property (weak, nonatomic) IBOutlet UIImageView *ibShopImg;
@property (weak, nonatomic) IBOutlet UILabel *ibShopTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibShopAddress;
@property (weak, nonatomic) IBOutlet UILabel *ibDealTitle;

@property(nonatomic) DealModel *dealModel;
@property(nonatomic) DealManager *dealManager;
@end

@implementation DealRedeemViewController

-(void)viewDidAppear:(BOOL)animated
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activationDistance = 200;
    [Utils setRoundBorder:self.ibDescBorderView color:[UIColor whiteColor] borderRadius:5.0f borderWidth:1.0f];
    self.ibDescBorderView.alpha = 0;
    
    [self initSelfView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
}

-(void)initSelfView{
    if (self.dealModel) {
        SeShopDetailModel *shopModel = self.dealModel.voucher_info.shop_info;
        self.ibShopTitle.text = shopModel.name;
        self.ibShopAddress.text = shopModel.location.formatted_address;
        [self.ibShopImg sd_setImageCroppedWithURL:[NSURL URLWithString:shopModel.profile_picture] completed:nil];
        
        PhotoModel *photo = self.dealModel.photos[0];
        [self.ibImgDeal sd_setImageCroppedWithURL:[NSURL URLWithString:photo.imageURL] completed:nil];
        self.ibDealTitle.text = self.dealModel.title;
    }
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
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (touch.view == self.ibSwipeView) {
            
            if (!activateDropEffect) {
                label.frame = oldFrame;
            }
        }
        
    }];
    
    dragging = NO;
    
    if (activateDropEffect) {
        UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.ibBottomView]];
          gravityBehaviour.gravityDirection = CGVectorMake(0, 5);
        [self.animator addBehavior:gravityBehaviour];
        
        UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ibBottomView]];
        [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self.ibBottomView];
        [self.animator addBehavior:itemBehaviour];
        
        [UIView animateWithDuration:1.0f animations:^{
           
            self.ibDescBorderView.alpha = 1;

        }];
    }
    
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
                
                if (frame.origin.x <= self.ibBottomView.frame.size.width - frame.size.width -10) {
                    frame.origin.x = label.frame.origin.x + touchLocation.x - oldX;
                }
                
                if (frame.origin.x <oldFrame.origin.x) {
                    frame = oldFrame;
                }
                
                frame.origin.y = label.frame.origin.y;
                
                label.frame = frame;
                
                if (label.frame.origin.x - oldFrame.origin.x > activationDistance) {
                    SLog(@"activated");
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

#pragma mark - RequestServer
-(void)requestServerToRedeemVoucher{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDictionary *dict = @{@"voucher_id": self.dealModel.voucher_info.voucher_id,
                           @"token": [Utils getAppToken],
                           @"datetime": [formatter stringFromDate:[[NSDate alloc] init]]
                           };
    NSString *appendString = [NSString stringWithFormat:@"%@/redeem", self.dealModel.voucher_info.voucher_id];
    
    [[ConnectionManager Instance] requestServerWithPut:ServerRequestTypePutRedeemVoucher param:dict appendString:appendString completeHandler:^(id object) {
        //Update previous page if it is not reusable
        if (self.dealModel.total_available_vouchers != -1) {
            [self.dealManager removeCollectedDeal:self.dealModel.dID];
            
            if (self.dealRedeemDelegate) {
                [self.dealRedeemDelegate onDealRedeemed:self.dealModel];
            }
        }
        
    } errorBlock:^(id object) {
        
    }];
}

@end
