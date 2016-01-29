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

@property (strong, nonatomic) IBOutlet UIView *ibEnterPhoneView;
@property (weak, nonatomic) IBOutlet UIView *ibEnterPhoneContentView;

@property (strong, nonatomic) IBOutlet UIView *ibEnterVerificationView;
@property (weak, nonatomic) IBOutlet UIView *ibEnterVerificationContentView;

@property (strong, nonatomic) IBOutlet UIView *ibVerifiedView;
@property (weak, nonatomic) IBOutlet UIView *ibVerifiedContentView;

@property(nonatomic,assign)PopOutViewType viewType;
@property(nonatomic) NSMutableArray *dummyOutlet;
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
    self.dummyOutlet = [[NSMutableArray alloc] init];
    for (int i=0; i<8; i++) {
        NSDictionary *outletDict = @{@"imageName" : @"Icon-60.png",
                                     @"outletName" : [NSString stringWithFormat:@"Seeties shop %d", i],
                                     @"outletAddress" : @"123, Jalan 123, Solaris Duutamas, Subang Jaya, Selangor",
                                     @"isChecked" : @NO};
        [self.dummyOutlet addObject:outletDict];
    }
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
            self.ibShopTable.estimatedRowHeight = [PromoOutletCell getHeight];
            self.ibShopTable.rowHeight = UITableViewAutomaticDimension;
            
            int counter = 4;
            float headerAndFooterHeight = 140;
            float tableHeight = self.dummyOutlet.count>counter? [PromoOutletCell getHeight]*counter : [PromoOutletCell getHeight]*self.dummyOutlet.count;
            
            self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, tableHeight+headerAndFooterHeight);
            [self.ibChooseShopContentView setRoundedCorners:UIRectCornerAllCorners radius:8.0f];
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
            if (YES) {
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dummyOutlet.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PromoOutletCell *outletCell = [tableView dequeueReusableCellWithIdentifier:@"PromoOutletCell"];
    
    NSDictionary *tempOutlet = [self.dummyOutlet objectAtIndex:indexPath.row];
    [outletCell setOutletTitle:[tempOutlet objectForKey:@"outletName"]];
    [outletCell setOutletImage:[UIImage imageNamed:[tempOutlet objectForKey:@"imageName"]]];
    [outletCell setOutletAddress:[tempOutlet objectForKey:@"outletAddress"]];
    [outletCell setOutletIsChecked:[[tempOutlet objectForKey:@"isChecked"] boolValue]];
    
    return outletCell;
}


@end
