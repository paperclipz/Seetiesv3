//
//  CollectionViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/18/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CollectionViewController.h"
#import "FeedV2DetailViewController.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 700)];
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    MainScroll.alwaysBounceVertical = YES;
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    MoreButton.frame = CGRectMake(screenWidth - 40, 20, 40, 44);
    MapButton.frame = CGRectMake(screenWidth - 80, 20, 40, 44);
    
    DownBarView.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
    DownBarView.hidden = YES;
    ShareButton.frame = CGRectMake(screenWidth - 130, 0, 120, 50);
    
    CheckLoad = NO;
    TotalPage = 1;
    CurrentPage = 0;
    GetHeight = 0;
    CheckFirstTimeLoad = 0;
    GetHeight = 0;
    
    if ([GetID length] ==0) {
        
    }else{
        [self GetCollectionData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight, screenWidth, 50);
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
}
-(IBAction)BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)GetCollectionID:(NSString *)ID_{

    GetID = ID_;
    NSLog(@"Get Collection ID is %@",GetID);
    [self GetCollectionData];
}
-(void)GetCollectionData{
    [ShowActivity startAnimating];
    if (CurrentPage == TotalPage) {
    }else{
        CurrentPage += 1;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *Getuid = [defaults objectForKey:@"Useruid"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/collections/%@?page=%li",DataUrl.UserWallpaper_Url,Getuid,GetID,CurrentPage];
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"GetCollectionData check postBack URL ==== %@",postBack);
        NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        // NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_CollectionData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_CollectionData start];
        if( theConnection_CollectionData ){
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
    [ShowActivity stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_CollectionData) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"Search Keyword return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"theConnection_CollectionData Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
            NSDictionary *ResData = [res valueForKey:@"data"];
            
            GetTitle = [[NSString alloc]initWithFormat:@"%@",[ResData objectForKey:@"name"]];
            GetDescription = [[NSString alloc]initWithFormat:@"%@",[ResData objectForKey:@"description"]];
            GetTags = [[NSString alloc]initWithFormat:@"%@",[ResData valueForKey:@"tags"]];
            if ([GetTags length] == 0 || [GetTags isEqualToString:@""] || [GetTags isEqualToString:@"(null)"] || GetTags == nil) {
            }else{
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"() \n"];
                GetTags = [[GetTags componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                NSArray *arr = [GetTags componentsSeparatedByString:@","];
                ArrHashTag = [[NSMutableArray alloc]initWithArray:arr];
            }
            
            NSDictionary *UserData = [ResData valueForKey:@"user_info"];
            GetUsername = [[NSString alloc]initWithFormat:@"%@",[UserData objectForKey:@"username"]];
            GetLocation = [[NSString alloc]initWithFormat:@"%@",[UserData objectForKey:@"location"]];
            GetUserProfile = [[NSString alloc]initWithFormat:@"%@",[UserData objectForKey:@"profile_photo"]];
            
            NSDictionary *PostsData = [ResData valueForKey:@"posts"];
            NSString *Temppage = [[NSString alloc]initWithFormat:@"%@",[PostsData objectForKey:@"page"]];
            NSString *Temptotal_page = [[NSString alloc]initWithFormat:@"%@",[PostsData objectForKey:@"total_page"]];
            
            CurrentPage = [Temppage intValue];
            TotalPage = [Temptotal_page intValue];
            
            if (CheckFirstTimeLoad == 0) {
                Content_arrImage = [[NSMutableArray alloc]init];
                Content_arrID = [[NSMutableArray alloc]init];
                Content_arrTitle = [[NSMutableArray alloc]init];
                Content_arrPlaceName = [[NSMutableArray alloc]init];
                Content_arrNote = [[NSMutableArray alloc]init];
                Content_arrID_arrDistance = [[NSMutableArray alloc]init];
                Content_arrID_arrDisplayCountryName = [[NSMutableArray alloc]init];
            }else{
            }
            
            
            NSDictionary *GetData = [PostsData valueForKey:@"data"];
            
            
            for (NSDictionary * dict in GetData) {
                NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                [Content_arrPlaceName addObject:PlaceName];
                NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                [Content_arrID addObject:PlaceID];
                NSString *notedate = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"note"]];
                [Content_arrNote addObject:notedate];
            }
            
            NSDictionary *titleData = [GetData valueForKey:@"title"];
            for (NSDictionary * dict in titleData) {
                if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                    [Content_arrTitle addObject:@""];
                }else{
                    NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                    NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                    NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                    NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                    NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                    if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                            if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                    if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                        [Content_arrTitle addObject:@""];
                                    }else{
                                        [Content_arrTitle addObject:PhilippinesTitle];
                                        
                                    }
                                }else{
                                    [Content_arrTitle addObject:IndonesianTitle];
                                    
                                }
                            }else{
                                [Content_arrTitle addObject:ThaiTitle];
                            }
                        }else{
                            [Content_arrTitle addObject:Title2];
                        }
                        
                    }else{
                        [Content_arrTitle addObject:Title1];
                        
                    }
                    
                }
            }

            NSDictionary *locationData = [GetData valueForKey:@"location"];
            for (NSDictionary * dict in locationData) {
                NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                [Content_arrID_arrDistance addObject:formatted_address];
                NSString *SearchDisplayName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"search_display_name"]];
                [Content_arrID_arrDisplayCountryName addObject:SearchDisplayName];
            }
            
            
