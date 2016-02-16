//
//  AnnounceViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 12/10/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "AnnounceViewController.h"

@interface AnnounceViewController ()<UIScrollViewDelegate>
{
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    IBOutlet AsyncImageView *ShowBigImage;
    IBOutlet UIImageView *ShowIcon;
    IBOutlet UITextView *ShowContent;
    
    NSString *GetImageString;
    NSString *GetContentString;
}
@end

@implementation AnnounceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 700)];
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    ShowTitle.text = LocalisedString(@"Announce");
    
    ShowBigImage.frame = CGRectMake(0, 0, screenWidth, 210);
    ShowIcon.frame = CGRectMake(screenWidth - 88, 173, 68, 68);
    ShowContent.frame = CGRectMake(10, 238, screenWidth - 20, screenHeight - 238);
    
    ShowBigImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowBigImage.layer.masksToBounds = YES;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowBigImage];
    if ([GetImageString length] == 0) {
        ShowBigImage.image = [UIImage imageNamed:@"NoImage.png"];
    }else{
        NSURL *url_NearbySmall = [NSURL URLWithString:GetImageString];
        ShowBigImage.imageURL = url_NearbySmall;
    }
    
    ShowContent.text = GetContentString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(IBAction)BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)GetDisplayImage:(NSString *)ImageData GetContent:(NSString *)content{

    GetImageString = ImageData;
    GetContentString = content;
    
    ShowBigImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowBigImage.layer.masksToBounds = YES;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowBigImage];
    if ([GetImageString length] == 0) {
        ShowBigImage.image = [UIImage imageNamed:@"NoImage.png"];
    }else{
        NSURL *url_NearbySmall = [NSURL URLWithString:GetImageString];
        ShowBigImage.imageURL = url_NearbySmall;
    }
    
    ShowContent.text = GetContentString;
}

-(void)initData:(CTFeedTypeModel*)model
{
    AnnouncementModel* aModel = model.announcementData;
    ShowBigImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowBigImage.layer.masksToBounds = YES;
    if ([Utils isStringNull:aModel.photo]) {
        ShowBigImage.image = [UIImage imageNamed:@"NoImage.png"];
    }else{
        NSURL *url_NearbySmall = [NSURL URLWithString:aModel.photo];
        [ShowBigImage sd_setImageCroppedWithURL:url_NearbySmall completed:nil];
    }
    
    ShowContent.text = aModel.desc[[Utils getDeviceAppLanguageCode]];
    
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
    ShowIcon.image = [UIImage imageNamed:iconImage];
}
@end
