//
//  CollectionViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/18/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CollectionViewController.h"

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
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight - 50);
    MainScroll.alwaysBounceVertical = YES;
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    MoreButton.frame = CGRectMake(screenWidth - 40, 20, 40, 44);
    MapButton.frame = CGRectMake(screenWidth - 80, 20, 40, 44);
    
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
        NSLog(@"check postBack URL ==== %@",postBack);
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
            }else{
            }
            NSDictionary *GetData = [PostsData valueForKey:@"data"];
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
            NSLog(@"Content_arrImage is %@",Content_arrImage);
            
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
    
    AsyncImageView *BackgroundImg = [[AsyncImageView alloc]init];
    BackgroundImg.frame = CGRectMake(0, -20, screenWidth, 140);
    BackgroundImg.image = [UIImage imageNamed:@"NoImage.png"];
    BackgroundImg.contentMode = UIViewContentModeScaleAspectFill;
    BackgroundImg.layer.masksToBounds = YES;
    [MainScroll addSubview:BackgroundImg];
    
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
        UserImage.image = [UIImage imageNamed:@"avatar.png"];
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
        ShowAboutText.textAlignment = NSTextAlignmentLeft;
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
    [ListButton setImage:[UIImage imageNamed:@"listview_selected.png"] forState:UIControlStateNormal];
    ListButton.backgroundColor = [UIColor clearColor];
    [ListButton addTarget:self action:@selector(ListButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview:ListButton];
    
    GridButton = [[UIButton alloc]init];
    GridButton.frame = CGRectMake((screenWidth / 2), GetHeight, (screenWidth / 2), 50);
    [GridButton setImage:[UIImage imageNamed:@"gridview_unselect.png"] forState:UIControlStateNormal];
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
    
    
    [self InitContentListView];
    
}
-(IBAction)ListButtonOnClick:(id)sender{
    [ListButton setImage:[UIImage imageNamed:@"listview_selected.png"] forState:UIControlStateNormal];
    [GridButton setImage:[UIImage imageNamed:@"gridview_unselect.png"] forState:UIControlStateNormal];
    
    GridView.hidden = YES;
    ListView.hidden = NO;
}
-(IBAction)GridButtonOnClick:(id)sender{
    [ListButton setImage:[UIImage imageNamed:@"listview_unselect.png"] forState:UIControlStateNormal];
    [GridButton setImage:[UIImage imageNamed:@"gridview_selected.png"] forState:UIControlStateNormal];
    
    GridView.hidden = NO;
    ListView.hidden = YES;
}
-(void)InitContentListView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    int TempHeight = 10;

    for (NSInteger i = DataCount; i < DataTotal; i++) {
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(20, TempHeight, screenWidth - 40, 100);
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
        
        TempHeight += 120;
    }
    
    ListView.frame = CGRectMake(0, GetHeight + 10, screenWidth, TempHeight + 120);
    
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + ListView.frame.size.height + 50;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
}
@end
