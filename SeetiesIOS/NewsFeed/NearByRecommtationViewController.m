//
//  NearByRecommtationViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/10/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "NearByRecommtationViewController.h"
#import "AsyncImageView.h"
#import "NSString+ChangeAsciiString.h"
#import "NewUserProfileV2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"

@interface NearByRecommtationViewController ()

@end

@implementation NearByRecommtationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    TitleLabel.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    TitleLabel.text = CustomLocalisedString(@"NearbyRecommendations", nil);
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
    
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    heightcheck = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)GetLPhoto:(NSMutableArray *)Photo GetPostID:(NSMutableArray *)PostID GetPlaceName:(NSMutableArray *)PlaceName GetUserInfoUrl:(NSMutableArray *)UserInfoUrl GetUserInfoName:(NSMutableArray *)UserInfoName GetTitle:(NSMutableArray *)Title GetMessage:(NSMutableArray *)Message GetDistance:(NSMutableArray *)Distance GetSearchDisplayName:(NSMutableArray *)SearchDisplayName GetTotalComment:(NSMutableArray *)TotalComment GetTotalLike:(NSMutableArray *)TotalLike GetSelfCheckLike:(NSMutableArray *)SelfCheckLike{

    LPhotoArray = [[NSMutableArray alloc]initWithArray:Photo];
    PostIDArray = [[NSMutableArray alloc]initWithArray:PostID];
    place_nameArray = [[NSMutableArray alloc]initWithArray:PlaceName];
    UserInfo_UrlArray = [[NSMutableArray alloc]initWithArray:UserInfoUrl];
    UserInfo_NameArray = [[NSMutableArray alloc]initWithArray:UserInfoName];
    TitleArray = [[NSMutableArray alloc]initWithArray:Title];
    MessageArray = [[NSMutableArray alloc]initWithArray:Message];
    DistanceArray = [[NSMutableArray alloc]initWithArray:Distance];
    SearchDisplayNameArray = [[NSMutableArray alloc]initWithArray:SearchDisplayName];
    TotalCommentArray = [[NSMutableArray alloc]initWithArray:TotalComment];
    TotalLikeArray = [[NSMutableArray alloc]initWithArray:TotalLike];
    SelfCheckLikeArray = [[NSMutableArray alloc]initWithArray:SelfCheckLike];
    
    [self InitNewView];
}

