//
//  InviteFrenViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/8/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "InviteFrenViewController.h"
//#import "NewUserProfileV2ViewController.h"
#import "AsyncImageView.h"
#import "LanguageManager.h"
#import "Locale.h"

#import "AppDelegate.h"
@interface InviteFrenViewController ()
{
    IBOutlet UILabel *TitleLabel;
    IBOutlet UIImageView *BarImage;
    IBOutlet UITableView *EmailTblView;
    IBOutlet UIView *ShowInviteView;
    IBOutlet UIView *ShowFBView;
    IBOutlet UIView *ShowEmailView;
    
    IBOutlet UIButton *TabButton_1;
    IBOutlet UIButton *TabButton_2;
    IBOutlet UIButton *TabButton_3;
    
    IBOutlet UILabel *ShowFBText_1;
    IBOutlet UIButton *FbButton;
    
    IBOutlet UILabel *ShowOtherText_1;
    IBOutlet UIButton *FbMessagerButton;
    IBOutlet UIButton *WhatsappButton;
    IBOutlet UIButton *TrueLineButton;
    IBOutlet UIButton *SMSButton;
    
    IBOutlet UIButton *LineButton;
    
    IBOutlet UIButton *LoadingButton;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *InviteScroll;
    
    NSMutableArray *AllEmailDataArray;
    NSMutableArray *FullNameDataArray;
    
    NSString *GetEmail;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_GetAllUserData;
    NSURLConnection *theConnection_SendFollowData;
    NSURLConnection *theConnection_SendAllFollow;
    NSURLConnection *theConnection_GetContactUserData;
    NSURLConnection *theConnection_UpdateFBToSever;
    
    NSMutableArray *All_Experts_Username_Array;
    NSMutableArray *All_Experts_Location_Array;
    NSMutableArray *All_Experts_ProfilePhoto_Array;
    NSMutableArray *All_Experts_uid_Array;
    NSMutableArray *All_Experts_Followed_Array;
    
    NSInteger InviteEmailCheck;
    NSInteger GetSelectIDN;
    
    UIButton *TempButton;
    UIImageView *ShowFBInviteIcon;
    
    int CheckFollowAllButton;
    int CheckFollowFBAllButton;
    int CheckWhichOneOnClick;
    
    NSString *UserEmail;
    NSString *UserName;
    NSString *GetFB_ID;
    NSString *GetFB_Token;
    NSString *Name;
    NSString *Userdob;
    NSString *UserGender;
    
    NSMutableArray *FB_Experts_Username_Array;
    NSMutableArray *FB_Experts_ProfilePhoto_Array;
    NSMutableArray *FB_Experts_uid_Array;
    NSMutableArray *FB_Experts_Followed_Array;
    NSMutableArray *FB_Experts_Name_Array;
    
    NSString *SendMessage;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    BOOL CheckLoad;
    int GetHeight;
    int CheckFirstTimeLoad;
}
@property(nonatomic,strong)ProfileViewController* profileViewController;

@end

@implementation InviteFrenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 114);
    TitleLabel.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    TitleLabel.text = CustomLocalisedString(@"FindFriends", nil);
    
    ShowEmailView.frame = CGRectMake(0, 120, screenWidth, screenHeight - 120);
    EmailTblView.frame = CGRectMake(0, 50, screenWidth, screenHeight - 170);
    ShowInviteView.frame = CGRectMake(0, 114, screenWidth, screenHeight - 114);
    ShowFBView.frame = CGRectMake(0, 120, screenWidth, screenHeight - 120);
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight - 120);
    MainScroll.delegate = self;
    InviteScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight - 114);
    InviteScroll.delegate = self;
    InviteScroll.alwaysBounceVertical = YES;
    
    LoadingButton.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    LoadingButton.hidden = YES;


    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    int GetHeight_ = screenWidth / 2;
    TabButton_1.frame = CGRectMake(screenWidth - GetHeight_, 74, GetHeight_, 40);//button 2
    //TabButton_2.frame = CGRectMake(screenWidth - GetHeight_, 64, GetHeight_, 40);//button 3
    TabButton_2.hidden = YES;
    TabButton_3.frame = CGRectMake(0, 74, GetHeight_, 40);//button 1
    
    //LineButton.frame = CGRectMake(0, 120, screenWidth, 1);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Getfbextendedtoken = [defaults objectForKey:@"fbextendedtoken"];
    NSLog(@"Getfbextendedtoken is %@",Getfbextendedtoken);
    
    TotalPage = 1;
    CurrentPage = 0;
    CheckLoad = NO;
    CheckFirstTimeLoad = 0;
     
    if ([Getfbextendedtoken length] == 0 || Getfbextendedtoken == nil || [Getfbextendedtoken isEqualToString:@"(null)"]) {
        ShowFBText_1.frame = CGRectMake((screenWidth / 2) - 150, 25, 300, 60);
        ShowFBText_1.text = CustomLocalisedString(@"ConnectyouFacebook", nil);
        
        
        FbButton.frame = CGRectMake(20, 115, screenWidth - 40, 55);
        FbButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [FbButton setTitle:CustomLocalisedString(@"ConnectToFacebook", nil) forState:UIControlStateNormal];
        
        [self GetAllUserData];
    }else{
        ShowFBText_1.frame = CGRectMake((screenWidth / 2) - 150, 15, 300, 90);
        ShowFBText_1.text = CustomLocalisedString(@"Feelinglonelyonseeties", nil);
        
        ShowFBInviteIcon = [[UIImageView alloc]init];
        ShowFBInviteIcon.frame = CGRectMake(40, 135, 18, 14);
        ShowFBInviteIcon.image = [UIImage imageNamed:@"InviteIcon.png"];
        [MainScroll addSubview:ShowFBInviteIcon];
        
        FbButton.frame = CGRectMake(20, 115, screenWidth - 40, 55);
        [FbButton setTitle:CustomLocalisedString(@"InviteFacebook", nil) forState:UIControlStateNormal];
        
        [self GetContactsAllUserData];
    }
    
    [self initInviteFriendView];

    

    
//    UIButton *LineCenter_1 = [[UIButton alloc]init];
//    LineCenter_1.frame = CGRectMake((screenWidth / 2), 74, 1, 30);
//    [LineCenter_1 setTitle:@"" forState:UIControlStateNormal];
//    [LineCenter_1 setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
//    [self.view addSubview:LineCenter_1];
    
