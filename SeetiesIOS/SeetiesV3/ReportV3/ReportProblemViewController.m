//
//  ReportProblemViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/22/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ReportProblemViewController.h"

@interface ReportProblemViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *ibTxtView;
@property (weak, nonatomic) IBOutlet UILabel *lblOneDesc;

@property (weak, nonatomic) IBOutlet UILabel *lblOneTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTwoTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTwoDesc;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgOneTick;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgTwoTick;

@property (weak, nonatomic) IBOutlet UIImageView *ibImgThreeTick;
@property (assign, nonatomic) int type;
@property (assign, nonatomic) int reportType;//1 == shop 2 == deal

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


-(void)changeViewType:(int)type
{
    
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

-(void)initDataReportShop
{
    self.reportType = 1;
}

-(void)initDataReportDeal
{
    self.reportType = 2;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    [Utils setRoundBorder:self.ibTxtView color:LINE_COLOR borderRadius:5.0f borderWidth:1.0f];
    
    [self changeViewType:1];
    switch (self.reportType) {
        case 1:
            
            self.lblTitle.text = LocalisedString(@"Report Shop");

            self.lblOneTitle.text = LocalisedString(@"Shop could not be found");
            self.lblOneDesc.text = LocalisedString(@"The shop could not be found in the area specified");

            self.lblTwoTitle.text = LocalisedString(@"Inaccurate information");
            self.lblTwoDesc.text = LocalisedString(@"Shop information provided is inaccurate (eg.Business hours, address etc.)");
            


            break;
        case 2:
            
            self.lblTitle.text = LocalisedString(@"Report Deal");

            
            self.lblOneTitle.text = LocalisedString(@"Deal is not available");
            self.lblOneDesc.text = LocalisedString(@"The deal is not available in the shop promoted.");
            
            self.lblTwoTitle.text = LocalisedString(@"Deal is different value");
            self.lblTwoDesc.text = LocalisedString(@"The deal does not reflect the promoted value");
            
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
    [self changeViewType:3];
    
    return YES;
}


@end
