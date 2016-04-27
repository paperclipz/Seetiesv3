//
//  CT3_AnnouncementViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/16/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_AnnouncementViewController.h"

@interface CT3_AnnouncementViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgLogo;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;

@end

@implementation CT3_AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

-(void)initSelfView
{
    [self.ibImgLogo setRoundedBorder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData:(CTFeedTypeModel*)model
{
    AnnouncementModel* aModel = model.announcementData;
    if (![Utils isStringNull:aModel.photo]) {

        [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:aModel.photo] completed:nil];
    }
    
    self.txtDesc.text = aModel.desc[[Utils getDeviceAppLanguageCode]];
    
    NSString* iconImage;
    switch (model.feedType) {
            
        case FeedType_Announcement_Campaign:
            iconImage = @"CampaignLogo.png";
            break;
        default:
            
        case FeedType_Announcement:
            iconImage = @"AnnounceLogo.png";
            break;
            
    }
    self.ibImgLogo.image = [UIImage imageNamed:iconImage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