//    UIButton *LineCenter_2 = [[UIButton alloc]init];
//    LineCenter_2.frame = CGRectMake((screenWidth / 2) + (GetHeight / 2), 74, 1, 30);
//    [LineCenter_2 setTitle:@"" forState:UIControlStateNormal];
//    [LineCenter_2 setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
//    [self.view addSubview:LineCenter_2];
    
    AllEmailDataArray = [[NSMutableArray alloc]init];
    FullNameDataArray = [[NSMutableArray alloc]init];
    

    //ShowEmailView add text
    UILabel *ShowInviteText = [[UILabel alloc]init];
    ShowInviteText.frame = CGRectMake(20, 0, 250, 30);
    ShowInviteText.text = CustomLocalisedString(@"InviteFriends", nil);
    ShowInviteText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    ShowInviteText.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    [ShowEmailView addSubview:ShowInviteText];
    
    UILabel *ShowFollowAllText = [[UILabel alloc]init];
    ShowFollowAllText.frame = CGRectMake(screenWidth - 100 - 20, 5, 100, 20);
    ShowFollowAllText.text = CustomLocalisedString(@"Inviteall", nil);
    ShowFollowAllText.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    ShowFollowAllText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    ShowFollowAllText.textAlignment = NSTextAlignmentRight;
    [ShowEmailView addSubview:ShowFollowAllText];
    
    UIButton *InviteAllButton = [[UIButton alloc]init];
    [InviteAllButton setTitle:@"" forState:UIControlStateNormal];
    InviteAllButton.frame = CGRectMake(screenWidth - 100 - 20, 5, 100, 20);
    [InviteAllButton addTarget:self action:@selector(InviteAllButton:) forControlEvents:UIControlEventTouchUpInside];
    [ShowEmailView addSubview:InviteAllButton];
    
    
    //[self loadPhoneContacts];
    
    ShowEmailView.hidden = YES;
    ShowInviteView.hidden = NO;
    ShowFBView.hidden = YES;
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://seeties.me"];
    content.contentTitle = CustomLocalisedString(@"SendMessage", nil);
    content.contentDescription = @"";
    content.imageURL = [NSURL URLWithString:@"https://d23e8kmapbs4c0.cloudfront.net/web/images/seeties.png"];
    //    [FBSDKMessageDialog showWithContent:content delegate:nil];
    
