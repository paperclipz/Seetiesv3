//
//  SuggestedCollectionsViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 05/11/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SuggestedCollectionsViewController.h"
#import "UrlDataClass.h"
#import "AsyncImageView.h"
@interface SuggestedCollectionsViewController ()<UIScrollViewDelegate>{

    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UILabel *ShowTitle;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_GetSuggestedCollectionData;
    
    NSString *GetNextPaging;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    NSInteger Offset;
    BOOL CheckLoad;
    int CheckFirstTimeLoad;
    int GetHeight;
    
    NSMutableArray *arrCollectionID;
    NSMutableArray *arrTitle;
    NSMutableArray *arrTotalCount;
    NSMutableArray *arrImageData;
    
    NSMutableArray *arrUsername;
    NSMutableArray *arrUserImage;
}

@end

@implementation SuggestedCollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self InitAllData];
    [self InitScreenSize];
    [self InitLanguage];
    
    [self GetSuggestedCollectionsData];
}
-(void)InitAllData{

    DataUrl = [[UrlDataClass alloc]init];
    
    MainScroll.delegate = self;
    
    CheckLoad = NO;
    TotalPage = 1;
    CurrentPage = 0;
    GetHeight = 0;
    CheckFirstTimeLoad = 0;
    DataCount = 0;
    Offset = 1;
}

-(void)InitScreenSize{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 114);
    ShowTitle.frame = CGRectMake(0, 20, screenWidth, 44);
}
-(void)InitLanguage{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight, screenWidth, 50);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_NOTIFICATION_HIDE" object:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
}
-(IBAction)BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)GetSuggestedCollectionsData{
    [ShowActivity startAnimating];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        
    NSString *FullString;
        
    if ([GetNextPaging isEqualToString:@""]|| [GetNextPaging length] == 0) {
        FullString = [[NSString alloc]initWithFormat:@"%@%@/collections/suggestions?offset=%ld&limit=10&token=%@",DataUrl.UserWallpaper_Url,Getuid,(long)Offset,GetExpertToken];
    }else{
        Offset += 10;
        DataCount += 10;
        FullString = GetNextPaging;
    }
        
    // NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/collections/suggestions?page=%li&token=%@",DataUrl.UserWallpaper_Url,Getuid,CurrentPage,GetExpertToken];
        
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"GetSuggestedCollectionData check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
    theConnection_GetSuggestedCollectionData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetSuggestedCollectionData start];
    if( theConnection_GetSuggestedCollectionData ){
        webData = [NSMutableData data];
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
    [ShowActivity stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_GetSuggestedCollectionData) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"Search Keyword return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //NSLog(@"theConnection_GetSuggestedCollectionData Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
       // NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
            NSDictionary *AllData = [res valueForKey:@"data"];
            
            NSDictionary *GetPaging = [AllData valueForKey:@"paging"];
            GetNextPaging = [[NSString alloc]initWithFormat:@"%@",[GetPaging objectForKey:@"next"]];
            NSLog(@"GetNextPaging is %@",GetNextPaging);
            
            if (CheckFirstTimeLoad == 0) {
                arrCollectionID = [[NSMutableArray alloc]init];
                arrTitle = [[NSMutableArray alloc]init];
                arrTotalCount = [[NSMutableArray alloc]init];
                arrImageData = [[NSMutableArray alloc]init];
                arrUsername = [[NSMutableArray alloc]init];
                arrUserImage = [[NSMutableArray alloc]init];
            }else{
            }
            
            NSDictionary *GetResultData = [AllData valueForKey:@"collections"];
            
            for (NSDictionary * dict in GetResultData) {
                NSString *collectionid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collection_id"]];
                [arrCollectionID addObject:collectionid];
                NSString *getname = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [arrTitle addObject:getname];
                NSString *collectioncount = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collection_posts_count"]];
                [arrTotalCount addObject:collectioncount];
            }
            
            NSLog(@"arrTitle is %@",arrTitle);
            
            NSDictionary *GetUserData = [GetResultData valueForKey:@"user_info"];
            for (NSDictionary * dict in GetUserData) {
                NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [arrUsername addObject:Getusername];
                NSString *getUserImage = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [arrUserImage addObject:getUserImage];
            }
            
            NSLog(@"arrUsername is %@",arrUsername);
            
            
            NSDictionary *CollectionPhotoData = [GetResultData valueForKey:@"collection_posts"];
            
            NSDictionary *PhotoData = [CollectionPhotoData valueForKey:@"posts"];
           // NSMutableArray *FullUrlArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in PhotoData) {
                NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict_ in dict) {
                    NSArray *TempPhotoData = [dict_ valueForKey:@"photos"];
                    for (NSDictionary * dict_ in TempPhotoData) {
                        NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"url"]];
                        
                        [UrlArray addObject:url];
                    }
                }
                NSString *resultImageUrl = [UrlArray componentsJoinedByString:@"^^^"];
                [arrImageData addObject:resultImageUrl];
            }
            
