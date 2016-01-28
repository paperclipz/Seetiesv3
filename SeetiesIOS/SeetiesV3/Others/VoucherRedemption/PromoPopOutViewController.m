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
@property (weak, nonatomic) IBOutlet UIView *ibContentView;
@property (strong, nonatomic) IBOutlet UIView *ibRedemptionSuccessfulView;

@property (strong, nonatomic) IBOutlet UIView *ibChooseShopView;
@property (weak, nonatomic) IBOutlet UITableView *ibShopTable;

@property (strong, nonatomic) IBOutlet UIView *ibEnterPhoneView;

@property (strong, nonatomic) IBOutlet UIView *ibEnterVerificationView;

@property (strong, nonatomic) IBOutlet UIView *ibVerifiedView;

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

//    [self adjustFrameSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView{
    self.dummyOutlet = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++) {
        NSDictionary *outletDict = @{@"imageName" : @"Icon-60.png",
                                     @"outletName" : [NSString stringWithFormat:@"Seeties shop %d", i],
                                     @"outletAddress" : @"123, Jalan 123, Solaris Duutamas, Subang Jaya, Selangor",
                                     @"isChecked" : @NO};
        [self.dummyOutlet addObject:outletDict];
    }
}

-(void)adjustFrameSize{
    if (self.viewType == ChooseShopViewType) {
        if (self.dummyOutlet.count==1) {
            self.contentSizeInPopup = CGSizeMake(300, 300);
        }
        
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

-(void)viewDidLayoutSubviews{
//    [self.ibContentView setRoundedBorder];
}

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
            return self.ibEnterPromoView;
            
        case ChooseShopViewType:
            [self.ibShopTable registerClass:[PromoOutletCell class] forCellReuseIdentifier:@"PromoOutletCell"];
            self.ibShopTable.estimatedRowHeight = [PromoOutletCell getHeight];
            self.ibShopTable.rowHeight = UITableViewAutomaticDimension;
            
            int counter =4;
            float getHeight = self.dummyOutlet.count>counter?[PromoOutletCell getHeight]*counter:[PromoOutletCell getHeight]*self.dummyOutlet.count;
            
            self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, getHeight+140);

            return self.ibChooseShopView;
            
        case RedemptionSuccessfulViewType:
            return self.ibRedemptionSuccessfulView;
            
        case EnterPhoneViewType:
            return self.ibEnterPhoneView;
            
        case EnterVerificationViewType:
            return self.ibEnterVerificationView;
            
        case VerifiedViewType:
            return self.ibVerifiedView;
            
        default:
            return self.ibEnterPromoView;
    }
}

- (IBAction)buttonSubmitClicked:(id)sender {
  
    PopOutViewType nextType;
 
    switch (self.viewType) {
        case EnterPromoViewType:
        {
            if (YES) {
                nextType = RedemptionSuccessfulViewType;
            }
        }
            break;
            
        case RedemptionSuccessfulViewType:
        {
            if (YES) {
                nextType = ChooseShopViewType;
            }
        }
            break;
        case ChooseShopViewType:
        {
            if (YES) {
                nextType = VerifiedViewType;
            }
        }
            break;

        case EnterPhoneViewType:
        {
            if (YES) {
                nextType = QuitViewType;
            }
        }
            break;
            
        case EnterVerificationViewType:
        {
            if (YES) {
                nextType = QuitViewType;
            }
        }
            break;
            
        case VerifiedViewType:
        {
            if (YES) {
                nextType = QuitViewType;
            }
        }
            break;
            
        case QuitViewType:
        {
            if (YES) {
                nextType = QuitViewType;
            }
        }
            break;

        default:
            nextType = EnterPromoViewType;

            break;
    }
    
    if (nextType == QuitViewType) {
        [self.popupController dismiss];
    }
    else{
        PromoPopOutViewController* nextVC = [PromoPopOutViewController new];
        [nextVC setViewType:nextType];
        [self.popupController pushViewController:nextVC animated:YES];

    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SLog(@"Number of rows: %d", self.dummyOutlet.count);
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
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == self.dummyOutlet.count-1) {
//        
//        CGSize frameSize = tableView.contentSize;
//        self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, frameSize.height+140);
//
//    }
//}
//


@end