//            NSDictionary *CollectionsData = [GetData valueForKey:@"collections"];
//            for (NSDictionary * dict in CollectionsData) {
//                for (NSDictionary * dict_ in dict) {
//                    NSDictionary *GetPostsData = [dict_ valueForKey:@"posts"];
//                  //  NSLog(@"GetPostsData note is %@",GetPostsData);
//                    for (NSDictionary * dict in GetPostsData) {
//                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"note"]];
//                        [Content_arrNote addObject:url];
//
//                    }
//                }
//            }
            
            
            
            NSArray *PhotoData = [GetData valueForKey:@"photos"];
            for (NSDictionary * dict in PhotoData) {
                NSMutableArray *captionArray = [[NSMutableArray alloc]init];
                NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict_ in dict) {
                    NSString *caption = [[NSString alloc]initWithFormat:@"%@",[dict_ objectForKey:@"caption"]];
                    [captionArray addObject:caption];
                    NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                    NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                    [UrlArray addObject:url];
                }
                NSString *result2 = [UrlArray componentsJoinedByString:@","];
                [Content_arrImage addObject:result2];
            }
//            NSLog(@"Content_arrImage is %@",Content_arrImage);
//            NSLog(@"Content_arrNote is %@",Content_arrNote);
//            NSLog(@"Content_arrTitle is %@",Content_arrTitle);
//            NSLog(@"Content_arrID_arrDistance is %@",Content_arrID_arrDistance);
//            NSLog(@"Content_arrID_arrDisplayCountryName is %@",Content_arrID_arrDisplayCountryName);
//            NSLog(@"Content_arrID is %@",Content_arrID);
//            NSLog(@"Content_arrPlaceName is %@",Content_arrPlaceName);
            
            DataCount = DataTotal;
            DataTotal = [Content_arrImage count];
            if (CheckFirstTimeLoad == 0) {
                [self InitView];
                
            }else{
                [self InitContentListView];
            }
            
            CheckLoad = NO;
            
        }
        [ShowActivity stopAnimating];
    }
}
-(void)InitView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *WhiteBackground = [[UIButton alloc]init];
    WhiteBackground.frame = CGRectMake(0, 0, screenWidth, 300);
    [WhiteBackground setTitle:@"" forState:UIControlStateNormal];
    WhiteBackground.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:WhiteBackground];
    
    

    NSString *ImageData;
    if ([Content_arrImage count] > 0){
        int randomIndex = arc4random()%[Content_arrImage count];
        ImageData = [Content_arrImage objectAtIndex:randomIndex];
    }
    NSArray *SplitArray = [ImageData componentsSeparatedByString:@","];
    NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
    AsyncImageView *BackgroundImg = [[AsyncImageView alloc]init];
    BackgroundImg.frame = CGRectMake(0, -20, screenWidth, 140);
    BackgroundImg.image = [UIImage imageNamed:@"NoImage.png"];
    BackgroundImg.contentMode = UIViewContentModeScaleAspectFill;
    BackgroundImg.layer.masksToBounds = YES;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:BackgroundImg];
    if ([FullImagesURL_First length] == 0) {
        BackgroundImg.image = [UIImage imageNamed:@"NoImage.png"];
    }else{
        NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
        BackgroundImg.imageURL = url_NearbySmall;
    }
    [MainScroll addSubview:BackgroundImg];
    
    UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
    ShowOverlayImg.image = [UIImage imageNamed:@"FeedOverlay.png"];
    ShowOverlayImg.frame = CGRectMake(0, -20, screenWidth, 140);
    ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
    ShowOverlayImg.layer.masksToBounds = YES;
    [MainScroll addSubview:ShowOverlayImg];
    
    AsyncImageView *UserImage = [[AsyncImageView alloc]init];
    UserImage.frame = CGRectMake((screenWidth /2) - 30, 90, 60, 60);
    UserImage.contentMode = UIViewContentModeScaleAspectFill;
    UserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    UserImage.layer.cornerRadius=30;
    UserImage.layer.borderWidth=0;
    UserImage.layer.masksToBounds = YES;
    UserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImage];
    NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",GetUserProfile];
    if ([FullImagesURL length] == 0) {
        UserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
    }else{
        NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
        UserImage.imageURL = url_NearbySmall;
    }
    [MainScroll addSubview:UserImage];

    
    GetHeight += 160;
    
    UILabel *TempShowTitle = [[UILabel alloc]init];
    TempShowTitle.frame = CGRectMake(20, GetHeight, screenWidth - 40, 30);
    TempShowTitle.text = GetTitle;
    TempShowTitle.backgroundColor = [UIColor clearColor];
    TempShowTitle.textAlignment = NSTextAlignmentCenter;
    TempShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    TempShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:18];
    [MainScroll addSubview:TempShowTitle];

    GetHeight += 30;
    
    NSString *TempString = [[NSString alloc]initWithFormat:@"by %@ • %@",GetUsername,GetLocation];
    
    UILabel *TempShowUserDetail = [[UILabel alloc]init];
    TempShowUserDetail.frame = CGRectMake(20, GetHeight, screenWidth - 40, 20);
    TempShowUserDetail.text = TempString;
    TempShowUserDetail.backgroundColor = [UIColor clearColor];
    TempShowUserDetail.textAlignment = NSTextAlignmentCenter;
    TempShowUserDetail.textColor = [UIColor colorWithRed:152.0f/255.0f green:152.0f/255.0f blue:152.0f/255.0f alpha:1.0f];
    TempShowUserDetail.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
    [MainScroll addSubview:TempShowUserDetail];
    
    GetHeight += 30;
    
    if ([GetDescription isEqualToString:@""] || [GetDescription isEqualToString:@"(null)"] || [GetDescription length] == 0) {
        
    }else{
        UILabel *ShowAboutText = [[UILabel alloc]init];
        ShowAboutText.frame = CGRectMake(30, GetHeight, screenWidth - 60, 30);
        ShowAboutText.text = GetDescription;
        ShowAboutText.numberOfLines = 0;
        ShowAboutText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowAboutText.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
        ShowAboutText.textAlignment = NSTextAlignmentCenter;
        [MainScroll addSubview:ShowAboutText];
        
        CGSize size = [ShowAboutText sizeThatFits:CGSizeMake(ShowAboutText.frame.size.width, CGFLOAT_MAX)];
        CGRect frame = ShowAboutText.frame;
        frame.size.height = size.height;
        ShowAboutText.frame = frame;
        
        GetHeight += ShowAboutText.frame.size.height + 10;
    }
    
    if ([GetTags isEqualToString:@""] || [GetTags isEqualToString:@"(null)"] || [GetTags length] == 0) {
        
    }else{
        
        UIScrollView *HashTagScroll = [[UIScrollView alloc]init];
        HashTagScroll.delegate = self;
        HashTagScroll.frame = CGRectMake(0, GetHeight, screenWidth, 50);
        HashTagScroll.backgroundColor = [UIColor whiteColor];
        [MainScroll addSubview:HashTagScroll];
        CGRect frame2 = {0,0};
        for (int i= 0; i < [ArrHashTag count]; i++) {
            UILabel *ShowHashTagText = [[UILabel alloc]init];
            ShowHashTagText.text = [ArrHashTag objectAtIndex:i];
            ShowHashTagText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            ShowHashTagText.textAlignment = NSTextAlignmentCenter;
            ShowHashTagText.backgroundColor = [UIColor whiteColor];
            ShowHashTagText.layer.cornerRadius = 5;
            ShowHashTagText.layer.borderWidth = 1;
            ShowHashTagText.layer.borderColor=[[UIColor grayColor] CGColor];
            
            NSString *Text = [ArrHashTag objectAtIndex:i];
            CGRect r = [Text boundingRectWithSize:CGSizeMake(200, 0)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]}
                                          context:nil];
            
            //NSLog(@"r ==== %f",r.size.width);
            
            //CGSize textSize = [ShowHashTagText.text sizeWithAttributes:@{NSFontAttributeName:[ShowHashTagText font]}];
            //   CGFloat textSize = ShowHashTagText.intrinsicContentSize.width;
            ShowHashTagText.frame = CGRectMake(30 + frame2.size.width, 15, r.size.width + 20, 20);
            frame2.size.width += r.size.width + 30;
            [HashTagScroll addSubview:ShowHashTagText];
            
            HashTagScroll.contentSize = CGSizeMake(30 + frame2.size.width , 50);
        }
        GetHeight += 50;
    }
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, GetHeight, screenWidth, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    Line01.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    [MainScroll addSubview:Line01];
    
    GetHeight += 1;
    
    ListButton = [[UIButton alloc]init];
    ListButton.frame = CGRectMake(0, GetHeight, (screenWidth / 2), 50);
    [ListButton setImage:[UIImage imageNamed:@"ListViewActive.png"] forState:UIControlStateNormal];
    ListButton.backgroundColor = [UIColor clearColor];
    [ListButton addTarget:self action:@selector(ListButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview:ListButton];
    
    GridButton = [[UIButton alloc]init];
    GridButton.frame = CGRectMake((screenWidth / 2), GetHeight, (screenWidth / 2), 50);
    [GridButton setImage:[UIImage imageNamed:@"GridViewInactive.png"] forState:UIControlStateNormal];
    GridButton.backgroundColor = [UIColor clearColor];
    [GridButton addTarget:self action:@selector(GridButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview:GridButton];
    
    UIButton *Line02 = [[UIButton alloc]init];
    Line02.frame = CGRectMake(0, GetHeight + 50, screenWidth, 1);
    [Line02 setTitle:@"" forState:UIControlStateNormal];
    Line02.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    [MainScroll addSubview:Line02];
    
    GetHeight += 51;
    
    WhiteBackground.frame = CGRectMake(0, 0, screenWidth, GetHeight);
    
    ListView = [[UIView alloc]init];
    ListView.frame = CGRectMake(0, GetHeight + 10, screenWidth, 400);
    ListView.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:ListView];
    
    GridView = [[UIView alloc]init];
    GridView.frame = CGRectMake(0, GetHeight + 10, screenWidth, 600);
    GridView.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:GridView];
    
    GridView.hidden = YES;
    CheckClick = 0;
    
    [self InitContentListView];
    
}
-(IBAction)ListButtonOnClick:(id)sender{
    [ListButton setImage:[UIImage imageNamed:@"ListViewActive.png"] forState:UIControlStateNormal];
    [GridButton setImage:[UIImage imageNamed:@"GridViewInactive.png"] forState:UIControlStateNormal];
    
    GridView.hidden = YES;
    ListView.hidden = NO;

    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + ListView.frame.size.height + 50;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
}
-(IBAction)GridButtonOnClick:(id)sender{
    [ListButton setImage:[UIImage imageNamed:@"ListViewInactive.png"] forState:UIControlStateNormal];
    [GridButton setImage:[UIImage imageNamed:@"GridViewActive.png"] forState:UIControlStateNormal];
    
    ListView.hidden = YES;
    
    if (CheckClick == 0) {
        CheckClick = 1;
        GridView.hidden = NO;
        [self InitGridViewData];
    }else{
        GridView.hidden = NO;
        CGSize contentSize = MainScroll.frame.size;
        contentSize.height = GetHeight + GridView.frame.size.height + 50;
        MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        MainScroll.contentSize = contentSize;

    }
    
    
}
-(void)InitContentListView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    int TempHeight = 0;
    if (CheckFirstTimeLoad == 0) {
        TempHeight = 10;
        
    }else{
    }
    
    if (TotalPage == 0) {
        TotalPage = 1;
    }
    
    

    for (NSInteger i = DataCount; i < DataTotal; i++) {
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(20, TempHeight, screenWidth - 40, 180);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        ShowImage.layer.cornerRadius = 5;
        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[Content_arrImage objectAtIndex:i]];
        NSArray *SplitArray = [ImageData componentsSeparatedByString:@","];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            ShowImage.imageURL = url_NearbySmall;
        }
        [ListView addSubview:ShowImage];
        
        NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[Content_arrTitle objectAtIndex:i]];
        if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
            
        }else{
            UILabel *ShowTitle = [[UILabel alloc]init];
            ShowTitle.frame = CGRectMake(30, TempHeight, screenWidth - 60, 20);
            ShowTitle.text = TempGetStirng;
            ShowTitle.backgroundColor = [UIColor clearColor];
            ShowTitle.textAlignment = NSTextAlignmentLeft;
            ShowTitle.textColor = [UIColor whiteColor];
            ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            [ListView addSubview:ShowTitle];

          //  TempHeight += ShowTitle.frame.size.height;

        }
        
        
        UIButton *ClickToDetailButton = [[UIButton alloc]init];
        ClickToDetailButton.frame = CGRectMake(20, TempHeight, screenWidth - 40, 180);
        [ClickToDetailButton setTitle:@"" forState:UIControlStateNormal];
        ClickToDetailButton.backgroundColor = [UIColor clearColor];
        ClickToDetailButton.tag = i;
        [ClickToDetailButton addTarget:self action:@selector(ClickToDetailButton:) forControlEvents:UIControlEventTouchUpInside];
        [ListView addSubview:ClickToDetailButton];
        
        
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"LocationpinIcon.png"];
        ShowPin.frame = CGRectMake(25, TempHeight + 20, 18, 18);
        [ListView addSubview:ShowPin];
        
        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[Content_arrID_arrDistance objectAtIndex:i]];
        NSString *FullShowLocatinString;
        if ([TempDistanceString isEqualToString:@"0"]) {
            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • %@",[Content_arrPlaceName objectAtIndex:i],[Content_arrID_arrDisplayCountryName objectAtIndex:i]];
        }else{
            CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
            int x_Nearby = [TempDistanceString intValue] / 1000;
            if (x_Nearby < 100) {
                if (x_Nearby <= 1) {
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • 1km",[Content_arrPlaceName objectAtIndex:i]];//within
                }else{
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • %.fkm",[Content_arrPlaceName objectAtIndex:i],strFloat];
                }
                
            }else{
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • %@",[Content_arrPlaceName objectAtIndex:i],[Content_arrID_arrDisplayCountryName objectAtIndex:i]];
                
            }

        }
        UILabel *ShowDistance = [[UILabel alloc]init];
        ShowDistance.frame = CGRectMake(50, TempHeight + 20, screenWidth - 100, 20);
        ShowDistance.text = FullShowLocatinString;
        ShowDistance.textColor = [UIColor whiteColor];
        ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowDistance.textAlignment = NSTextAlignmentLeft;
        ShowDistance.backgroundColor = [UIColor clearColor];
        [ListView addSubview:ShowDistance];
        
         TempHeight += 190;
        
        NSString *TempGetNote = [[NSString alloc]initWithFormat:@"%@",[Content_arrNote objectAtIndex:i]];
        if ([TempGetNote length] == 0 || [TempGetNote isEqualToString:@""] || [TempGetNote isEqualToString:@"(null)"]) {
           
            TempHeight += 20;
        }else{
            UILabel *ShowNoteData = [[UILabel alloc]init];
            ShowNoteData.frame = CGRectMake(20, TempHeight, screenWidth - 40, 40);
            ShowNoteData.text = TempGetNote;
            ShowNoteData.backgroundColor = [UIColor clearColor];
            ShowNoteData.numberOfLines = 2;
            ShowNoteData.textAlignment = NSTextAlignmentLeft;
            ShowNoteData.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowNoteData.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [ListView addSubview:ShowNoteData];
            
            if([ShowNoteData sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ShowNoteData.frame.size.height)
            {
                ShowNoteData.frame = CGRectMake(20, TempHeight, screenWidth - 40,[ShowNoteData sizeThatFits:CGSizeMake(screenWidth - 40, CGFLOAT_MAX)].height);
            }
            
            TempHeight += ShowNoteData.frame.size.height + 20;

        }
        
        
        
    }
    
    ListView.frame = CGRectMake(0, GetHeight + 10, screenWidth, TempHeight + 20);
    
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + ListView.frame.size.height;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    
    
   // [self InitGridViewData];
}
-(void)InitGridViewData{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    int heightcheck = 10;
    
    int TestWidth = screenWidth - 2;
    //NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 3;
    FinalWidth += 1;
    // NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 1;
    
    for (NSInteger i = DataCount; i < DataTotal; i++) {
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        ShowImage.frame = CGRectMake(0+(i % 3)*SpaceWidth, heightcheck + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[Content_arrImage objectAtIndex:i]];
        NSArray *SplitArray = [ImageData componentsSeparatedByString:@","];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            ShowImage.imageURL = url_NearbySmall;
        }
        [GridView addSubview:ShowImage];
        
        
        UIButton *ImageButton = [[UIButton alloc]init];
        [ImageButton setBackgroundColor:[UIColor clearColor]];
        [ImageButton setTitle:@"" forState:UIControlStateNormal];
        ImageButton.frame = CGRectMake(0+(i % 3)*SpaceWidth, heightcheck + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ImageButton.tag = i;
        [ImageButton addTarget:self action:@selector(ClickToDetailButton:) forControlEvents:UIControlEventTouchUpInside];
        [GridView addSubview:ImageButton];
        
        GridView.frame = CGRectMake(0, GetHeight, screenWidth, heightcheck + FinalWidth + (SpaceWidth * (CGFloat)(i /3)));
    }
    if (GridView.frame.size.height < screenHeight) {
        
        GridView.frame = CGRectMake(0, GetHeight, screenWidth, screenHeight);
    }
    
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + GridView.frame.size.height + FinalWidth;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
}

-(IBAction)ClickToDetailButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedV2DetailViewController *vc = [[FeedV2DetailViewController alloc] initWithNibName:@"FeedV2DetailViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc GetPostID:[Content_arrID objectAtIndex:getbuttonIDN]];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == MainScroll) {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height)
        {
            // we are at the end
            if (CheckLoad == YES) {
                
            }else{
                CheckLoad = YES;
                if (CurrentPage == TotalPage) {
                    
                }else{
                    
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    [MainScroll setContentSize:CGSizeMake(screenWidth, MainScroll.contentSize.height + 150)];
                    UIActivityIndicatorView *  activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((screenWidth/2) - 15, GetHeight + 40, 30, 30)];
                    [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    [activityindicator1 setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
                    [MainScroll addSubview:activityindicator1];
                    [activityindicator1 startAnimating];
                    [self GetCollectionData];
                }
                
            }
        }
        
    }
}
-(IBAction)ShareButtonOnClick:(id)sender{
}
-(IBAction)ShareLinkButtonOnClick:(id)sender{
}
-(IBAction)TranslateButtonOnClick:(id)sender{
}
@end
