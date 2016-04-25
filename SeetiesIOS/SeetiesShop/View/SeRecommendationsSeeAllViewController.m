//
//  SeRecommendationsSeeAllViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 15/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeRecommendationsSeeAllViewController.h"
#import "FeedV2DetailViewController.h"
#import "ProfileViewController.h"
#import "AddCollectionDataViewController.h"
#import "UrlDataClass.h"
#import "UIActivityViewController+Extension.h"
#import "CustomItemSource.h"

@interface SeRecommendationsSeeAllViewController ()<UIScrollViewDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    int heightcheck;
    NSString *CheckLike;
    NSString *CheckCollect;
    NSString *SendLikePostID;
    NSString *GetPostID;
    
    //old way
    NSURLConnection *theConnection_likes;
    NSURLConnection *theConnection_QuickCollect;
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
}
@property (strong, nonatomic)NSMutableArray* arrPostListing;
@property (strong, nonatomic)NSMutableArray* arrPostLike;
@property (strong, nonatomic)NSMutableArray* arrPostCollect;
@property(nonatomic,strong)NSString* seetiesID;
@property(nonatomic,strong)NSString* placeID;
@property(nonatomic,strong)NSString* postID;
@property(nonatomic,strong)ProfilePostModel* userProfilePostModel;

@property (nonatomic,strong)FeedV2DetailViewController* PostDetailViewController;
@property(nonatomic,strong)ProfileViewController* profileViewController;
@end

