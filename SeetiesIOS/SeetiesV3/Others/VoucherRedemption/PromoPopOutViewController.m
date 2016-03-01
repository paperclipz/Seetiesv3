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

@property (strong, nonatomic) IBOutlet UIView *ibEnterPhoneView;
@property (weak, nonatomic) IBOutlet UIView *ibEnterPhoneContentView;

@property (strong, nonatomic) IBOutlet UIView *ibEnterVerificationView;
@property (weak, nonatomic) IBOutlet UIView *ibEnterVerificationContentView;

@property (strong, nonatomic) IBOutlet UIView *ibVerifiedView;
@property (weak, nonatomic) IBOutlet UIView *ibVerifiedContentView;

@property (strong, nonatomic) IBOutlet UIView *ibErrorView;
@property (weak, nonatomic) IBOutlet UIView *ibErrorContentView;

@property(nonatomic,assign)PopOutViewType viewType;
@property(nonatomic,assign)PopOutCondition popOutCondition;
@property(nonatomic) NSArray *shopArray;
@property(nonatomic) DealModel *dealModel;
@end

@implementation PromoPopOutViewController

-(instancetype)init{
    self = [super init];
    
    if (self) {
        _viewType = EnterPromoViewType;
        self.contentSizeInPopup = CGSizeMake(300, 400);
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];

    [self setMainViewToDisplay];
   
    // Do any additional setup after loading the view from its nib.
//    self.contentSizeInPopup = [self getMainView].frame.size;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView{
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

-(void)setShopArray:(NSArray *)shopArray{
    _shopArray = shopArray;
}

-(void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
}

-(void)setMainViewToDisplay{
    [self setView:[self getMainView]];
    [self.view setNeedsLayout];
}

-(UIView*)getMainView{
    switch (self.viewType) {
        case EnterPromoViewType:
            [self.ibEnterPromoContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibEnterPromoView;
            
        case ChooseShopViewType:
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
            
        case RedemptionSuccessfulViewType:
            [self.ibRedemptionSuccessfulContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibRedemptionSuccessfulView;
            
        case EnterPhoneViewType:
            [self.ibEnterPhoneContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibEnterPhoneView;
            
        case EnterVerificationViewType:
            [self.ibEnterVerificationContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibEnterVerificationView;
            
        case VerifiedViewType:
            [self.ibVerifiedContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibVerifiedView;
            
        case ErrorViewType:
            [self.ibErrorContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibErrorView;
            
        default:
            [self.ibEnterPromoContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
            return self.ibEnterPromoView;
    }
}

- (IBAction)buttonSubmitClicked:(id)sender {
  
    PopOutViewType nextView;
 
    switch (self.viewType) {
        case EnterPromoViewType:
        {
            if (YES) {
                nextView = ChooseShopViewType;
            }
        }
            break;
            
        case RedemptionSuccessfulViewType:
        {
            if (YES) {
                nextView = QuitViewType;
            }
        }
            break;
        case ChooseShopViewType:
        {
            if (self.popOutCondition == ChooseShopOnlyPopOutCondition) {
                if (self.promoPopOutDelegate) {
                    NSIndexPath *selectedIndexPath = [self.ibShopTable indexPathForSelectedRow];
                    if (selectedIndexPath) {
                        SeShopDetailModel *shopModel = [self.shopArray objectAtIndex:selectedIndexPath.row];
                        [self.promoPopOutDelegate chooseShopConfirmClicked:self.dealModel forShop:shopModel];
                        nextView = QuitViewType;
                    }
                }
            }
            else{
                nextView = EnterPhoneViewType;
            }
        }
            break;

        case EnterPhoneViewType:
        {
            if (YES) {
                nextView = EnterVerificationViewType;
            }
        }
            break;
            
        case EnterVerificationViewType:
        {
            if (YES) {
                nextView = VerifiedViewType;
            }
        }
            break;
            
        case VerifiedViewType:
        {
            if (YES) {
                nextView = RedemptionSuccessfulViewType;
            }
        }
            break;
            
        case ErrorViewType:
        {
            if (YES) {
                nextView = QuitViewType;
            }
        }
            break;
            
        case QuitViewType:
        {
            if (YES) {
                nextView = QuitViewType;
            }
        }
            break;

        default:
            nextView = EnterPromoViewType;

            break;
    }
    
    if (nextView == QuitViewType) {
        [self.popupController dismiss];
    }
    else{
        PromoPopOutViewController* nextVC = [PromoPopOutViewController new];
        [nextVC setViewType:nextView];
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


@end