-(void)InitNewView{
    [ShowActivity startAnimating];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    heightcheck = 20;
    
    for (NSInteger i = 0; i < [PostIDArray count]; i++) {
        NSInteger TempHeight = heightcheck;
        int TempCountWhiteHeight = 0;
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 200);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 5;
        [MainScroll addSubview: TempButton];
        
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[LPhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(10, heightcheck, screenWidth - 20, 245);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        ShowImage.layer.cornerRadius = 5;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            ShowImage.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview:ShowImage];
        
        
        UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
        ShowOverlayImg.image = [UIImage imageNamed:@"FeedOverlay.png"];
        ShowOverlayImg.frame = CGRectMake(10, heightcheck, screenWidth - 20, 245);
        ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
        ShowOverlayImg.layer.masksToBounds = YES;
        ShowOverlayImg.layer.cornerRadius = 5;
        [MainScroll addSubview:ShowOverlayImg];
        
        UIButton *ClickToDetailButton = [[UIButton alloc]init];
        ClickToDetailButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 280);
        [ClickToDetailButton setTitle:@"" forState:UIControlStateNormal];
        ClickToDetailButton.backgroundColor = [UIColor clearColor];
        ClickToDetailButton.tag = i;
        [ClickToDetailButton addTarget:self action:@selector(ProductButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ClickToDetailButton];
        
        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(20, heightcheck + 10, 40, 40);
        // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius=20;
        ShowUserProfileImage.layer.borderWidth=3;
        ShowUserProfileImage.layer.masksToBounds = YES;
        ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            ShowUserProfileImage.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview:ShowUserProfileImage];
        
        UIButton *ClicktoOpenUserProfileButton = [[UIButton alloc]init];
        ClicktoOpenUserProfileButton.frame = CGRectMake(20, heightcheck + 10, 40, 40);
        [ClicktoOpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
        ClicktoOpenUserProfileButton.backgroundColor = [UIColor clearColor];
        ClicktoOpenUserProfileButton.tag = i;
        [ClicktoOpenUserProfileButton addTarget:self action:@selector(ExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ClicktoOpenUserProfileButton];
        
        
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(70, heightcheck + 10, 200, 40);
        ShowUserName.text = [UserInfo_NameArray objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor whiteColor];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [MainScroll addSubview:ShowUserName];
        
        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[DistanceArray objectAtIndex:i]];
        
        if ([TempDistanceString isEqualToString:@"0"]) {
            
        }else{
            CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
            int x_Nearby = [TempDistanceString intValue] / 1000;
            // NSLog(@"x_Nearby is %i",x_Nearby);
            
            UIImageView *ShowDistanceIcon = [[UIImageView alloc]init];
            NSString *FullShowLocatinString;
            if (x_Nearby < 10) {
                if (x_Nearby <= 1) {
                    ShowDistanceIcon.image = [UIImage imageNamed:@"Distance2Icon.png"];
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"1km"];//within
                }else{
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                    ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                }
                
            }else if(x_Nearby > 10 && x_Nearby < 30){
                ShowDistanceIcon.image = [UIImage imageNamed:@"Distance3Icon.png"];
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
            }else{
                ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[SearchDisplayNameArray objectAtIndex:i]];
                
            }
            ShowDistanceIcon.frame = CGRectMake(screenWidth - 60, heightcheck + 12, 40, 36);
            [MainScroll addSubview:ShowDistanceIcon];
            
            UILabel *ShowDistance = [[UILabel alloc]init];
            ShowDistance.frame = CGRectMake(screenWidth - 165, heightcheck + 10, 100, 40);
            ShowDistance.text = FullShowLocatinString;
            ShowDistance.textColor = [UIColor whiteColor];
            ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            ShowDistance.textAlignment = NSTextAlignmentRight;
            ShowDistance.backgroundColor = [UIColor clearColor];
            [MainScroll addSubview:ShowDistance];
        }
        
        
        heightcheck += 245 + 5;
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"location_icon.png"];
        ShowPin.frame = CGRectMake(20, heightcheck + 4, 9, 12);
        //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
        [MainScroll addSubview:ShowPin];
        
        UILabel *ShowAddress = [[UILabel alloc]init];
        ShowAddress.frame = CGRectMake(40, heightcheck, screenWidth - 80, 20);
        ShowAddress.text = [place_nameArray objectAtIndex:i];
        ShowAddress.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        ShowAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [MainScroll addSubview:ShowAddress];
        
        heightcheck += 25;
        TempCountWhiteHeight = 245 + 25;
        
        
        NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:i]];
        if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
            
        }else{
            UILabel *ShowTitle = [[UILabel alloc]init];
            ShowTitle.frame = CGRectMake(20, heightcheck, screenWidth - 40, 40);
            ShowTitle.text = TempGetStirng;
            ShowTitle.backgroundColor = [UIColor clearColor];
            ShowTitle.numberOfLines = 2;
            ShowTitle.textAlignment = NSTextAlignmentLeft;
            ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:ShowTitle];
            
            if([ShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ShowTitle.frame.size.height)
            {
                ShowTitle.frame = CGRectMake(20, heightcheck, screenWidth - 40,[ShowTitle sizeThatFits:CGSizeMake(screenWidth - 40, CGFLOAT_MAX)].height);
            }
            heightcheck += ShowTitle.frame.size.height + 10;
            
            TempCountWhiteHeight += ShowTitle.frame.size.height + 10;
        }
        
        NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:i]];
        //TempGetMessage = [TempGetMessage stringByDecodingXMLEntities];
        if ([TempGetMessage length] == 0 || [TempGetMessage isEqualToString:@""] || [TempGetMessage isEqualToString:@"(null)"]) {
            
        }else{
            UILabel *ShowMessage = [[UILabel alloc]init];
            ShowMessage.frame = CGRectMake(20, heightcheck, screenWidth - 40, 40);
            //  ShowMessage.text = TempGetMessage;
            NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",TempGetMessage];
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
            TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
            UILabel *ShowCaptionText = [[UILabel alloc]init];
            //  ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, 265, screenWidth - 30, 60);
            ShowCaptionText.numberOfLines = 0;
            ShowCaptionText.textColor = [UIColor whiteColor];
            // ShowCaptionText.text = [captionArray objectAtIndex:i];
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:TempGetStirngMessage];
            NSString *str = TempGetStirngMessage;
            NSError *error = nil;
            
            //I Use regex to detect the pattern I want to change color
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
            NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
            for (NSTextCheckingResult *match in matches) {
                NSRange wordRange = [match rangeAtIndex:0];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];
            }
            
            [ShowMessage setAttributedText:string];
            
            ShowMessage.backgroundColor = [UIColor clearColor];
            ShowMessage.numberOfLines = 3;
            ShowMessage.textAlignment = NSTextAlignmentLeft;
            ShowMessage.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            [MainScroll addSubview:ShowMessage];
            
            if([ShowMessage sizeThatFits:CGSizeMake(screenWidth - 40, CGFLOAT_MAX)].height!=ShowMessage.frame.size.height)
            {
                ShowMessage.frame = CGRectMake(20, heightcheck, screenWidth - 40,[ShowMessage sizeThatFits:CGSizeMake(screenWidth - 40, CGFLOAT_MAX)].height);
            }
            heightcheck += ShowMessage.frame.size.height + 10;
            TempCountWhiteHeight += ShowMessage.frame.size.height + 10;
            //   heightcheck += 30;
        }
        
        
        UIButton *LikeButton = [[UIButton alloc]init];
        LikeButton.frame = CGRectMake(40, heightcheck + 20, 24, 19);
        CheckLike = [[NSString alloc]initWithFormat:@"%@",[SelfCheckLikeArray objectAtIndex:i]];
        if ([CheckLike isEqualToString:@"0"]) {
            [LikeButton setImage:[UIImage imageNamed:@"like_icon.png"] forState:UIControlStateNormal];
            [LikeButton setImage:[UIImage imageNamed:@"PostLikeRed.png"] forState:UIControlStateSelected];
        }else{
            [LikeButton setImage:[UIImage imageNamed:@"PostLikeRed.png"] forState:UIControlStateNormal];
            [LikeButton setImage:[UIImage imageNamed:@"like_icon.png"] forState:UIControlStateSelected];
        }
        LikeButton.backgroundColor = [UIColor clearColor];
        LikeButton.tag = i;
      //  [LikeButton addTarget:self action:@selector(LikeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:LikeButton];
        
        
        UIButton *CommentButton = [[UIButton alloc]init];
        CommentButton.frame = CGRectMake(100, heightcheck + 20 ,23, 19);
        [CommentButton setImage:[UIImage imageNamed:@"comment_icon.png"] forState:UIControlStateNormal];
        CommentButton.backgroundColor = [UIColor clearColor];
        CommentButton.tag = i;
       // [CommentButton addTarget:self action:@selector(CommentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:CommentButton];
        
        UIButton *ShareButton = [[UIButton alloc]init];
        ShareButton.frame = CGRectMake(160, heightcheck + 20 ,19, 19);
        [ShareButton setImage:[UIImage imageNamed:@"share_icon.png"] forState:UIControlStateNormal];
        ShareButton.backgroundColor = [UIColor clearColor];
        ShareButton.tag = i;
       // [ShareButton addTarget:self action:@selector(ShareButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ShareButton];
        
