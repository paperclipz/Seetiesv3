//
//  ReportProblemViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/22/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ReportProblemViewController.h"

@interface ReportProblemViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
@property (weak, nonatomic) IBOutlet UITextView *ibTxtView;
@property (weak, nonatomic) IBOutlet UILabel *lblOneDesc;

@property (weak, nonatomic) IBOutlet UITextView *txtTwoDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblOneTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTwoTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibOthersLbl;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgOneTick;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgTwoTick;

@property (weak, nonatomic) IBOutlet UIImageView *ibImgThreeTick;
@property (assign, nonatomic) int type;
@property (assign, nonatomic) int reportType;//1 == shop 2 == deal 3 == post
@property (nonatomic) NSString*  dealID;
@property (nonatomic) SeShopDetailModel*  shopModel;
@property (nonatomic) NSString* postId;

@end

@implementation ReportProblemViewController

#pragma mark - IBACTION
- (IBAction)btnOneSelected:(id)sender {
    self.type = 1;
    [self changeViewType:self.type];
    [self.ibTxtView resignFirstResponder];
}
- (IBAction)btnTwoSelected:(id)sender {
    self.type = 2;
    [self changeViewType:self.type];
    [self.ibTxtView resignFirstResponder];

}

- (IBAction)btnDoneClicked:(id)sender {
    
    if (self.reportType == 1) {
        [self requestServerForFlagShop];
    }
    else if(self.reportType == 2)
    {
        [self requestServerForFlagDeal];
    }
    else if(self.reportType == 3)
    {
        [self requestServerForFlagPost];
    }
}

-(void)changeViewType:(int)type
{
    self.type = type;
    self.ibImgOneTick.hidden = YES;
    self.ibImgTwoTick.hidden = YES;
    self.ibImgThreeTick.hidden = YES;

    switch (type) {
        case 1:
            
            self.ibImgOneTick.hidden = NO;
            break;
            
        case 2:
            self.ibImgTwoTick.hidden = NO;

            break;
            
        case 3:
            self.ibImgThreeTick.hidden = NO;

            break;
            
        default:
            break;
    }
    
}

-(void)initDataReportShop:(SeShopDetailModel*)model
{
    self.reportType = 1;
    self.shopModel = model;
}

-(void)initDataReportDeal:(NSString*)dealID
{
    self.reportType = 2;
    self.dealID = dealID;

}

-(void)initDataReportPost:(NSString*)postID
{
    self.reportType = 3;
    self.postId = postID;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    
    [Utils setRoundBorder:self.ibTxtView color:LINE_COLOR borderRadius:5.0f borderWidth:1.0f];
    
    self.ibOthersLbl.text = LocalisedString(@"Others");
    self.ibTxtView.placeholder = LocalisedString(@"Please specify");
    
    [self changeViewType:1];
    switch (self.reportType) {
        //Report shop
        case 1:
            
            [Utils setRoundBorder:self.txtTwoDesc color:LINE_COLOR borderRadius:5.0f borderWidth:1.0f];

            self.ibHeaderTitle.text = LocalisedString(@"Report this");

            self.lblOneTitle.text = LocalisedString(@"Shop could not be found");
            self.lblOneDesc.text = LocalisedString(@"The shop could not be found in the area specified");

            self.lblTwoTitle.text = LocalisedString(@"Inaccurate information");
            self.txtTwoDesc.placeholder = LocalisedString(@"Shop information provided is inaccurate (eg.Business hours, address etc.)");

            break;
            
        //Report deal
        case 2:
            
            self.ibHeaderTitle.text = LocalisedString(@"Report this");
            self.lblOneTitle.text = LocalisedString(@"Deal is not available");
            self.lblOneDesc.text = LocalisedString(@"The deal is not available in the shop promoted.");
            
            self.lblTwoTitle.text = LocalisedString(@"Deal is different value");
            self.txtTwoDesc.text = LocalisedString(@"The deal does not reflect the promoted value");

            self.txtTwoDesc.editable = false;
            self.txtTwoDesc.userInteractionEnabled = NO;
            
            break;
            
        //Report post
        case 3:
            
            self.ibHeaderTitle.text = LocalisedString(@"Report this");
            self.lblOneTitle.text = LocalisedString(@"Inappropriate content");
            self.lblOneDesc.text = LocalisedString(@"This post has content that violates terms & conditions in Seeties.");
            
            self.lblTwoTitle.text = LocalisedString(@"Copywriting infringement");
            self.txtTwoDesc.text = LocalisedString(@"This post uses copyrighted works without permission.");
            
            self.txtTwoDesc.editable = false;
            self.txtTwoDesc.userInteractionEnabled = NO;
            
            break;

        default:
            break;
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if (textView == self.txtTwoDesc) {
        [self changeViewType:2];

    }
    else if(textView == self.ibTxtView)
    {
        [self changeViewType:3];

    }
    return YES;
}


-(NSString*)getReportMessage
{
    if(self.type == 1)
    {
        return self.lblOneDesc.text;
        
    }
    else if(self.type == 2)
    {
        return self.self.txtTwoDesc.text;

    }
    else{
        return self.ibTxtView.text;

    }
}
#pragma mark - Request Server
-(void)requestServerForFlagShop
{
    
    NSString* reportMessage = [self getReportMessage];
    NSString* shopID = @"";

    
    if(![Utils isStringNull:self.shopModel.seetishop_id])
    {
        shopID = self.shopModel.seetishop_id;
        
    }
    else if(![Utils isStringNull:self.shopModel.place_id]){
        shopID = self.shopModel.seetishop_id;

    }
    else if(![Utils isStringNull:self.shopModel.location.location_id])
    {
        shopID = self.shopModel.location.location_id;

    }
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"message" : reportMessage?reportMessage:@"",
                           @"seetishop_id" : shopID?shopID:@""
                           };
    
    
    NSString* appendString = [NSString stringWithFormat:@"%@/flag",shopID];
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostReportShop param:dict appendString:appendString completeHandler:^(id object) {
        
        
        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Report successfully") Type:TSMessageNotificationTypeSuccess];
        
        [self.navigationController popViewControllerAnimated:YES];


    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForFlagDeal
{
    NSString* reportMessage = [self getReportMessage];

    @try {
        NSDictionary* dict = @{@"token" : [Utils getAppToken],
                               @"message" : reportMessage?reportMessage:@"",
                               @"deal_id" : self.dealID
                               };
        
        NSString* appendString = [NSString stringWithFormat:@"%@/flag", self.dealID];
        
        [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostReportDeal param:dict appendString:appendString completeHandler:^(id object) {
            [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Report successfully") Type:TSMessageNotificationTypeSuccess];

            [self.navigationController popViewControllerAnimated:YES];
            
        } errorBlock:^(id object) {
            
        }];
    }
    @catch (NSException *exception) {
        
    }
    
  }

-(void)requestServerForFlagPost
{
    NSString* reportMessage = [self getReportMessage];
    
    @try {
        NSDictionary* dict = @{@"token" : [Utils getAppToken],
                               @"message" : reportMessage?reportMessage:@"",
                               @"post_id" : self.postId
                               };
        
        NSString* appendString = [NSString stringWithFormat:@"%@/flag", self.postId];
        
        [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostReportPost param:dict appendString:appendString completeHandler:^(id object) {
            [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Report successfully") Type:TSMessageNotificationTypeSuccess];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } errorBlock:^(id object) {
            
        }];
    }
    @catch (NSException *exception) {
        
    }
    
}
@end