//            NSString *resultImageUrl = [FullUrlArray componentsJoinedByString:@","];
//            [arrImageData addObject:resultImageUrl];
            
            NSLog(@"arrImageData is %@",arrImageData);
            
            DataCount = DataTotal;
            DataTotal = [arrCollectionID count];
            if (CheckFirstTimeLoad == 0) {
                CheckFirstTimeLoad = 1;
            }else{
            }
            [self InitView];
            CheckLoad = NO;
            
        }else{
        
        }
        
    }
    
    [ShowActivity stopAnimating];
}

-(void)InitView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    for (NSInteger i = DataCount; i < DataTotal; i++) {
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(10 , 10 + i * 200, screenWidth - 20 ,190);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 10;
        TempButton.layer.borderWidth=1;
        TempButton.layer.masksToBounds = YES;
        TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
        [MainScroll addSubview: TempButton];
        
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[arrImageData objectAtIndex:i]];
        NSArray *SplitArray_TempImage = [TempImage componentsSeparatedByString:@"^^^"];
        
        NSLog(@"TempImage is %@",TempImage);
        NSLog(@"SplitArray_TempImage is %@",SplitArray_TempImage);
        
        AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
        ShowImage1.frame = CGRectMake(11 , 11 + i * 200 , ((screenWidth - 30) / 2) ,120);
        //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
        ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowImage1.layer.cornerRadius= 10;
        ShowImage1.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
        NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:0]];
        if ([ImageData length] == 0) {
            ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
            ShowImage1.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview:ShowImage1];

        AsyncImageView *ShowImage2 = [[AsyncImageView alloc]init];
        ShowImage2.frame = CGRectMake(14 + ((screenWidth - 20) / 2), 11 + i * 200 , ((screenWidth - 30) / 2) ,120);
        //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
        ShowImage2.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage2.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowImage2.layer.cornerRadius=10;
        ShowImage2.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage2];
        NSString *ImageData100 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:1]];
        if ([ImageData100 length] == 0) {
            ShowImage2.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData100];
            ShowImage2.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview:ShowImage2];

        
        UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
        ShowOverlayImg.image = [UIImage imageNamed:@"DealsAndRecommendationOverlay.png"];
        ShowOverlayImg.frame = CGRectMake(10 , 10 + i * 200, screenWidth - 20 ,120);
        ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
        ShowOverlayImg.layer.masksToBounds = YES;
        ShowOverlayImg.layer.cornerRadius = 10;
        [MainScroll addSubview:ShowOverlayImg];