//    FBSDKSendButton *button = [[FBSDKSendButton alloc] init];
//    button.frame = CGRectMake(160, 300, 100, 64);
//    button.shareContent = content;
//    if (button.isHidden) {
//        NSLog(@"Is hidden");
//    } else {
//        NSLog(@"ppl got install fb message.");
//        [ShowInviteView addSubview:button];
//    }

    SendMessage = [[NSString alloc]initWithFormat:@"%@\n\nhttps://seeties.me",CustomLocalisedString(@"SendMessage", nil)];
    
    
    InviteEmailCheck = 0;
    GetSelectIDN = 0;
    CheckFollowAllButton = 0;
    CheckFollowFBAllButton = 0;

    
}
-(void)initInviteFriendView{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
//    UIButton *Background = [[UIButton alloc]init];
//    Background.frame = CGRectMake(0, 0, screenWidth, 200);
//    [Background setTitle:@"" forState:UIControlStateNormal];
//    Background.backgroundColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
//    [InviteScroll addSubview:Background];
    
    UIImageView *ImgBackground = [[UIImageView alloc]init];
    ImgBackground.frame = CGRectMake(0, 0, screenWidth, 220);
    ImgBackground.image = [UIImage imageNamed:@"InviteFriendsBgImg.png"];
    ImgBackground.backgroundColor = [UIColor clearColor];
    ImgBackground.clipsToBounds = YES;
    [InviteScroll addSubview:ImgBackground];
    
    ShowOtherText_1.frame = CGRectMake((screenWidth / 2) - 150, 10, 300, 40);
    ShowOtherText_1.text = LocalisedString(@"The more, the merrier!");
    ShowOtherText_1.backgroundColor = [UIColor clearColor];
    ShowOtherText_1.textColor = [UIColor whiteColor];
    ShowOtherText_1.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:22];
    [InviteScroll addSubview:ShowOtherText_1];
    
    UIButton *WhiteBackground = [[UIButton alloc]init];
    WhiteBackground.frame = CGRectMake(30, 190, screenWidth - 60, screenHeight - 190 - 114);
    [WhiteBackground setTitle:@"" forState:UIControlStateNormal];
    WhiteBackground.backgroundColor = [UIColor whiteColor];
    WhiteBackground.layer.cornerRadius = 5;
    [InviteScroll addSubview:WhiteBackground];
    
    UIImageView *ShowBigIcon = [[UIImageView alloc]init];
    ShowBigIcon.frame = CGRectMake((screenWidth /2) - 89, 80, 178, 123);
    ShowBigIcon.image = [UIImage imageNamed:@"InviteFriendsGraphic.png"];
    ShowBigIcon.backgroundColor = [UIColor clearColor];
    [InviteScroll addSubview:ShowBigIcon];
    
    
    UIImageView *ShowWhatsappIcon = [[UIImageView alloc]init];
    ShowWhatsappIcon.frame = CGRectMake(60, 210 + 2, 50, 50);
    ShowWhatsappIcon.image = [UIImage imageNamed:@"InviteWhatsappIcon.png"];
    [InviteScroll addSubview:ShowWhatsappIcon];
    
    WhatsappButton.frame = CGRectMake(118 , 210, screenWidth - 158, 55);
    [WhatsappButton setTitle:LocalisedString(@"via Whatsapp") forState:UIControlStateNormal];
    [InviteScroll addSubview:WhatsappButton];
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(138, 265, screenWidth - 178, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    Line01.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    [InviteScroll addSubview:Line01];
    
    UIImageView *ShowFBMessagerIcon = [[UIImageView alloc]init];
    ShowFBMessagerIcon.frame = CGRectMake(60, 265 + 2, 50, 50);
    ShowFBMessagerIcon.image = [UIImage imageNamed:@"InviteMessengarIcon.png"];
    [InviteScroll addSubview:ShowFBMessagerIcon];

    FbMessagerButton.frame = CGRectMake(118, 265, screenWidth - 158, 55);
    [FbMessagerButton setTitle:LocalisedString(@"via Messenger") forState:UIControlStateNormal];
    [InviteScroll addSubview:FbMessagerButton];
    
    UIButton *Line02 = [[UIButton alloc]init];
    Line02.frame = CGRectMake(138, 320, screenWidth - 178, 1);
    [Line02 setTitle:@"" forState:UIControlStateNormal];
    Line02.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    [InviteScroll addSubview:Line02];
    
    UIImageView *ShowlineIcon = [[UIImageView alloc]init];
    ShowlineIcon.frame = CGRectMake(60, 320 + 2, 50, 50);
    ShowlineIcon.image = [UIImage imageNamed:@"InviteLineIcon.png"];
    [InviteScroll addSubview:ShowlineIcon];
    
    TrueLineButton.frame = CGRectMake(118, 320, screenWidth - 158, 55);
    [TrueLineButton setTitle:LocalisedString(@"via LINE") forState:UIControlStateNormal];
    [InviteScroll addSubview:TrueLineButton];

    UIButton *Line03 = [[UIButton alloc]init];
    Line03.frame = CGRectMake(60, 390, screenWidth - 120, 1);
    [Line03 setTitle:@"" forState:UIControlStateNormal];
    Line03.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    [InviteScroll addSubview:Line03];
    
    UIButton *EmailButton = [[UIButton alloc]init];
    EmailButton.frame = CGRectMake(60, 390, screenWidth - 120, 55);
    [EmailButton setTitle:LocalisedString(@"Send email") forState:UIControlStateNormal];
    EmailButton.backgroundColor = [UIColor clearColor];
    [EmailButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    EmailButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
    [EmailButton addTarget:self action:@selector(EmailButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [InviteScroll addSubview:EmailButton];
    
    
    SMSButton.frame = CGRectMake(60, 445, screenWidth - 120, 55);
    [SMSButton setTitle:LocalisedString(@"Send SMS") forState:UIControlStateNormal];
    [SMSButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [InviteScroll addSubview:SMSButton];
    
    UIButton *CopylinkButton = [[UIButton alloc]init];
    CopylinkButton.frame = CGRectMake(60, 500, screenWidth - 120, 55);
    [CopylinkButton setTitle:LocalisedString(@"Copy Link") forState:UIControlStateNormal];
    CopylinkButton.backgroundColor = [UIColor clearColor];
    [CopylinkButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    CopylinkButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
    [CopylinkButton addTarget:self action:@selector(CopyLinkButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [InviteScroll addSubview:CopylinkButton];
    
    InviteScroll.contentSize = CGSizeMake(screenWidth, 600);

}
-(IBAction)InviteAllButton:(id)sender{
    NSLog(@"Invite all to email button click");
    
    InviteEmailCheck = 1;
    [self SendEmail];
}
-(IBAction)TabButton_1:(id)sender{
    ShowEmailView.hidden = YES;
    ShowInviteView.hidden = YES;
    ShowFBView.hidden = NO;
    
    [TabButton_1 setImage:[UIImage imageNamed:@"FacebookBtnActive.png"] forState:UIControlStateNormal];
    [TabButton_2 setImage:[UIImage imageNamed:@"InstagramBtnInactive.png"] forState:UIControlStateNormal];
    [TabButton_3 setImage:[UIImage imageNamed:@"InviteBtnInactive.png"] forState:UIControlStateNormal];
}
-(IBAction)TabButton_2:(id)sender{
    ShowEmailView.hidden = NO;
    ShowInviteView.hidden = YES;
    ShowFBView.hidden = YES;
    
    [TabButton_1 setImage:[UIImage imageNamed:@"FacebookBtnInactive.png"] forState:UIControlStateNormal];
    [TabButton_2 setImage:[UIImage imageNamed:@"InstagramBtnActive.png"] forState:UIControlStateNormal];
    [TabButton_3 setImage:[UIImage imageNamed:@"InviteBtnInactive.png"] forState:UIControlStateNormal];
}
-(IBAction)TabButton_3:(id)sender{
    ShowEmailView.hidden = YES;
    ShowInviteView.hidden = NO;
    ShowFBView.hidden = YES;
    
    [TabButton_1 setImage:[UIImage imageNamed:@"FacebookBtnInactive.png"] forState:UIControlStateNormal];
    [TabButton_2 setImage:[UIImage imageNamed:@"InstagramBtnInactive.png"] forState:UIControlStateNormal];
    [TabButton_3 setImage:[UIImage imageNamed:@"InviteBtnActive.png"] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)BackButton:(id)sender{
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)GetAllUserData{
    LoadingButton.hidden = NO;
    [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@user/suggestions?token=%@&number_of_suggestions=30",DataUrl.UserWallpaper_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"GetAllUserData check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetAllUserData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetAllUserData start];
    
    
    if( theConnection_GetAllUserData ){
        webData = [NSMutableData data];
    }
}
-(void)GetContactsAllUserData{
    LoadingButton.hidden = NO;
    [ShowActivity startAnimating];
    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *GetUseruid = [defaults objectForKey:@"Useruid"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/contacts/suggestions?token=%@&page=%li",DataUrl.UserWallpaper_Url,GetUseruid,GetExpertToken,CurrentPage];
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"GetAllUserData check postBack URL ==== %@",postBack);
        NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        // NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_GetContactUserData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_GetContactUserData start];
        
        
        if( theConnection_GetContactUserData ){
            webData = [NSMutableData data];
        }
    }

}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

    LoadingButton.hidden = YES;
    [ShowActivity stopAnimating];
    //[ShowActivity removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == theConnection_GetAllUserData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
       // NSLog(@"Get All User return get data to server ===== %@",GetData);
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
       // NSLog(@"Experts Json = %@",res);
        NSDictionary *GetAllData = [res valueForKey:@"data"];
        NSDictionary *UserInfoData = [GetAllData valueForKey:@"random_users"];
        All_Experts_Username_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        All_Experts_Location_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        All_Experts_ProfilePhoto_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        All_Experts_uid_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        All_Experts_Followed_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        
        for (NSDictionary * dict in UserInfoData){
            NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
            [All_Experts_uid_Array addObject:uid];
            NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
            [All_Experts_ProfilePhoto_Array addObject:profile_photo];
            NSString *followed =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"following"]];
            [All_Experts_Followed_Array addObject:followed];
            NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            [All_Experts_Username_Array addObject:username];
            NSString *name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"location"]];
            [All_Experts_Location_Array addObject:name];
        }
        
       // NSLog(@"All_Experts_Location_Array is %@",All_Experts_Location_Array);
        
        [self InitAllUserView];
        
        
    }else if(connection == theConnection_SendAllFollow){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
      //  NSLog(@"Get All Following return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
       // NSLog(@"Expert Json = %@",res);
        
        NSString *ResultString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
       // NSLog(@"ResultString is %@",ResultString);
        
        if ([ResultString isEqualToString:@"ok"]) {
            for (UIView * view in MainScroll.subviews) {
                [view removeFromSuperview];
            }
            
            if (CheckWhichOneOnClick == 0) {
                for (int i = 0; i < [All_Experts_Followed_Array count]; i++) {
                    [All_Experts_Followed_Array replaceObjectAtIndex:i withObject:@"1"];
                    
                }
                
                CheckFollowAllButton = 1;
            }else{
                for (int i = 0; i < [FB_Experts_Followed_Array count]; i++) {
                    [FB_Experts_Followed_Array replaceObjectAtIndex:i withObject:@"1"];
                    
                }
                
                CheckFollowFBAllButton = 1;
            }
            

            

            
            
            [self InitAllUserView];
            
        }
        
    }else if(connection == theConnection_GetContactUserData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
     //   NSLog(@"Get Contact return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
       // NSLog(@"Experts Json = %@",res);
        NSDictionary *GetAllData = [res valueForKey:@"data"];
        NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_suggestions"];
        
        if (CheckFirstTimeLoad == 0) {
            FB_Experts_Username_Array = [[NSMutableArray alloc]init];
            FB_Experts_ProfilePhoto_Array = [[NSMutableArray alloc]init];
            FB_Experts_uid_Array = [[NSMutableArray alloc]init];
            FB_Experts_Followed_Array = [[NSMutableArray alloc]init];
            FB_Experts_Name_Array = [[NSMutableArray alloc]init];
            DataCount = 0;

        }else{
            
        }
        
        
//        FB_Experts_Username_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
//        FB_Experts_ProfilePhoto_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
//        FB_Experts_uid_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
//        FB_Experts_Followed_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        
        for (NSDictionary * dict in UserInfoData){
            NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
            [FB_Experts_uid_Array addObject:uid];
            NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
            [FB_Experts_ProfilePhoto_Array addObject:profile_photo];
            NSString *followed =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"following"]];
            [FB_Experts_Followed_Array addObject:followed];
            NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            [FB_Experts_Username_Array addObject:username];
            NSString *name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
            [FB_Experts_Name_Array addObject:name];

        }
        NSLog(@"FB_Experts_Name_Array is %@",FB_Experts_Name_Array);
    //    NSLog(@"FB_Experts_Username_Array is %@",FB_Experts_Username_Array);
        DataCount = DataTotal;
        DataTotal = [FB_Experts_uid_Array count];
        
        //       NSLog(@"DataCount in get server data === %li",(long)DataCount);
        //      NSLog(@"DataTotal in get server data === %li",(long)DataTotal);
        //    NSLog(@"CheckFirstTimeLoadLikes === %li",(long)CheckFirstTimeLoadLikes);
        //[self InitView];
        CheckLoad = NO;
        
        if (CheckFirstTimeLoad == 0) {
            CheckFirstTimeLoad = 1;
            [self GetAllUserData];
            
        }else{
            [self InitAllUserView];
        }
        
        
    }else if(connection == theConnection_UpdateFBToSever){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
     //   NSLog(@"Get theConnection_UpdateFBToSever return get data to server ===== %@",GetData);
        
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"res is %@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
       //     NSLog(@"ErrorString is %@",ErrorString);
       //     NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
         //   NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
                [ShowActivity stopAnimating];
            }else{
                NSString *GetFbExtendedToken = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"fb_token"]];
          //      NSLog(@"GetFbExtendedToken is %@",GetFbExtendedToken);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:GetFbExtendedToken forKey:@"fbextendedtoken"];
                [defaults synchronize];
                
                for (UIView * view in MainScroll.subviews) {
                    [view removeFromSuperview];
                }
                
                [self GetContactsAllUserData];
            }
        }
        
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //    NSLog(@"Get Following return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
      //  NSLog(@"Expert Json = %@",res);
        
        NSString *ResultString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        //NSLog(@"ResultString is %@",ResultString);
        
        if ([ResultString isEqualToString:@"ok"]) {

            TempButton.selected = !TempButton.selected;
            
            NSString *GetFollowData = [[NSString alloc]initWithFormat:@"%@",[All_Experts_Followed_Array objectAtIndex:GetSelectIDN]];
            if ([GetFollowData isEqualToString:@"1"]) {
                [All_Experts_Followed_Array replaceObjectAtIndex:GetSelectIDN withObject:@"0"];
            }else{
                [All_Experts_Followed_Array replaceObjectAtIndex:GetSelectIDN withObject:@"1"];
            }
        }
    }
}
-(IBAction)FollowAllButton:(id)sender{
    CheckWhichOneOnClick = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@follow/batch",DataUrl.UserWallpaper_Url];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i = 0; i < [All_Experts_uid_Array count]; i++) {
        //[CheckFollowArray replaceObjectAtIndex:i withObject:@"1"];
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"follow[%d]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",[All_Experts_uid_Array objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    theConnection_SendAllFollow = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_SendAllFollow) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(IBAction)FollowAllButton2:(id)sender{
    CheckWhichOneOnClick = 1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@follow/batch",DataUrl.UserWallpaper_Url];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i = 0; i < [FB_Experts_uid_Array count]; i++) {
        //[CheckFollowArray replaceObjectAtIndex:i withObject:@"1"];
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"follow[%d]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",[FB_Experts_uid_Array objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    theConnection_SendAllFollow = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_SendAllFollow) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)InitAllUserView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    
    [MainScroll addSubview:ShowFBText_1];
    [MainScroll addSubview:FbButton];
    [MainScroll addSubview:ShowFBInviteIcon];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Getfbextendedtoken = [defaults objectForKey:@"fbextendedtoken"];
    NSLog(@"Getfbextendedtoken is %@",Getfbextendedtoken);
    
    
    if ([Getfbextendedtoken length] == 0 || Getfbextendedtoken == nil || [Getfbextendedtoken isEqualToString:@"(null)"]) {
        UILabel *ShowSuggestionsText = [[UILabel alloc]init];
        ShowSuggestionsText.frame = CGRectMake(20, 205, 250, 30);
        ShowSuggestionsText.text = CustomLocalisedString(@"Suggestionsforyou", nil);
        ShowSuggestionsText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:22];
        ShowSuggestionsText.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        [MainScroll addSubview:ShowSuggestionsText];
        
        if (CheckFollowAllButton == 0) {
            
            UILabel *ShowFollowAllText = [[UILabel alloc]init];
            ShowFollowAllText.frame = CGRectMake(screenWidth - 100 - 20, 210, 100, 20);
            ShowFollowAllText.text = CustomLocalisedString(@"FollowAll", nil);
            ShowFollowAllText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            ShowFollowAllText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowFollowAllText.textAlignment = NSTextAlignmentRight;
            [MainScroll addSubview:ShowFollowAllText];
            
            UIButton *FollowAllButton = [[UIButton alloc]init];
            [FollowAllButton setTitle:@"" forState:UIControlStateNormal];
            FollowAllButton.frame = CGRectMake(screenWidth - 100 - 20, 210, 100, 20);
            [FollowAllButton addTarget:self action:@selector(FollowAllButton:) forControlEvents:UIControlEventTouchUpInside];
            [MainScroll addSubview:FollowAllButton];
        }else{
            
        }
        
        for (int i = 0; i < [All_Experts_Username_Array count]; i++) {
            AsyncImageView *ShowExpertProfilePhoto = [[AsyncImageView alloc]init];
            ShowExpertProfilePhoto.frame = CGRectMake(20 , 255 + i * 70, 40, 40);
            ShowExpertProfilePhoto.contentMode = UIViewContentModeScaleAspectFill;
            ShowExpertProfilePhoto.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowExpertProfilePhoto.layer.cornerRadius=20;
            ShowExpertProfilePhoto.layer.borderWidth=1;
            ShowExpertProfilePhoto.layer.masksToBounds = YES;
            ShowExpertProfilePhoto.layer.borderColor=[[UIColor clearColor] CGColor];
            ShowExpertProfilePhoto.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowExpertProfilePhoto];
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[All_Experts_ProfilePhoto_Array objectAtIndex:i]];
            
            //NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
          //  NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
            if ([FullImagesURL1 length] == 0) {
                ShowExpertProfilePhoto.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowExpertProfilePhoto.imageURL = url_UserImage;
            }
            
            
            UILabel *ShowName = [[UILabel alloc]init];
            ShowName.frame = CGRectMake(70, 250 + i * 70, 200, 30);
            ShowName.text = [All_Experts_Username_Array objectAtIndex:i];
            ShowName.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:17];
            ShowName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            
            UILabel *ShowUserName = [[UILabel alloc]init];
            ShowUserName.frame = CGRectMake(70, 275 + i * 70, 200, 20);
            ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:13];
            NSString *UsernameString = [[NSString alloc]initWithFormat:@"%@",[All_Experts_Location_Array objectAtIndex:i]];
            ShowUserName.text = UsernameString;
            ShowUserName.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            
            UIButton *ViewProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [ViewProfileButton setFrame:CGRectMake(0, 255+ i * 70, screenWidth, 70)];
            [ViewProfileButton setTitle:@"" forState:UIControlStateNormal];
            [ViewProfileButton setBackgroundColor:[UIColor clearColor]];
            ViewProfileButton.tag = i;
            [ViewProfileButton addTarget:self action:@selector(AllExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
            [Line01 setTitle:@"" forState:UIControlStateNormal];
            [Line01 setFrame:CGRectMake(0, 310 + i * 70, screenWidth, 1)];
            [Line01 setBackgroundColor:[UIColor colorWithRed:244.0/255.0f green:244.0/255.0f blue:244.0/255.0f alpha:1.0]];
            
            UIButton *ShowFollowerButton = [[UIButton alloc]init];
            [ShowFollowerButton setFrame:CGRectMake(screenWidth - 40 - 20, 255 + i * 70, 40, 40)];
            [ShowFollowerButton setBackgroundColor:[UIColor clearColor]];
            ShowFollowerButton.tag = i;
            [ShowFollowerButton addTarget:self action:@selector(FollowerButton:) forControlEvents:UIControlEventTouchUpInside];
            NSString *CheckFollower = [[NSString alloc]initWithFormat:@"%@",[All_Experts_Followed_Array objectAtIndex:i]];
            if ([CheckFollower isEqualToString:@"0"]) {
                [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
                [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateSelected];
            }else{
                [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateNormal];
                [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateSelected];
            }
            
            
            [MainScroll addSubview:ShowExpertProfilePhoto];
            [MainScroll addSubview:ShowName];
            [MainScroll addSubview:ShowUserName];
            [MainScroll addSubview:ViewProfileButton];
            [MainScroll addSubview:Line01];
            [MainScroll addSubview:ShowFollowerButton];
            
            
            [MainScroll setScrollEnabled:YES];
            MainScroll.backgroundColor = [UIColor whiteColor];
            [MainScroll setContentSize:CGSizeMake(screenWidth, 310 + i * 70)];
        }
    }else{
        GetHeight = 0;
        if ([FB_Experts_uid_Array count] == 0) {
            GetHeight += 205;
        }else{
            NSString *TempString = [[NSString alloc]initWithFormat:@"%lu %@",(unsigned long)[FB_Experts_uid_Array count],CustomLocalisedString(@"xFriendsOnSeeties", nil)];
            
            UILabel *ShowSuggestionsText = [[UILabel alloc]init];
            ShowSuggestionsText.frame = CGRectMake(20, 205, 250, 30);
            ShowSuggestionsText.text = TempString;
            ShowSuggestionsText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:22];
            ShowSuggestionsText.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            [MainScroll addSubview:ShowSuggestionsText];
            
            if (CheckFollowFBAllButton == 0) {
                
                UILabel *ShowFollowAllText = [[UILabel alloc]init];
                ShowFollowAllText.frame = CGRectMake(screenWidth - 100 - 20, 210, 100, 20);
                ShowFollowAllText.text = CustomLocalisedString(@"FollowAll", nil);
                ShowFollowAllText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                ShowFollowAllText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowFollowAllText.textAlignment = NSTextAlignmentRight;
                [MainScroll addSubview:ShowFollowAllText];
                
                UIButton *FollowAllButton = [[UIButton alloc]init];
                [FollowAllButton setTitle:@"" forState:UIControlStateNormal];
                FollowAllButton.frame = CGRectMake(screenWidth - 100 - 20, 210, 100, 20);
                [FollowAllButton addTarget:self action:@selector(FollowAllButton2:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:FollowAllButton];
            }else{
                
            }
            
            
            
            for (int i = 0; i < DataTotal; i++) {
                GetHeight = 255+i*70;
                AsyncImageView *ShowExpertProfilePhoto = [[AsyncImageView alloc]init];
                ShowExpertProfilePhoto.frame = CGRectMake(20 , 255 + i * 70, 40, 40);
                ShowExpertProfilePhoto.contentMode = UIViewContentModeScaleAspectFill;
                ShowExpertProfilePhoto.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowExpertProfilePhoto.layer.cornerRadius=20;
                ShowExpertProfilePhoto.layer.borderWidth=1;
                ShowExpertProfilePhoto.layer.masksToBounds = YES;
                ShowExpertProfilePhoto.layer.borderColor=[[UIColor clearColor] CGColor];
                ShowExpertProfilePhoto.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowExpertProfilePhoto];
                NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[FB_Experts_ProfilePhoto_Array objectAtIndex:i]];
                
                //NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
                NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
                if ([FullImagesURL1 length] == 0) {
                    ShowExpertProfilePhoto.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                }else{
                    NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                    ShowExpertProfilePhoto.imageURL = url_UserImage;
                }
                
                
                UILabel *ShowName = [[UILabel alloc]init];
                ShowName.frame = CGRectMake(70, 250 + i * 70, 200, 30);
                ShowName.text = [FB_Experts_Name_Array objectAtIndex:i];
                ShowName.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:17];
                ShowName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(70, 275 + i * 70, 200, 20);
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:13];
                NSString *UsernameString = [[NSString alloc]initWithFormat:@"%@",[FB_Experts_Username_Array objectAtIndex:i]];
                ShowUserName.text = UsernameString;
                ShowUserName.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                
                
                UIButton *ViewProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [ViewProfileButton setFrame:CGRectMake(0, 255+ i * 70, screenWidth, 70)];
                [ViewProfileButton setTitle:@"" forState:UIControlStateNormal];
                [ViewProfileButton setBackgroundColor:[UIColor clearColor]];
                ViewProfileButton.tag = i;
                [ViewProfileButton addTarget:self action:@selector(AllExpertsButton2:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
                [Line01 setTitle:@"" forState:UIControlStateNormal];
                [Line01 setFrame:CGRectMake(0, 310 + i * 70, screenWidth, 1)];
                [Line01 setBackgroundColor:[UIColor colorWithRed:244.0/255.0f green:244.0/255.0f blue:244.0/255.0f alpha:1.0]];
                
                UIButton *ShowFollowerButton = [[UIButton alloc]init];
                [ShowFollowerButton setFrame:CGRectMake(screenWidth - 40 - 20, 255 + i * 70, 40, 40)];
                [ShowFollowerButton setBackgroundColor:[UIColor clearColor]];
                ShowFollowerButton.tag = i;
                [ShowFollowerButton addTarget:self action:@selector(FollowerButton2:) forControlEvents:UIControlEventTouchUpInside];
                NSString *CheckFollower = [[NSString alloc]initWithFormat:@"%@",[FB_Experts_Followed_Array objectAtIndex:i]];
                if ([CheckFollower isEqualToString:@"0"]) {
                    [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
                    [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateSelected];
                }else{
                    [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateNormal];
                    [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateSelected];
                }
                
                
                [MainScroll addSubview:ShowExpertProfilePhoto];
                [MainScroll addSubview:ShowName];
                [MainScroll addSubview:ShowUserName];
                [MainScroll addSubview:ViewProfileButton];
                [MainScroll addSubview:Line01];
                [MainScroll addSubview:ShowFollowerButton];
                
                
                //            [MainScroll setScrollEnabled:YES];
                //            MainScroll.backgroundColor = [UIColor whiteColor];
                //            [MainScroll setContentSize:CGSizeMake(screenWidth, 310 + i * 70)];
                [MainScroll setScrollEnabled:YES];
                MainScroll.backgroundColor = [UIColor whiteColor];
                [MainScroll setContentSize:CGSizeMake(screenWidth, (GetHeight + 45) + i * 70)];
            }
            
             GetHeight += 70;
        }
        
        if ([FB_Experts_uid_Array count] <= 10) {
            UILabel *ShowSuggestionsText2 = [[UILabel alloc]init];
            ShowSuggestionsText2.frame = CGRectMake(20, GetHeight, 250, 30);
            ShowSuggestionsText2.text = CustomLocalisedString(@"Suggestionsforyou", nil);
            ShowSuggestionsText2.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:22];
            ShowSuggestionsText2.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            [MainScroll addSubview:ShowSuggestionsText2];
            
            if (CheckFollowAllButton == 0) {
                
                UILabel *ShowFollowAllText = [[UILabel alloc]init];
                ShowFollowAllText.frame = CGRectMake(screenWidth - 100 - 20, GetHeight + 5, 100, 20);
                ShowFollowAllText.text = CustomLocalisedString(@"FollowAll", nil);
                ShowFollowAllText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                ShowFollowAllText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowFollowAllText.textAlignment = NSTextAlignmentRight;
                [MainScroll addSubview:ShowFollowAllText];
                
                UIButton *FollowAllButton = [[UIButton alloc]init];
                [FollowAllButton setTitle:@"" forState:UIControlStateNormal];
                FollowAllButton.frame = CGRectMake(screenWidth - 100 - 20, GetHeight + 5, 100, 20);
                [FollowAllButton addTarget:self action:@selector(FollowAllButton:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:FollowAllButton];
            }else{
                
            }
            
            GetHeight += 45;
            
            for (int i = 0; i < [All_Experts_Username_Array count]; i++) {
                AsyncImageView *ShowExpertProfilePhoto = [[AsyncImageView alloc]init];
                ShowExpertProfilePhoto.frame = CGRectMake(20 , GetHeight + i * 70, 40, 40);
                ShowExpertProfilePhoto.contentMode = UIViewContentModeScaleAspectFill;
                ShowExpertProfilePhoto.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowExpertProfilePhoto.layer.cornerRadius=20;
                ShowExpertProfilePhoto.layer.borderWidth=1;
                ShowExpertProfilePhoto.layer.masksToBounds = YES;
                ShowExpertProfilePhoto.layer.borderColor=[[UIColor clearColor] CGColor];
                ShowExpertProfilePhoto.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowExpertProfilePhoto];
                NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[All_Experts_ProfilePhoto_Array objectAtIndex:i]];
                
                //NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
                NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
                if ([FullImagesURL1 length] == 0) {
                    ShowExpertProfilePhoto.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                }else{
                    NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                    ShowExpertProfilePhoto.imageURL = url_UserImage;
                }
                
                
                UILabel *ShowName = [[UILabel alloc]init];
                ShowName.frame = CGRectMake(70, (GetHeight - 5) + i * 70, 200, 30);
                ShowName.text = [All_Experts_Username_Array objectAtIndex:i];
                ShowName.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:17];
                ShowName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(70, (GetHeight + 20) + i * 70, 200, 20);
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:13];
                NSString *UsernameString = [[NSString alloc]initWithFormat:@"%@",[All_Experts_Location_Array objectAtIndex:i]];
                ShowUserName.text = UsernameString;
                ShowUserName.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                
                UIButton *ViewProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [ViewProfileButton setFrame:CGRectMake(0, GetHeight + i * 70, screenWidth, 70)];
                [ViewProfileButton setTitle:@"" forState:UIControlStateNormal];
                [ViewProfileButton setBackgroundColor:[UIColor clearColor]];
                ViewProfileButton.tag = i;
                [ViewProfileButton addTarget:self action:@selector(AllExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
                [Line01 setTitle:@"" forState:UIControlStateNormal];
                [Line01 setFrame:CGRectMake(0, (GetHeight + 45) + i * 70, screenWidth, 1)];
                [Line01 setBackgroundColor:[UIColor colorWithRed:244.0/255.0f green:244.0/255.0f blue:244.0/255.0f alpha:1.0]];
                
                UIButton *ShowFollowerButton = [[UIButton alloc]init];
                [ShowFollowerButton setFrame:CGRectMake(screenWidth - 40 - 20, GetHeight + i * 70, 40, 40)];
                [ShowFollowerButton setBackgroundColor:[UIColor clearColor]];
                ShowFollowerButton.tag = i;
                [ShowFollowerButton addTarget:self action:@selector(FollowerButton:) forControlEvents:UIControlEventTouchUpInside];
                NSString *CheckFollower = [[NSString alloc]initWithFormat:@"%@",[All_Experts_Followed_Array objectAtIndex:i]];
                if ([CheckFollower isEqualToString:@"0"]) {
                    [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
                    [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateSelected];
                }else{
                    [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateNormal];
                    [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateSelected];
                }
                
                [MainScroll addSubview:ShowExpertProfilePhoto];
                [MainScroll addSubview:ShowName];
                [MainScroll addSubview:ShowUserName];
                [MainScroll addSubview:ViewProfileButton];
                [MainScroll addSubview:Line01];
                [MainScroll addSubview:ShowFollowerButton];
                
                
                [MainScroll setScrollEnabled:YES];
                MainScroll.backgroundColor = [UIColor whiteColor];
                [MainScroll setContentSize:CGSizeMake(screenWidth, (GetHeight + 45) + i * 70)];
            }
        }
        
        [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight)];
        }
        
        
    
    
    
    
    
    LoadingButton.hidden = YES;
    [ShowActivity stopAnimating];
    //[ShowActivity removeFromSuperview];
}
-(void)loadPhoneContacts{
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusDenied) {
        // if you got here, user had previously denied/revoked permission for your
        // app to access the contacts, and all you can do is handle this gracefully,
        // perhaps telling the user that they have to go to settings to grant access
        // to contacts
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (error) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        if (addressBook) CFRelease(addressBook);
        return;
    }
    
    if (status == kABAuthorizationStatusNotDetermined) {
        
        // present the user the UI that requests permission to contacts ...
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (error) {
                NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
            }
            
            if (granted) {
                // if they gave you permission, then just carry on
                
                [self listPeopleInAddressBook:addressBook];
            } else {
                // however, if they didn't give you permission, handle it gracefully, for example...
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                    
                    [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                });
            }
            
            if (addressBook) CFRelease(addressBook);
        });
        
    } else if (status == kABAuthorizationStatusAuthorized) {
        [self listPeopleInAddressBook:addressBook];
        if (addressBook) CFRelease(addressBook);
    }
}

- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook
{
    NSInteger numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        
        
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSLog(@"Name:%@ %@", firstName, lastName);
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            NSLog(@"  phone:%@", phoneNumber);
        }
        ABMultiValueRef getemail = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        CFIndex numberOfemail = ABMultiValueGetCount(getemail);
        for (CFIndex i = 0; i < numberOfemail; i++) {
            NSString *getemail_ = CFBridgingRelease(ABMultiValueCopyValueAtIndex(getemail, i));
            if ([getemail_ length] == 0) {
                
            }else{
                [AllEmailDataArray addObject:getemail_];
                
//                if ([lastName length] == 0) {
//                     [FullNameDataArray addObject:firstName];
//                }else if([firstName length] == 0){
//                      [FullNameDataArray addObject:lastName];
//                }else{
//                    NSString *GetFullname = [[NSString alloc]initWithFormat:@"%@ %@",firstName,lastName];
//                    [FullNameDataArray addObject:GetFullname];
//                }
                if ([firstName length] == 0 || firstName == nil || [firstName isEqualToString:@"(null)"]) {
                    firstName = @"";
                }
                if ([lastName length] == 0 || lastName == nil || [lastName isEqualToString:@"(null)"]) {
                    lastName = @"";
                }
                NSString *GetFullname = [[NSString alloc]initWithFormat:@"%@ %@",firstName,lastName];
                [FullNameDataArray addObject:GetFullname];
               
            }
            NSLog(@"  email:%@", getemail_);
        }

        
        CFRelease(phoneNumbers);
        CFRelease(getemail);
        NSLog(@"=============================================");
    }
    [EmailTblView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [AllEmailDataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.frame = CGRectMake(15, 10, 40, 40);
        ShowImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowImage.layer.cornerRadius=20;
        ShowImage.layer.borderWidth=0;
        ShowImage.layer.masksToBounds = YES;
        ShowImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [cell addSubview:ShowImage];
        
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.tag = 10;
        ShowName.frame = CGRectMake(70, 10, screenWidth - 150, 25);
        ShowName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        ShowName.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        [cell addSubview:ShowName];
        
        UILabel *ShowEmail = [[UILabel alloc]init];
        ShowEmail.tag = 20;
        ShowEmail.frame = CGRectMake(70, 35, screenWidth - 150, 20);
        ShowEmail.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowEmail.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        [cell addSubview:ShowEmail];
        
        UIButton *InviteButton = [[UIButton alloc]init];
        InviteButton.frame = CGRectMake(screenWidth - 15 - 80, 0, 80, 60);
        [InviteButton setTitle:CustomLocalisedString(@"Invite", nil) forState:UIControlStateNormal];
        InviteButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
        [InviteButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:225.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        InviteButton.backgroundColor = [UIColor clearColor];
        InviteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
     //   InviteButton.tag = i;
       // [InviteButton addTarget:self action:@selector(EditButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:InviteButton];
        
    }

    UILabel *ShowFullName = (UILabel *)[cell viewWithTag:10];
    ShowFullName.text = [FullNameDataArray objectAtIndex:indexPath.row];
    
    UILabel *ShowEmail = (UILabel *)[cell viewWithTag:20];
    ShowEmail.text = [AllEmailDataArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GetEmail = [[NSString alloc]initWithFormat:@"%@",[AllEmailDataArray objectAtIndex:indexPath.row]];
    [self SendEmail];
}
-(IBAction)FBMessageButton:(id)sender{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://seeties.me"];
    content.contentTitle = CustomLocalisedString(@"SendMessage", nil);
    content.contentDescription = @"";
    content.imageURL = [NSURL URLWithString:@"https://pbs.twimg.com/profile_images/499756229170716673/U1ejUl7V.png"];
    [FBSDKMessageDialog showWithContent:content delegate:nil];
}
-(IBAction)WhatsAppButton:(id)sender{
    NSString *ShareText = SendMessage;
    ShareText = [ShareText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
   // NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=%@"];
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",ShareText]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }else{
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id310633997"];
        [[UIApplication sharedApplication] openURL:itunesURL];
    }

}
-(IBAction)WechatButton:(id)sender{
    
}
-(IBAction)SMSButton:(id)sender{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageComposer =
        [[MFMessageComposeViewController alloc] init];
        NSString *message = SendMessage;
        [messageComposer setBody:message];
        messageComposer.messageComposeDelegate = self;
        [self presentViewController:messageComposer animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)LineButton:(id)sender{
    NSString *ShareText = SendMessage;
    ShareText = [ShareText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"line://msg/text/%@",ShareText]];
    if ([[UIApplication sharedApplication] canOpenURL: appURL]) {
        [[UIApplication sharedApplication] openURL: appURL];
    }
    else { //如果使用者沒有安裝，連結到App Store
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id443904275"];
        [[UIApplication sharedApplication] openURL:itunesURL];
    }
}
-(IBAction)FbSendButton:(id)sender{
    NSLog(@"FbSendButton Click");
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://seeties.me"];
    content.contentTitle = CustomLocalisedString(@"SendMessage", nil);
    content.contentDescription = @"";
    content.imageURL = [NSURL URLWithString:@"https://pbs.twimg.com/profile_images/499756229170716673/U1ejUl7V.png"];
    [FBSDKMessageDialog showWithContent:content delegate:nil];
    
//    FBSDKSendButton *button = [[FBSDKSendButton alloc] init];
//    button.frame = CGRectMake(160, 200, 100, 64);
//    button.shareContent = content;
//    if (button.isHidden) {
//        NSLog(@"Is hidden");
//    } else {
//        NSLog(@"ppl got install fb message.");
//        [self.view addSubview:button];
//    }
}
-(IBAction)FBInvitesButton:(id)sender{
    NSLog(@"FB Invites Button Click");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Getfbextendedtoken = [defaults objectForKey:@"fbextendedtoken"];
    NSLog(@"Getfbextendedtoken is %@",Getfbextendedtoken);
    
    
    if ([Getfbextendedtoken length] == 0 || Getfbextendedtoken == nil || [Getfbextendedtoken isEqualToString:@"(null)"]) {
        NSLog(@"Open connect facebook");
        [ShowActivity startAnimating];
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_birthday"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             switch (state) {
                 case FBSessionStateOpen:{
                     [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                         if (error) {
                             
                             NSLog(@"error:%@",error);
                             
                             
                         }
                         else
                         {
                             // retrive user's details at here as shown below
                             NSLog(@"all information is %@",user);
                             GetFB_ID = (NSString *)[user valueForKey:@"id"];
                             
                             [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
                                 if (error) {
                                     // Handle error
                                 }else {
                                     Name = [FBuser name];
                                     NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", GetFB_ID];
                                     UserEmail = [user valueForKey:@"email"];
                                     UserGender = [user valueForKey:@"gender"];
                                     Userdob = [user valueForKey:@"birthday"];
                                     UserName = [user valueForKey:@"last_name"];
                                     UserName = [[NSString alloc]initWithFormat:@"%@%@",[user valueForKey:@"first_name"],[user valueForKey:@"last_name"]];
                                     
                                     NSLog(@"name is %@",Name);
                                     NSLog(@"username is %@",UserName);
                                     NSLog(@"Userid is %@",GetFB_ID);
                                     NSLog(@"useremail is %@",UserEmail);
                                     NSLog(@"usergender is %@",UserGender);
                                     NSLog(@"userImageURL is %@",userImageURL);
                                     NSLog(@"userdob is %@",Userdob);
                                     NSLog(@"session is %@",session);
                                     
                                     GetFB_Token = [FBSession activeSession].accessTokenData.accessToken;
                                     NSLog(@"GetToken is %@",GetFB_Token);
                                     
                                     [self UploadInformationToServer];
                                     
                                 }
                             }];
                             
                         }
                     }];
                     break;
                 }
                 case FBSessionStateClosed:
                 case FBSessionStateClosedLoginFailed:
                     [FBSession.activeSession closeAndClearTokenInformation];
                     break;
                     
                 default:
                     break;
             }
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
         }];
    }else{
        FBSDKAppInviteContent *InvitesContent =[[FBSDKAppInviteContent alloc] init];
        InvitesContent.appLinkURL = [NSURL URLWithString:@"https://fb.me/805801229516491"];
        //optionally set previewImageURL
        //InvitesContent.previewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
        
        // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
        [FBSDKAppInviteDialog showWithContent:InvitesContent
                                     delegate:self];
    }
    

    
    
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"appInviteDialog results is %@",results);
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
    NSLog(@"appInviteDialog error is %@",error);
}
-(void)SendEmail{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:CustomLocalisedString(@"SendMessage", nil)];
        if (InviteEmailCheck == 0) {
            NSArray *toRecipients = [NSArray arrayWithObjects:GetEmail, nil];
            [mailer setToRecipients:toRecipients];
        }else{
           [mailer setToRecipients:AllEmailDataArray];
        }

        