//        CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:i]];;
//        UIButton *QuickCollectButton = [[UIButton alloc]init];
//        if ([CheckCollect isEqualToString:@"0"]) {
//            [QuickCollectButton setImage:[UIImage imageNamed:@"CollectBtn.png"] forState:UIControlStateNormal];
//            [QuickCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateSelected];
//        }else{
//            [QuickCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateNormal];
//            //[QuickCollectButton setImage:[UIImage imageNamed:@"CollectBtn.png"] forState:UIControlStateSelected];
//        }
//        [QuickCollectButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
//        [QuickCollectButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
//        QuickCollectButton.backgroundColor = [UIColor clearColor];
//        QuickCollectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        QuickCollectButton.frame = CGRectMake(screenWidth - 20 - 140, heightcheck + 4, 140, 50);
//        [QuickCollectButton addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        QuickCollectButton.tag = i;
//        [MainScroll addSubview:QuickCollectButton];
//        
//        UIButton *CollectButton = [[UIButton alloc]init];
//        [CollectButton setTitle:@"" forState:UIControlStateNormal];
//        CollectButton.backgroundColor = [UIColor clearColor];
//        CollectButton.frame = CGRectMake(screenWidth - 20 - 60, heightcheck + 10, 60, 37);
//        [CollectButton addTarget:self action:@selector(AddCollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        CollectButton.tag = i;
//        [MainScroll addSubview:CollectButton];
        
        
        heightcheck += 70;
        TempCountWhiteHeight += 70;
        
        TempButton.frame = CGRectMake(10, TempHeight, screenWidth - 20, TempCountWhiteHeight);
        
        heightcheck += 10;
    }
    [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck)];
    
    [ShowActivity stopAnimating];
}