@implementation SeRecommendationsSeeAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSelfView];
    
}
-(void)initSelfView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowTitle.frame = CGRectMake(0, 20, screenWidth, 44);
    ShowTitle.text = LocalisedString(@"Recommendations");
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
    
    DataUrl = [[UrlDataClass alloc]init];
    
    self.arrPostLike = [[NSMutableArray alloc]init];
    self.arrPostCollect = [[NSMutableArray alloc]init];
    
    heightcheck = 10;
    
    [self initData:self.seetiesID PlaceID:self.placeID PostID:self.postID];
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
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(IBAction)BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID;
{
    
    self.seetiesID = seetiesID;
    self.postID = postID;
    self.placeID = placeID;

    [self requestServerForSeetiShopRecommendations];
    
}
-(void)requestServerForSeetiShopRecommendations
{
    [ShowActivity startAnimating];
    //  NSDictionary* param;
//    NSString* appendString = @"56397e301c4d5be92e8b4711/posts";
//    NSDictionary* dict = @{@"limit":@"10",
//                           @"offset":@"1",
//                           };
    NSDictionary* dict;
    NSString* appendString;
    if (![Utils stringIsNilOrEmpty:self.seetiesID]) {
        
        dict = @{@"token":[Utils getAppToken],
                 @"limit":@"10",
                 @"offset":@"1",
                 };
        appendString = [[NSString alloc]initWithFormat:@"%@/posts",self.seetiesID];
        
    }
    else{
        
        dict = @{@"token":[Utils getAppToken],
                 @"limit":@"10",
                 @"offset":@"1",
                 };
        
        appendString = [[NSString alloc]initWithFormat:@"%@/posts",self.placeID];
        
    }
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetSeetoShopRecommendations parameter:dict appendString:appendString success:^(id object) {

        self.userProfilePostModel = [[ConnectionManager dataManager]userProfilePostModel];
        self.arrPostListing = nil;
        [self.arrPostListing addObjectsFromArray:self.userProfilePostModel.userPostData.posts];

        [self InitRecommendationView];
        [ShowActivity stopAnimating];
    } failure:^(id object) {
        
        
    }];
    
}
-(NSMutableArray*)arrPostListing
{
    if (!_arrPostListing) {
        _arrPostListing = [NSMutableArray new];
    }
    
    return _arrPostListing;
}
-(void)InitRecommendationView{
    SLog(@"run how many time?");
    
    [self.arrPostLike removeAllObjects];
    [self.arrPostCollect removeAllObjects];
    
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    heightcheck = 10;

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    for (int i = 0; i < [self.arrPostListing count]; i++) {
        DraftModel* model = self.arrPostListing[i];
        [self.arrPostLike addObject:model.like?@"1":@"0"];
        [self.arrPostCollect addObject:model.collect];
        
        NSLog(@"self.arrPostLike == %@",self.arrPostLike);
        NSLog(@"self.arrPostCollect == %@",self.arrPostCollect);
        
        NSInteger TempHeight = heightcheck;
        int TempCountWhiteHeight = 0;
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 200);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 5;
        [MainScroll addSubview: TempButton];
        
        PhotoModel* photoModel = model.arrPhotos[0];
        
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;

        float oldWidth = photoModel.imageWidth;
        float scaleFactor = screenWidth / oldWidth;
        float newHeight_ = photoModel.imageHeight * scaleFactor;
        int resultHeight = (int)newHeight_;
        ShowImage.frame = CGRectMake(10, heightcheck, screenWidth - 20, resultHeight);
        ShowImage.layer.masksToBounds = YES;
        ShowImage.layer.cornerRadius = 5;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",photoModel.imageURL];
        if ([ImageData length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
            ShowImage.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview: ShowImage];
        
        
        UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
        ShowOverlayImg.image = [UIImage imageNamed:@"FeedOverlay.png"];
        ShowOverlayImg.frame = CGRectMake(10, heightcheck, screenWidth - 20, resultHeight);
        ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
        ShowOverlayImg.layer.masksToBounds = YES;
        ShowOverlayImg.layer.cornerRadius = 5;
        [MainScroll addSubview:ShowOverlayImg];
        
        UIButton *ClickToDetailButton = [[UIButton alloc]init];
        ClickToDetailButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, resultHeight);
        [ClickToDetailButton setTitle:@"" forState:UIControlStateNormal];
        ClickToDetailButton.backgroundColor = [UIColor clearColor];
        ClickToDetailButton.tag = i;
        [ClickToDetailButton addTarget:self action:@selector(ClickToDetailButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ClickToDetailButton];
        
        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(25, heightcheck + 15, 40, 40);
        // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius=20;
        ShowUserProfileImage.layer.borderWidth=1;
        ShowUserProfileImage.layer.masksToBounds = YES;
        ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",model.user_info.profile_photo_images];
        if ([FullImagesURL length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            ShowUserProfileImage.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview:ShowUserProfileImage];
        
        UIButton *ClicktoOpenUserProfileButton = [[UIButton alloc]init];
        ClicktoOpenUserProfileButton.frame = CGRectMake(20, heightcheck + 15, 40, 40);
        [ClicktoOpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
        ClicktoOpenUserProfileButton.backgroundColor = [UIColor clearColor];
        ClicktoOpenUserProfileButton.tag = i;
        [ClicktoOpenUserProfileButton addTarget:self action:@selector(OpenUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ClicktoOpenUserProfileButton];
        
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(75, heightcheck + 15, 200, 40);
        ShowUserName.text = model.user_info.name;
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor whiteColor];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [MainScroll addSubview:ShowUserName];
        
        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",model.distance];
        
        
        if ([TempDistanceString isEqualToString:@"-1"]) {
            
        }else{
            CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
            int x_Nearby = [TempDistanceString intValue] / 1000;
            // NSLog(@"x_Nearby is %i",x_Nearby);
            
            UIImageView *ShowDistanceIcon = [[UIImageView alloc]init];
            NSString *FullShowLocatinString;
            int Checkhide = 0;
            if (x_Nearby <= 3) {
                ShowDistanceIcon.image = [UIImage imageNamed:@"Distance2Icon.png"];
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"1km"];//within
            }else if(x_Nearby > 4 && x_Nearby < 300){
                if (x_Nearby < 15) {
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                    ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                }else{
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",model.location.search_display_name];
                    ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                }
            }else if(x_Nearby > 301 && x_Nearby < 3000){
                ShowDistanceIcon.image = [UIImage imageNamed:@"Distance3Icon.png"];
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",model.location.search_display_name];
            }else if(x_Nearby > 3001 && x_Nearby < 15000){
                ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",model.location.search_display_name];
            }else{
                Checkhide = 1;
                // ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",model.location.search_display_name];
            }
            
            if (Checkhide == 1) {
                UILabel *ShowDistance = [[UILabel alloc]init];
                ShowDistance.frame = CGRectMake(screenWidth - 125, heightcheck + 15, 100, 40);
                ShowDistance.text = FullShowLocatinString;
                ShowDistance.textColor = [UIColor whiteColor];
                ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                ShowDistance.textAlignment = NSTextAlignmentRight;
                ShowDistance.backgroundColor = [UIColor clearColor];
                [MainScroll addSubview:ShowDistance];
            }else{
                ShowDistanceIcon.frame = CGRectMake(screenWidth - 60, heightcheck + 17, 40, 36);
                [MainScroll addSubview:ShowDistanceIcon];
                
                UILabel *ShowDistance = [[UILabel alloc]init];
                ShowDistance.frame = CGRectMake(screenWidth - 165, heightcheck + 15, 100, 40);
                ShowDistance.text = FullShowLocatinString;
                ShowDistance.textColor = [UIColor whiteColor];
                ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                ShowDistance.textAlignment = NSTextAlignmentRight;
                ShowDistance.backgroundColor = [UIColor clearColor];
                [MainScroll addSubview:ShowDistance];
            }
            
            
        }
        
        
        heightcheck += resultHeight + 20;
        TempCountWhiteHeight += resultHeight + 20;
        
        NSString* currentlangCode = [Utils getLanguageCodeFromLocale:[[LanguageManager sharedLanguageManager]getSelectedLocale].languageCode];
        NSString *TestTitle;
        NSString *TestDetail;
        if (![model.arrPost isNull]) {
            
            Post* postModel;
            for (int i = 0 ; i< model.arrPost.count; i++) {
                postModel = model.arrPost[i];
                
                if ([postModel.language isEqualToString:currentlangCode]) {
                    TestTitle = model.contents[currentlangCode][@"title"];
                    TestDetail = model.contents[currentlangCode][@"message"];
                    break;
                }
            }
            postModel = model.arrPost[0];
            
            TestTitle = postModel.title;
            TestDetail = postModel.message;
        }
        
        if ([TestTitle length] == 0 || [TestTitle isEqualToString:@""] || [TestTitle isEqualToString:@"(null)"]) {
            
        }else{
            UILabel *ShowPostTitle = [[UILabel alloc]init];
            ShowPostTitle.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40);
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.minimumLineHeight = 21.0f;
            paragraph.maximumLineHeight = 21.0f;
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:TestTitle attributes:@{NSParagraphStyleAttributeName: paragraph}];
            ShowPostTitle.attributedText = attributedString;
            ShowPostTitle.backgroundColor = [UIColor clearColor];
            ShowPostTitle.numberOfLines = 2;
            ShowPostTitle.textAlignment = NSTextAlignmentLeft;
            ShowPostTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowPostTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:17];
            [MainScroll addSubview:ShowPostTitle];
            
            if([ShowPostTitle sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowPostTitle.frame.size.height)
            {
                ShowPostTitle.frame = CGRectMake(25, heightcheck, screenWidth - 50,[ShowPostTitle sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
            }
            heightcheck += ShowPostTitle.frame.size.height + 5;
            
            TempCountWhiteHeight += ShowPostTitle.frame.size.height + 5;
        }
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"LocationpinIcon.png"];
        ShowPin.frame = CGRectMake(20, heightcheck, 18, 18);
        //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
        [MainScroll addSubview:ShowPin];
        
        UILabel *ShowAddress = [[UILabel alloc]init];
        ShowAddress.frame = CGRectMake(40, heightcheck, screenWidth - 80, 20);
        ShowAddress.text = model.place_name;
        ShowAddress.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        [MainScroll addSubview:ShowAddress];
        
        heightcheck += 30;
        TempCountWhiteHeight += 30;
        
        if ([TestDetail length] == 0 || [TestDetail isEqualToString:@""] || [TestDetail isEqualToString:@"(null)"]) {
            
        }else{
            UILabel *ShowMessage = [[UILabel alloc]init];
            ShowMessage.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40);
            //  ShowMessage.text = TempGetMessage;
            NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",TestDetail];
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
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.minimumLineHeight = 21.0f;
            paragraph.maximumLineHeight = 21.0f;
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName: paragraph}];
            ShowMessage.attributedText = attributedString;
            //[ShowMessage setAttributedText:string];
            
            ShowMessage.backgroundColor = [UIColor clearColor];
            ShowMessage.numberOfLines = 3;
            ShowMessage.textAlignment = NSTextAlignmentLeft;
            ShowMessage.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            [MainScroll addSubview:ShowMessage];
            
            if([ShowMessage sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowMessage.frame.size.height)
            {
                ShowMessage.frame = CGRectMake(25, heightcheck, screenWidth - 50,[ShowMessage sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
            }
            heightcheck += ShowMessage.frame.size.height + 5;
            TempCountWhiteHeight += ShowMessage.frame.size.height + 5;
            //   heightcheck += 30;
        }
        
        
        UIButton *LikeButton = [[UIButton alloc]init];
        LikeButton.frame = CGRectMake(20, heightcheck + 4, 37, 37);

        if (model.like) {
            [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateSelected];
        }else{
            [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateSelected];
        }
        LikeButton.backgroundColor = [UIColor clearColor];
        LikeButton.tag = i;
        [LikeButton addTarget:self action:@selector(LikeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:LikeButton];
        
        UIButton *ShareButton = [[UIButton alloc]init];
        ShareButton.frame = CGRectMake(70, heightcheck + 4 ,37, 37);//3 button size 122, heightcheck + 4 ,37, 37
        [ShareButton setImage:[UIImage imageNamed:@"ShareToIcon.png"] forState:UIControlStateNormal];
        ShareButton.backgroundColor = [UIColor clearColor];
        ShareButton.tag = i;
        [ShareButton addTarget:self action:@selector(ShareButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ShareButton];
        
        CheckCollect = [[NSString alloc]initWithFormat:@"%@",model.collect];;
        UIButton *QuickCollectButton = [[UIButton alloc]init];
        if ([CheckCollect isEqualToString:@"0"]) {
            [QuickCollectButton setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateNormal];
            [QuickCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateSelected];
        }else{
            [QuickCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateNormal];
            //[QuickCollectButton setImage:[UIImage imageNamed:@"CollectBtn.png"] forState:UIControlStateSelected];
        }
        [QuickCollectButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [QuickCollectButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
        QuickCollectButton.backgroundColor = [UIColor clearColor];
        QuickCollectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        QuickCollectButton.frame = CGRectMake(screenWidth - 20 - 140, heightcheck - 5, 140, 50);
        [QuickCollectButton addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        QuickCollectButton.tag = i ;
        [MainScroll addSubview:QuickCollectButton];
        
        UIButton *CollectButton = [[UIButton alloc]init];
        [CollectButton setTitle:@"" forState:UIControlStateNormal];
        CollectButton.backgroundColor = [UIColor clearColor];
        CollectButton.frame = CGRectMake(screenWidth - 20 - 60, heightcheck - 5, 60, 37);
        [CollectButton addTarget:self action:@selector(AddCollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        CollectButton.tag = i;
        [MainScroll addSubview:CollectButton];
        
        
        heightcheck += 55;
        TempCountWhiteHeight += 55;
        
        TempButton.frame = CGRectMake(10, TempHeight, screenWidth - 20, TempCountWhiteHeight);
        
        heightcheck += 10;
    }
    
    [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + 10)];
}
-(IBAction)ClickToDetailButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    DraftModel* model = self.arrPostListing[getbuttonIDN];

    _PostDetailViewController = nil;
    [self.navigationController pushViewController:self.PostDetailViewController animated:YES onCompletion:^{
        [_PostDetailViewController GetPostID:model.post_id];
        
    }];
}
-(IBAction)OpenUserProfileOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    DraftModel* model = self.arrPostListing[getbuttonIDN];

    _profileViewController = nil;
    [self.navigationController pushViewController:self.profileViewController animated:YES onCompletion:^{
        [self.profileViewController initDataWithUserID:model.user_info.uid];
    }];
}
-(IBAction)LikeButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    DraftModel* model = self.arrPostListing[getbuttonIDN];
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    CheckLike = [[NSString alloc]initWithFormat:@"%@",model.like];
    SendLikePostID = [[NSString alloc]initWithFormat:@"%@",model.post_id];

    if ([CheckLike isEqualToString:@"0"]) {
        NSLog(@"send like to server");
        [self SendPostLike];
        [self.arrPostLike replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
    }else{
        NSLog(@"send unlike to server");
        [self GetUnLikeData];
        [self.arrPostLike replaceObjectAtIndex:getbuttonIDN withObject:@"0"];
    }

}
-(IBAction)ShareButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    DraftModel* model = self.arrPostListing[getbuttonIDN];
    
    NSString* currentlangCode = [Utils getLanguageCodeFromLocale:[[LanguageManager sharedLanguageManager]getSelectedLocale].languageCode];
    NSString *TestTitle;
    NSString *TestDetail;
    if (![model.arrPost isNull]) {
        
        Post* postModel;
        for (int i = 0 ; i< model.arrPost.count; i++) {
            postModel = model.arrPost[i];
            
            if ([postModel.language isEqualToString:currentlangCode]) {
                TestTitle = model.contents[currentlangCode][@"title"];
                TestDetail = model.contents[currentlangCode][@"message"];
                break;
            }
        }
        postModel = model.arrPost[0];
        
        TestTitle = postModel.title;
        TestDetail = postModel.message;
    }
    PhotoModel* photoModel = model.arrPhotos[0];
    
    //New Sharing Screen
    CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
    
    dataToPost.title = TestTitle;
    dataToPost.shareID = model.post_id;
    dataToPost.shareType = ShareTypePost;
    dataToPost.postImageURL = photoModel.imageURL;
    
    [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];

}
-(IBAction)CollectButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    DraftModel* model = self.arrPostListing[getbuttonIDN];
    PhotoModel* photoModel = model.arrPhotos[0];
    
    GetPostID = [[NSString alloc]initWithFormat:@"%@",model.post_id];
    CheckCollect = [[NSString alloc]initWithFormat:@"%@",model.collect];
    
    if ([CheckCollect isEqualToString:@"0"]) {
        [self.arrPostCollect replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
        UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
        buttonWithTag1.selected = !buttonWithTag1.selected;
        
        [self SendQuickCollect];
    }else{
        AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
        [self presentViewController:AddCollectionDataView animated:YES completion:nil];
        //[self.view.window.rootViewController presentViewController:AddCollectionDataView animated:YES completion:nil];
        [AddCollectionDataView GetPostID:model.post_id GetImageData:photoModel.imageURL];
    }
}
-(IBAction)AddCollectButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    DraftModel* model = self.arrPostListing[getbuttonIDN];
    PhotoModel* photoModel = model.arrPhotos[0];
    
    AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
    [self presentViewController:AddCollectionDataView animated:YES completion:nil];
    //[self.view.window.rootViewController presentViewController:AddCollectionDataView animated:YES completion:nil];
    [AddCollectionDataView GetPostID:model.post_id GetImageData:photoModel.imageURL];
}


-(FeedV2DetailViewController*)PostDetailViewController
{
    if (!_PostDetailViewController) {
        _PostDetailViewController = [FeedV2DetailViewController new];
    }
    return _PostDetailViewController;
}
-(ProfileViewController*)profileViewController
{
    if(!_profileViewController)
        _profileViewController = [ProfileViewController new];
    
    return _profileViewController;
}

-(void)GetUnLikeData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/like?token=%@",DataUrl.UserWallpaper_Url,SendLikePostID,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
    theConnection_likes = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_likes) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
    
}
-(void)SendPostLike{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/like",DataUrl.UserWallpaper_Url,SendLikePostID];
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
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_likes = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_likes) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)SendQuickCollect{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetUseruid = [defaults objectForKey:@"Useruid"];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/0/collect",DataUrl.UserWallpaper_Url,GetUseruid];
    NSLog(@"Send Quick Collection urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *dataString = [[NSString alloc]initWithFormat:@"token=%@&posts[0][id]=%@",GetExpertToken,GetPostID];
    
    NSData *postBodyData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBodyData];
    
    theConnection_QuickCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_QuickCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_likes) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Send post like return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            //NSDictionary *GetAllData = [res valueForKey:@"data"];
            // NSLog(@"GetAllData is %@",GetAllData);
            
        }
    }else if(connection == theConnection_QuickCollect){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Quick Collection return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success add to Collections" type:TSMessageNotificationTypeSuccess];
        }
    }


}
@end