//        UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
//        NSData *imageData = UIImagePNGRepresentation(myImage);
//        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        
        NSString *emailBody = @"https://seeties.me \n\n Seeties is about your city life - from skydiving, waterfall picnic, local street food, blind dating, latest fashion to sunset drinks and parties! You can find them in Seeties through recommendations from locals.";
        [mailer setMessageBody:emailBody isHTML:NO];
        
       // [self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)AllExpertsButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
//    NewUserProfileV2ViewController *ExpertsUserProfileView = [[NewUserProfileV2ViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
//    [ExpertsUserProfileView GetUserName:[All_Experts_Username_Array objectAtIndex:getbuttonIDN]];
    
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[All_Experts_uid_Array objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];
}
-(IBAction)AllExpertsButton2:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
//    NewUserProfileV2ViewController *ExpertsUserProfileView = [[NewUserProfileV2ViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
//    [ExpertsUserProfileView GetUserName:[FB_Experts_Username_Array objectAtIndex:getbuttonIDN]];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[FB_Experts_uid_Array objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];
}
-(IBAction)FollowerButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    TempButton = (UIButton *)sender;
    
    GetSelectIDN = getbuttonIDN;
    
    NSString *GetFollowData = [[NSString alloc]initWithFormat:@"%@",[All_Experts_Followed_Array objectAtIndex:getbuttonIDN]];
    
    if ([GetFollowData isEqualToString:@"1"]) {
        
        
        NSString *tempStirng = [[NSString alloc]initWithFormat:@"%@ %@ ?",LocalisedString(@"Are you sure you want to quit following"),[All_Experts_Username_Array objectAtIndex:getbuttonIDN]];
        
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:LocalisedString(@"Unfollow user") message:tempStirng delegate:self cancelButtonTitle:LocalisedString(@"Maybe not.") otherButtonTitles:LocalisedString(@"Yeah!"), nil];
        ShowAlertView.tag = 1200;
        [ShowAlertView show];
    }else{
        
        [self SendFollowData];
    }
}
-(IBAction)FollowerButton2:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    TempButton = (UIButton *)sender;
    
    GetSelectIDN = getbuttonIDN;
    
    NSString *GetFollowData = [[NSString alloc]initWithFormat:@"%@",[FB_Experts_Followed_Array objectAtIndex:getbuttonIDN]];
    
    if ([GetFollowData isEqualToString:@"1"]) {
        
        NSString *tempStirng = [[NSString alloc]initWithFormat:@"%@ %@ ?",LocalisedString(@"Are you sure you want to quit following"),[FB_Experts_Username_Array objectAtIndex:getbuttonIDN]];
        
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:LocalisedString(@"Unfollow user") message:tempStirng delegate:self cancelButtonTitle:LocalisedString(@"Maybe not.") otherButtonTitles:LocalisedString(@"Yeah!"), nil];
        ShowAlertView.tag = 1200;
        [ShowAlertView show];
    }else{
        
        [self SendFollowData2];
    }
}
-(void)SendFollowData{
    
    //    for (UIView *subview in MainScroll.subviews) {
    //        [subview removeFromSuperview];
    //    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *Getuid_ = [[NSString alloc]initWithFormat:@"%@",[All_Experts_uid_Array objectAtIndex:GetSelectIDN]];
    NSString *GetFollowData = [[NSString alloc]initWithFormat:@"%@",[All_Experts_Followed_Array objectAtIndex:GetSelectIDN]];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/follow?token=%@",DataUrl.UserWallpaper_Url,Getuid_,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    //  [request setHTTPMethod:@"POST"];
    if ([GetFollowData isEqualToString:@"1"]) {
        [request setHTTPMethod:@"DELETE"];
    }else{
        [request setHTTPMethod:@"POST"];
    }
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_SendFollowData = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_SendFollowData) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)SendFollowData2{
    
    //    for (UIView *subview in MainScroll.subviews) {
    //        [subview removeFromSuperview];
    //    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *Getuid_ = [[NSString alloc]initWithFormat:@"%@",[FB_Experts_uid_Array objectAtIndex:GetSelectIDN]];
    NSString *GetFollowData = [[NSString alloc]initWithFormat:@"%@",[FB_Experts_Followed_Array objectAtIndex:GetSelectIDN]];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/follow?token=%@",DataUrl.UserWallpaper_Url,Getuid_,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    //  [request setHTTPMethod:@"POST"];
    if ([GetFollowData isEqualToString:@"1"]) {
        [request setHTTPMethod:@"DELETE"];
    }else{
        [request setHTTPMethod:@"POST"];
    }
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_SendFollowData = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_SendFollowData) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1200){
        if (buttonIndex == [alertView cancelButtonIndex]){
            NSLog(@"Cancel");
        }else{
            //send delete data.
            [self SendFollowData];
        }
    }
    
}
-(void)UploadInformationToServer{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetUseruid = [defaults objectForKey:@"Useruid"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DataUrl.UserWallpaper_Url,GetUseruid];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    //1063655260 + CAAGxtEzl7IABANzd8VBZCZAF3YUMAfiambyQ2orfrQ7rE4CEv3uVPZBahkXFFdRmuuZA0CzKZBiHDfUiot9UV3ijM5OddrKh3vcuDZCMCVEvjZBxDdocFAB1omPpVQHuQ9JTdbC58gsdquDicDVtFZBXLTHGOWNF9sVTL39rtBz5Js1dI6ctC3cgolSF6Aqlc54j9lIuvO6UJ7ehPDXGiMx5q1HMZBZBzPVOZCheBR1xTkT5qFauwOpNmu5
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fb_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetFB_ID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fb_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetFB_Token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_UpdateFBToSever = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_UpdateFBToSever) {
        NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }

}
//start scroll end reflash data
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == MainScroll) {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height)
        {
            // we are at the end
            NSLog(@"we are at the end");
            if ([FB_Experts_uid_Array count] <= 10) {
            }else{
                if (CheckLoad == YES) {
                    
                }else{
                    CheckLoad = YES;
                    if (CurrentPage == TotalPage) {
                        
                    }else{
                        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                        
                        MainScroll.frame = CGRectMake(0, GetHeight, screenWidth, MainScroll.frame.size.height + 20);
                        UIActivityIndicatorView * activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((screenWidth/2) - 15, MainScroll.frame.size.height, 30, 30)];
                        [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                        [activityindicator1 setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
                        [MainScroll addSubview:activityindicator1];
                        [activityindicator1 startAnimating];
                        MainScroll.frame = CGRectMake(0, GetHeight, screenWidth, MainScroll.frame.size.height + 70);
                        [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + MainScroll.frame.size.height)];
                        
                        [self GetContactsAllUserData];
                    }
                    
                    
                }
            }

        }
    }
    
}
-(IBAction)EmailButtonOnClick:(id)sender{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        NSString *emailBody = @"https://seeties.me \n\n Seeties is about your city life - from skydiving, waterfall picnic, local street food, blind dating, latest fashion to sunset drinks and parties! You can find them in Seeties through recommendations from locals.";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        // [self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
-(IBAction)CopyLinkButtonOnClick:(id)sender{
    NSString *message = @"https://seeties.me \n\n Seeties is about your city life - from skydiving, waterfall picnic, local street food, blind dating, latest fashion to sunset drinks and parties! You can find them in Seeties through recommendations from locals.";
   
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = message;
    [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Copy Link" type:TSMessageNotificationTypeSuccess];
}
-(ProfileViewController*)profileViewController
{
    if(!_profileViewController)
        _profileViewController = [ProfileViewController new];
    
    return _profileViewController;
}
@end