-(void)InitView{
    [ShowActivity startAnimating];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    for (NSInteger i = 0; i < [PostIDArray count]; i++) {
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[LPhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(0, heightcheck + i, screenWidth, 245);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            ShowImage.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview:ShowImage];
        
        UIImageView *ImageShade = [[UIImageView alloc]init];
        ImageShade.frame = CGRectMake(0, heightcheck + i, screenWidth, 149);
        ImageShade.image = [UIImage imageNamed:@"ImageShade.png"];
        ImageShade.alpha = 0.5;
        [MainScroll addSubview:ImageShade];
        
        UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        SelectButton.frame = CGRectMake(0, heightcheck + i, screenWidth, 340);
        [SelectButton setTitle:@"" forState:UIControlStateNormal];
        SelectButton.tag = i;
        [SelectButton setBackgroundColor:[UIColor clearColor]];
        [SelectButton addTarget:self action:@selector(ProductButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:SelectButton];
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"FeedPin.png"];
        ShowPin.frame = CGRectMake(15, 259 + heightcheck + i, 8, 11);
        [MainScroll addSubview:ShowPin];
        
        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[DistanceArray objectAtIndex:i]];
        if ([TempDistanceString isEqualToString:@"0"]) {
            
        }else{
            CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
            int x_Nearby = [TempDistanceString intValue] / 1000;
            // NSLog(@"x_Nearby is %i",x_Nearby);
            
            NSString *FullShowLocatinString;
            if (x_Nearby < 100) {
                if (x_Nearby <= 1) {
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"within 1km"];
                }else{
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"within %.fkm",strFloat];
                }
                
            }else{
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[SearchDisplayNameArray objectAtIndex:i]];
                
            }
            
            //  NSLog(@"FullShowLocatinString is %@",FullShowLocatinString);
            
            UILabel *ShowDistance = [[UILabel alloc]init];
            ShowDistance.frame = CGRectMake(screenWidth - 115, 254 + heightcheck + i, 100, 20);
            ShowDistance.text = FullShowLocatinString;
            ShowDistance.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            ShowDistance.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            ShowDistance.textAlignment = NSTextAlignmentRight;
            ShowDistance.backgroundColor = [UIColor clearColor];
            [MainScroll addSubview:ShowDistance];
        }
        
        UILabel *ShowAddress = [[UILabel alloc]init];
        ShowAddress.frame = CGRectMake(30, 254 + heightcheck + i, screenWidth - 150, 20);
        ShowAddress.text = [place_nameArray objectAtIndex:i];
        ShowAddress.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        ShowAddress.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        ShowAddress.backgroundColor = [UIColor clearColor];
        [MainScroll addSubview:ShowAddress];
        
        heightcheck += 284;
        
        NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:i]];
        if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
        }else{
            UILabel *TempShowTitle = [[UILabel alloc]init];
            TempShowTitle.frame = CGRectMake(15, heightcheck + i, screenWidth - 30, 40);
            TempShowTitle.text = TempGetStirng;
            TempShowTitle.backgroundColor = [UIColor clearColor];
            TempShowTitle.numberOfLines = 2;
            TempShowTitle.textAlignment = NSTextAlignmentLeft;
            TempShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            TempShowTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            //            ShowTitle.attributedText = [NSAttributedString dvs_attributedStringWithString:TempGetStirng
            //                                                                                               tracking:100
            //                                                                                                   font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
            [MainScroll addSubview:TempShowTitle];
            
            if([TempShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=TempShowTitle.frame.size.height)
            {
                TempShowTitle.frame = CGRectMake(15, heightcheck + i, screenWidth - 30,[TempShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
            }
            heightcheck += TempShowTitle.frame.size.height + 10;
            
            //   heightcheck += 30;
        }
        
        NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:i]];
        TempGetMessage = [TempGetMessage stringByDecodingXMLEntities];
        if ([TempGetMessage length] == 0 || [TempGetMessage isEqualToString:@""] || [TempGetMessage isEqualToString:@"(null)"]) {
        }else{
            UILabel *ShowMessage = [[UILabel alloc]init];
            ShowMessage.frame = CGRectMake(15, heightcheck + i, screenWidth - 30, 40);
            //  ShowMessage.text = TempGetMessage;
            NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",TempGetMessage];
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
            TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
            UILabel *ShowCaptionText = [[UILabel alloc]init];
            //  ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, 265, screenWidth - 30, 60);
            ShowCaptionText.numberOfLines = 0;
            ShowCaptionText.textColor = [UIColor whiteColor];
            // ShowCaptionText.text = [captionArray objectAtIndex:i];
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:TempGetStirngMessage];
            NSString *str = TempGetStirngMessage;
            NSError *error = nil;
            
            //I Use regex to detect the pattern I want to change color
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
            NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
            for (NSTextCheckingResult *match in matches) {
                NSRange wordRange = [match rangeAtIndex:0];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];
            }
            
            [ShowMessage setAttributedText:string];
            
            ShowMessage.backgroundColor = [UIColor clearColor];
            ShowMessage.numberOfLines = 3;
            ShowMessage.textAlignment = NSTextAlignmentLeft;
            ShowMessage.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowMessage.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            //            ShowMessage.attributedText = [NSAttributedString dvs_attributedStringWithString:TempGetMessage
            //                                                                                 tracking:100
            //                                                                                     font:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
            [MainScroll addSubview:ShowMessage];
            
            if([ShowMessage sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ShowMessage.frame.size.height)
            {
                ShowMessage.frame = CGRectMake(15, heightcheck + i, screenWidth - 30,[ShowMessage sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
            }
            heightcheck += ShowMessage.frame.size.height + 10;
            //   heightcheck += 30;
        }
        
        
        
        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(15, heightcheck + i , 30, 30);
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius = 15;
        ShowUserProfileImage.layer.borderWidth=0;
        ShowUserProfileImage.layer.masksToBounds = YES;
        ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [MainScroll addSubview:ShowUserProfileImage];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            //NSLog(@"url is %@",url);
            ShowUserProfileImage.imageURL = url_NearbySmall;
        }
        
        
        UIButton *OpenProfileButton = [[UIButton alloc]initWithFrame:CGRectMake(15, heightcheck + i , 200, 30)];
        [OpenProfileButton setTitle:@"" forState:UIControlStateNormal];
        OpenProfileButton.tag = i;
        OpenProfileButton.backgroundColor = [UIColor clearColor];
        [OpenProfileButton addTarget:self action:@selector(ExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:OpenProfileButton];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(55, heightcheck + i, 200, 30);
        ShowUserName.text = [UserInfo_NameArray objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:15];
        [MainScroll addSubview:ShowUserName];
        
        NSString *CheckCommentTotal = [[NSString alloc]initWithFormat:@"%@",[TotalCommentArray objectAtIndex:i]];
        NSString *CheckLikeTotal = [[NSString alloc]initWithFormat:@"%@",[TotalLikeArray objectAtIndex:i]];
        NSString *CheckSelfLike = [[NSString alloc]initWithFormat:@"%@",[SelfCheckLikeArray objectAtIndex:i]];
        
        
        
        if ([CheckCommentTotal isEqualToString:@"0"]) {
            
            UIImageView *ShowCommentIcon = [[UIImageView alloc]init];
            ShowCommentIcon.image = [UIImage imageNamed:@"PostComment.png"];
            ShowCommentIcon.frame = CGRectMake(screenWidth - 23 - 15, heightcheck + i + 6 ,23, 19);
            //    ShowCommentIcon.backgroundColor = [UIColor redColor];
            [MainScroll addSubview:ShowCommentIcon];
            
            if ([CheckLikeTotal isEqualToString:@"0"]) {
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 23 - 15 - 23 - 20 , heightcheck + i + 6 ,23, 19);
                //   ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                [MainScroll addSubview:ShowLikesIcon];
            }else{
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                }else{
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLikeRed.png"];
                }
                // ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                //    ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 78 - 23, heightcheck + i + 6 ,23, 19);
                [MainScroll addSubview:ShowLikesIcon];
                
                UILabel *ShowLikeCount = [[UILabel alloc]init];
                ShowLikeCount.frame = CGRectMake(screenWidth - 78, heightcheck + i, 20, 30);
                ShowLikeCount.text = CheckLikeTotal;
                ShowLikeCount.textAlignment = NSTextAlignmentRight;
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikeCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                }else{
                    ShowLikeCount.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
                }
                //    ShowLikeCount.backgroundColor = [UIColor purpleColor];
                ShowLikeCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                [MainScroll addSubview:ShowLikeCount];
            }
        }else{
            
            UIImageView *ShowCommentIcon = [[UIImageView alloc]init];
            ShowCommentIcon.image = [UIImage imageNamed:@"PostComment.png"];
            ShowCommentIcon.frame = CGRectMake(screenWidth - 35 - 23 , heightcheck + i + 6 ,23, 19);
            //  ShowCommentIcon.backgroundColor = [UIColor redColor];
            [MainScroll addSubview:ShowCommentIcon];
            
            UILabel *ShowCommentCount = [[UILabel alloc]init];
            ShowCommentCount.frame = CGRectMake(screenWidth - 20 - 15, heightcheck + i, 20, 30);
            ShowCommentCount.text = CheckCommentTotal;
            ShowCommentCount.textAlignment = NSTextAlignmentRight;
            //   ShowCommentCount.backgroundColor = [UIColor redColor];
            ShowCommentCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowCommentCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            [MainScroll addSubview:ShowCommentCount];
            
            if ([CheckLikeTotal isEqualToString:@"0"]) {
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 101, heightcheck + i + 6 ,23, 19);
                // ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                [MainScroll addSubview:ShowLikesIcon];
            }else{
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                }else{
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLikeRed.png"];
                }
                // ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                //   ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 121, heightcheck + i + 6 ,23, 19);
                [MainScroll addSubview:ShowLikesIcon];
                
                UILabel *ShowLikeCount = [[UILabel alloc]init];
                ShowLikeCount.frame = CGRectMake(screenWidth - 98, heightcheck + i, 20, 30);
                ShowLikeCount.text = CheckLikeTotal;
                ShowLikeCount.textAlignment = NSTextAlignmentRight;
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikeCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                }else{
                    ShowLikeCount.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
                }
                // ShowLikeCount.backgroundColor = [UIColor purpleColor];
                ShowLikeCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                [MainScroll addSubview:ShowLikeCount];
            }
            
            
        }
        
        
        heightcheck += 55;
        
        UIImageView *ShowGradient = [[UIImageView alloc]init];
        ShowGradient.frame = CGRectMake(0, heightcheck + i, screenWidth, 25);
        ShowGradient.image = [UIImage imageNamed:@"FeedGradient.png"];
        [MainScroll addSubview:ShowGradient];
        heightcheck += 24;
        
        [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + i)];
    }
    
    
    [ShowActivity stopAnimating];
}
-(IBAction)ExpertsButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    NewUserProfileV2ViewController *ExpertsUserProfileView = [[NewUserProfileV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUserName:[UserInfo_NameArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)ProductButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *TempString = [PostIDArray objectAtIndex:getbuttonIDN];
    [defaults setObject:TempString forKey:@"NearbyRecommendationsIDN"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
}
@end