//
//        
//        
//        UIButton *OpenCollectionButton = [[UIButton alloc]init];
//        OpenCollectionButton.frame = CGRectMake(10 + i * (screenWidth - 45), 50 , screenWidth - 50 ,190);
//        [OpenCollectionButton setTitle:@"" forState:UIControlStateNormal];
//        OpenCollectionButton.backgroundColor = [UIColor clearColor];
//        OpenCollectionButton.layer.cornerRadius = 10;
//        OpenCollectionButton.layer.borderWidth=1;
//        OpenCollectionButton.layer.masksToBounds = YES;
//        OpenCollectionButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
//        [OpenCollectionButton addTarget:self action:@selector(OpenCollectionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        OpenCollectionButton.tag = i;
//        [CollectionScrollview addSubview: OpenCollectionButton];
//        
        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(25 , 20 + i * 200, 40, 40);
        // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius=20;
        ShowUserProfileImage.layer.borderWidth=1;
        ShowUserProfileImage.layer.masksToBounds = YES;
        ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
        if ([ImageData1 length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
            ShowUserProfileImage.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview:ShowUserProfileImage];
//
//        UIButton *OpenUserProfileButton = [[UIButton alloc]init];
//        [OpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
//        OpenUserProfileButton.backgroundColor = [UIColor clearColor];
//        OpenUserProfileButton.frame = CGRectMake(25 + i * (screenWidth - 45), 51 + 10, screenWidth - 75 - 100, 40);
//        [OpenUserProfileButton addTarget:self action:@selector(CollectionUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        OpenUserProfileButton.tag = i;
//        [CollectionScrollview addSubview:OpenUserProfileButton];
//        
        NSString *usernameTemp = [[NSString alloc]initWithFormat:@"%@",[arrUsername objectAtIndex:i]];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(75 , 20 + i * 200, screenWidth - 75 - 100, 40);
        ShowUserName.text = usernameTemp;
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor whiteColor];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [MainScroll addSubview:ShowUserName];
//
//        UILabel *ShowCollectionTitle = [[UILabel alloc]init];
//        ShowCollectionTitle.frame = CGRectMake(25 + i * (screenWidth - 45), 180, screenWidth - 190 , 25);
//        ShowCollectionTitle.text = [SplitArray_Title objectAtIndex:i];
//        ShowCollectionTitle.backgroundColor = [UIColor clearColor];
//        ShowCollectionTitle.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
//        ShowCollectionTitle.textAlignment = NSTextAlignmentLeft;
//        ShowCollectionTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:16];
//        [CollectionScrollview addSubview:ShowCollectionTitle];
//        
//        
//        NSString *TempCount = [[NSString alloc]initWithFormat:@"%@ recommendations",[SplitArray_Count objectAtIndex:i]];
//        
//        UILabel *ShowCollectionCount = [[UILabel alloc]init];
//        ShowCollectionCount.frame = CGRectMake(25 + i * (screenWidth - 45), 205, screenWidth - 190, 25);
//        ShowCollectionCount.text = TempCount;
//        ShowCollectionCount.backgroundColor = [UIColor clearColor];
//        ShowCollectionCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//        ShowCollectionCount.textAlignment = NSTextAlignmentLeft;
//        ShowCollectionCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
//        [CollectionScrollview addSubview:ShowCollectionCount];
//        
//        
//        UIButton *QuickCollectButtonLocalQR = [[UIButton alloc]init];
//        [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateNormal];
//        [QuickCollectButtonLocalQR setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
//        [QuickCollectButtonLocalQR.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
//        QuickCollectButtonLocalQR.backgroundColor = [UIColor clearColor];
//        QuickCollectButtonLocalQR.frame = CGRectMake((screenWidth - 50 - 140) + i * (screenWidth - 45), 180, 140, 50);
//        //                    [QuickCollectButtonLocalQR addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        //                    QuickCollectButtonLocalQR.tag = i + 5000;
//        [CollectionScrollview addSubview:QuickCollectButtonLocalQR];
//        
//        
       MainScroll.contentSize = CGSizeMake(screenWidth, 200 + i * 200);
    }

}


@end
