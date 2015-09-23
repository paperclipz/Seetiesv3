//
//  Explore2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "Explore2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "AsyncImageView.h"
#import "OpenWebViewController.h"
#import "SearchResultV2ViewController.h"
#import "ExploreCountryV2ViewController.h"
#import "SearchViewV2Controller.h"
@interface Explore2ViewController ()<UISearchBarDelegate>
{
    IBOutlet UIScrollView *ibScrollViewCountry;
    IBOutlet UIImageView *BarImage;
    IBOutlet UISearchBar *mySearchBar;
    IBOutlet UIButton *MainLine;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UITableView *SearchTblView;

}
@property(nonatomic,strong)ExploreCountryModels* exploreCountryModels;

@end

@implementation Explore2ViewController

-(void)initSelfView
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    mySearchBar.delegate = self;
    mySearchBar.tintColor = [UIColor redColor];
    mySearchBar.barTintColor = [UIColor clearColor];
    [mySearchBar setBackgroundImage:[[UIImage alloc]init]];
    
    SearchButton.frame = CGRectMake(0, 20, screenWidth, 44);
    
    //CountriesScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 114);
    ibScrollViewCountry.frame = CGRectMake(0, 64, screenWidth, screenHeight - 114);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);

}
-(IBAction)TryAgainButton:(id)sender{
    [self GetExploreDataFromServer];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //init no connection data
    NoConnectionView.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64 - 50);
    ShowNoConnectionText.frame = CGRectMake((screenWidth / 2) - 100, 215, 200, 60);
    TryAgainButton.frame = CGRectMake((screenWidth / 2) - 67, 288, 135, 40);
    TryAgainButton.layer.cornerRadius = 5;
    
    [self initSelfView];
    [self GetExploreDataFromServer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)viewDidAppear:(BOOL)animated{
    //self.screenName = @"IOS Explore Page";
    //self.title = CustomLocalisedString(@"MainTab_Explore",nil);
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *BackToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackToTopButton.frame = CGRectMake(0, screenHeight - 50, 80, 50);
    [BackToTopButton setTitle:@"" forState:UIControlStateNormal];
    //   [SelectButton setImage:[UIImage imageNamed:@"SelectPhotoFrame.png"] forState:UIControlStateSelected];
    [BackToTopButton setBackgroundColor:[UIColor clearColor]];
    [BackToTopButton addTarget:self action:@selector(BackToTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:BackToTopButton];

}
-(IBAction)BackToTopButton:(id)sender{
    self.tabBarController.selectedIndex = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [mySearchBar setShowsCancelButton:NO animated:YES];
    [mySearchBar resignFirstResponder];
    SearchTblView.hidden = YES;
}
-(void)GetExploreDataFromServer{
    
    NSDictionary* dict = @{@"token":[Utils getAppToken]};
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetExplore param:dict appendString:nil completeHandler:^(id object) {
        self.exploreCountryModels  = [[ConnectionManager dataManager] exploreCountryModels];
        if (!self.exploreCountryModels.error) {
            
            // [self InitCountriesView];
            [self InitContentView];
            
        }
        else{

        };
        
    } errorBlock:^(id object) {
        [TSMessage showNotificationWithTitle:ErrorTitle subtitle:self.exploreCountryModels.message type:TSMessageNotificationTypeError];
        [self.view addSubview:NoConnectionView];

    }];

    //here init no connection
    //[self.view addSubview:NoConnectionView];
    
}

//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//<<<<<<< HEAD
//    if (connection == theConnection_All) {
//        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
//       // NSLog(@"Explore return get data to server ===== %@",GetData);
//=======
//    
//    if(connection == theConnection_GetSearchString){
//        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
//        NSLog(@"get data to server   ==== %@",GetData);
//>>>>>>> c661f79624571bbe59debe72589fae3ac992fd4a
//        
//        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *myError = nil;
//        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
//<<<<<<< HEAD
//       // NSLog(@"Explore Json = %@",res);
//        
//        if ([res count] == 0) {
//        //    NSLog(@"Server Error.");
//            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Server Error." message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            ShowAlert.tag = 1000;
//            [ShowAlert show];
//        }else{
//        //    NSLog(@"Server Work.");
//            
//            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
//        //    NSLog(@"ErrorString is %@",ErrorString);
//            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
//            NSLog(@"MessageString is %@",MessageString);
//            
//            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
//                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                ShowAlert.tag = 1000;
//                [ShowAlert show];
//                // send user back login screen.
//            }else{
//                
//                NSArray *GetAllData = (NSArray *)[res valueForKey:@"countries"];
//                
//                CountryIDArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
//                NameArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
//                SeqNoArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
//                ThumbnailArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
//                for (NSDictionary * dict in GetAllData){
//                    NSString *country_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country_id"]];
//                    [CountryIDArray addObject:country_id];
//                    NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
//                    [NameArray addObject:name];
//                    NSString *seq_no = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"seq_no"]];
//                    [SeqNoArray addObject:seq_no];
//                    NSString *thumbnail = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"thumbnail"]];
//                    [ThumbnailArray addObject:thumbnail];
//                }
//                //NSLog(@"NameArray is %@",NameArray);
//                
//                [self InitCountriesView];
//            }
//        }
//    }}
//=======
//        
//        NSArray *GetStringData = (NSArray *)[res valueForKey:@"result"];
//        NSLog(@"GetStringData is %@",GetStringData);
//        
//        NSArray *GetcomplexData = (NSArray *)[res valueForKey:@"complex"];
//        NSLog(@"GetcomplexData is %@",GetcomplexData);
//        
//        GetReturnSearchTextArray = [[NSMutableArray alloc]init];
//        
//        for (NSDictionary * dict in GetcomplexData){
//            NSString *tag = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"tag"]];
//            [GetReturnSearchTextArray addObject:tag];
//        }
//        
//        NSDictionary *locationData = [GetcomplexData valueForKey:@"location"];
//        NSLog(@"locationData is %@",locationData);
//        GetReturnSearchAddressArray = [[NSMutableArray alloc]init];
//        GetReturnSearchLatArray = [[NSMutableArray alloc]init];
//        GetReturnSearchLngArray = [[NSMutableArray alloc]init];
//        for (NSDictionary * dict in locationData) {
//            NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"formatted_address"]];
//            //NSLog(@"formatted_address is %@",formatted_address);
//            if ([formatted_address isEqualToString:@"<null>"] || formatted_address == nil) {
//                [GetReturnSearchAddressArray addObject:@""];
//            }else{
//            [GetReturnSearchAddressArray addObject:formatted_address];
//            }
//            
//            NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lat"]];
//            //NSLog(@"formatted_address is %@",formatted_address);
//            if ([lat isEqualToString:@"<null>"] || lat == nil) {
//                [GetReturnSearchLatArray addObject:@""];
//            }else{
//                [GetReturnSearchLatArray addObject:lat];
//            }
//            
//            NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lng"]];
//            //NSLog(@"formatted_address is %@",formatted_address);
//            if ([lng isEqualToString:@"<null>"] || lng == nil) {
//                [GetReturnSearchLngArray addObject:@""];
//            }else{
//                [GetReturnSearchLngArray addObject:lng];
//            }
//            
//        }
//        NSLog(@"GetReturnSearchTextArray is %@",GetReturnSearchTextArray);
//        NSLog(@"GetReturnSearchAddressArray is %@",GetReturnSearchAddressArray);
////        [LocalSuggestionTextArray removeAllObjects];
////
////        LocalSuggestionTextArray = [[NSMutableArray alloc]initWithArray:GetStringData];
////        NSLog(@"LocalSuggestionTextArray is %@",LocalSuggestionTextArray);
////        [SuggestionTblView reloadData];
//        
//        CheckTblview = 1;
//        [SearchTblView reloadData];
//    }
//}
//>>>>>>> c661f79624571bbe59debe72589fae3ac992fd4a
-(void)InitCountriesView{
    [ibScrollViewCountry setScrollEnabled:YES];
    ibScrollViewCountry.backgroundColor = [UIColor whiteColor];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    int GetHeight = 10;
    NSLog(@"GetHeight is %i",GetHeight);
    int heightGet = 0;
    int TestWidth = screenWidth - 30;
    NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 2;
    NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 10;
    
    for (int i = 0; i < 6; i++) {
        AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10+(i % 2)*SpaceWidth, GetHeight + (SpaceWidth * (CGFloat)(i /2)), FinalWidth, FinalWidth)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds = YES;
        imageView.tag = 99;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[self.exploreCountryModels.countries[i] thumbnail]];

        NSURL *url = [NSURL URLWithString:FullImagesURL];
        imageView.imageURL = url;
        
        UIButton *BackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [BackgroundButton setTitle:@"" forState:UIControlStateNormal];
        [BackgroundButton setFrame:CGRectMake(10+(i % 2)*SpaceWidth, GetHeight + (SpaceWidth * (CGFloat)(i /2)), FinalWidth, FinalWidth)];
        [BackgroundButton setBackgroundColor:[UIColor blackColor]];
        BackgroundButton.alpha = 0.5f;
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(((FinalWidth/2) - 50 )+(i % 2)*SpaceWidth, ((FinalWidth/2) - 30 + GetHeight) + (SpaceWidth * (CGFloat)(i /2)), 120, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:0.3f]];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(10+(i % 2)*SpaceWidth, ((FinalWidth/2) - 20 + GetHeight) + (SpaceWidth * (CGFloat)(i /2)), FinalWidth, 40);
        NSString *uppercase = [[self.exploreCountryModels.countries[i] name] uppercaseString];
        ShowUserName.text = uppercase;
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        ShowUserName.textColor = [UIColor whiteColor];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textAlignment = NSTextAlignmentCenter;
        [ibScrollViewCountry addSubview:ShowUserName];
        
        UIButton *Line02 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line02 setTitle:@"" forState:UIControlStateNormal];
        [Line02 setFrame:CGRectMake(((FinalWidth/2) - 50 )+(i % 2)*SpaceWidth, ((FinalWidth/2) + 30 + GetHeight) + (SpaceWidth * (CGFloat)(i /2)), 120, 1)];
        [Line02 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:0.3f]];
        
        UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ClickButton setTitle:@"" forState:UIControlStateNormal];
        [ClickButton setFrame:CGRectMake(10+(i % 2)*SpaceWidth, GetHeight + (SpaceWidth * (CGFloat)(i /2)), FinalWidth, FinalWidth)];
        [ClickButton setBackgroundColor:[UIColor clearColor]];
        ClickButton.tag = i;
        [ClickButton addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [ibScrollViewCountry addSubview:imageView];
        [ibScrollViewCountry addSubview:BackgroundButton];
        [ibScrollViewCountry addSubview:Line01];
        [ibScrollViewCountry addSubview:ShowUserName];
        [ibScrollViewCountry addSubview:Line02];
        [ibScrollViewCountry addSubview:ClickButton];
        
        heightGet = GetHeight + (SpaceWidth * (CGFloat)(i /2)) + SpaceWidth;
    }
    
    AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, heightGet, screenWidth - 20, 150)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    imageView.tag = 99;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[[self.exploreCountryModels.countries lastObject] thumbnail]];
    NSURL *url = [NSURL URLWithString:FullImagesURL];
    imageView.imageURL = url;
    
    UIButton *BackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [BackgroundButton setTitle:@"" forState:UIControlStateNormal];
    [BackgroundButton setFrame:CGRectMake(10, heightGet, screenWidth - 20, 150)];
    [BackgroundButton setBackgroundColor:[UIColor blackColor]];
    BackgroundButton.alpha = 0.5f;
    
    UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    [Line01 setFrame:CGRectMake((screenWidth/2) - 60, heightGet + 40, 120, 1)];
    [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:0.3f]];
    
    UILabel *ShowUserName = [[UILabel alloc]init];
    ShowUserName.frame = CGRectMake(15, heightGet + 50, screenWidth - 30, 40);
    NSString *uppercase = [[[self.exploreCountryModels.countries lastObject] name] uppercaseString];
    ShowUserName.text = uppercase;
    ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    ShowUserName.textColor = [UIColor whiteColor];
    ShowUserName.backgroundColor = [UIColor clearColor];
    ShowUserName.textAlignment = NSTextAlignmentCenter;
    [ibScrollViewCountry addSubview:ShowUserName];
    
    UIButton *Line02 = [UIButton buttonWithType:UIButtonTypeCustom];
    [Line02 setTitle:@"" forState:UIControlStateNormal];
    [Line02 setFrame:CGRectMake((screenWidth/2) - 60, heightGet + 99, 120, 1)];
    [Line02 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:0.3f]];
    
    UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ClickButton setTitle:@"" forState:UIControlStateNormal];
    [ClickButton setFrame:CGRectMake(10, heightGet, screenWidth - 20, 150)];
    [ClickButton setBackgroundColor:[UIColor clearColor]];
    [ClickButton addTarget:self action:@selector(ClickButton2:) forControlEvents:UIControlEventTouchUpInside];
    
    [ibScrollViewCountry addSubview:imageView];
    [ibScrollViewCountry addSubview:BackgroundButton];
    [ibScrollViewCountry addSubview:Line01];
    [ibScrollViewCountry addSubview:ShowUserName];
    [ibScrollViewCountry addSubview:Line02];
    [ibScrollViewCountry addSubview:ClickButton];
    
    heightGet += 160;
    
    
    UIImage *TempImage = [[UIImage alloc]init];
    TempImage = [UIImage imageNamed:@"BannerFestival.png"];
    
    UIImageView *FestivalImage = [[UIImageView alloc]init];
    FestivalImage.image = TempImage;
    FestivalImage.frame = CGRectMake(10, heightGet, screenWidth - 20, TempImage.size.height);
    [ibScrollViewCountry addSubview:FestivalImage];
    
    UILabel *ShowBigText = [[UILabel alloc]init];
    ShowBigText.frame = CGRectMake(15, heightGet + 20, screenWidth - 30, 72);
    ShowBigText.text = CustomLocalisedString(@"Festival", nil);
    ShowBigText.textAlignment = NSTextAlignmentCenter;
    ShowBigText.textColor = [UIColor whiteColor];
    ShowBigText.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:36];
    [ibScrollViewCountry addSubview:ShowBigText];
    
    UILabel *ShowSubText = [[UILabel alloc]init];
    ShowSubText.frame = CGRectMake(15, heightGet + 75, screenWidth - 30, 40);
    ShowSubText.text = CustomLocalisedString(@"DiscovertheColors", nil);
    ShowSubText.textAlignment = NSTextAlignmentCenter;
    ShowSubText.textColor = [UIColor whiteColor];
    ShowSubText.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:18];
    [ibScrollViewCountry addSubview:ShowSubText];
    
    
    UIButton *FestivalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // [FestivalButton setImage:[UIImage imageNamed:@"BtnLetsgo.png"] forState:UIControlStateNormal];
    [FestivalButton setBackgroundImage:[UIImage imageNamed:@"BtnLetsgo.png"] forState:UIControlStateNormal];
    [FestivalButton setTitle:CustomLocalisedString(@"Letsgo", nil) forState:UIControlStateNormal];
    [FestivalButton setFrame:CGRectMake((screenWidth/2) - 70, heightGet + 120, 140, 47)];
    [FestivalButton setBackgroundColor:[UIColor clearColor]];
    [FestivalButton addTarget:self action:@selector(LetsgoButton:) forControlEvents:UIControlEventTouchUpInside];
    [FestivalButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [ibScrollViewCountry addSubview:FestivalButton];
    
    
    [ibScrollViewCountry setContentSize:CGSizeMake(320, heightGet + TempImage.size.height + 10)];
    
    [ShowActivity stopAnimating];
}
-(void)InitContentView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    FestivalUrlArray = [[NSMutableArray alloc]init];
    FestivalImageArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < [self.exploreCountryModels.countries count]; i++) {
      
        ExploreCountryModel *model =  self.exploreCountryModels.countries[i];
        FestivalModel* fesModel = model.festival;
        //   [exploreCountryViewCOntroller GetFestivalUrl:fesModel.url GetFestivalImage:fesModel.thumbnail];
        if (fesModel.url) {
          //  SLog(@"festival URL : %@",fesModel.url);
            [FestivalUrlArray addObject:fesModel.url];
        }else{
            [FestivalUrlArray addObject:@""];
        }
        
        if (fesModel.thumbnail) {
          //  SLog(@"festival THUMBNAIL : %@",fesModel.thumbnail);
            [FestivalImageArray addObject:fesModel.thumbnail];
        }else{
            [FestivalImageArray addObject:@""];
        }


        AsyncImageView *ShowCountryImg = [[AsyncImageView alloc]init];
        ShowCountryImg.frame = CGRectMake(0, 0 + i * 151, screenWidth, 150);
        //ShowCountryImg.image = [UIImage imageNamed:@"DemoTest.png"];
        ShowCountryImg.contentMode = UIViewContentModeScaleAspectFill;
        ShowCountryImg.clipsToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowCountryImg];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[self.exploreCountryModels.countries[i] thumbnail]];
        NSURL *url = [NSURL URLWithString:FullImagesURL];
        ShowCountryImg.imageURL = url;
        [ibScrollViewCountry addSubview:ShowCountryImg];
        
       
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(20, 100 + i * 151, screenWidth - 40, 50);
        NSString *uppercase = [self.exploreCountryModels.countries[i] name];
        ShowUserName.text = uppercase;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:17];
        ShowUserName.textColor = [UIColor whiteColor];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        [ibScrollViewCountry addSubview:ShowUserName];
        
        UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ClickButton setTitle:@"" forState:UIControlStateNormal];
        [ClickButton setFrame:CGRectMake(0, 0 + i * 151, screenWidth, 150)];
        [ClickButton setBackgroundColor:[UIColor clearColor]];
        ClickButton.tag = i;
        [ClickButton addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [ibScrollViewCountry addSubview:ClickButton];
        
        [ibScrollViewCountry setContentSize:CGSizeMake(screenWidth, 150 + i * 151)];
    }
    
   // NSLog(@"FestivalUrlArray is %@",FestivalUrlArray);

}

//button trigger from pressing country
-(IBAction)ClickButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    ExploreCountryV2ViewController *exploreCountryViewCOntroller = [[ExploreCountryV2ViewController alloc]init];
    exploreCountryViewCOntroller.model = self.exploreCountryModels.countries[getbuttonIDN];

    [self.navigationController pushViewController:exploreCountryViewCOntroller animated:YES];
    [exploreCountryViewCOntroller initData];
//    ExploreCountryModel *model =  self.exploreCountryModels.countries[getbuttonIDN];
//    FestivalModel* fesModel = model.festival;
    [exploreCountryViewCOntroller GetFestivalUrl:[FestivalUrlArray objectAtIndex:getbuttonIDN] GetFestivalImage:[FestivalImageArray objectAtIndex:getbuttonIDN]];
//    if (fesModel.url) {
//        SLog(@"festival URL : %@",fesModel.url);
//    }
//    
//    if (fesModel.thumbnail) {
//        SLog(@"festival THUMBNAIL : %@",fesModel.thumbnail);
//        
//    }

}

//rest of the world click
-(IBAction)ClickButton2:(id)sender{
    ExploreCountryV2ViewController *exploreCountryViewCOntroller = [[ExploreCountryV2ViewController alloc]init];
    
    exploreCountryViewCOntroller.model = [self.exploreCountryModels.countries lastObject];
    
    
    [self.navigationController pushViewController:exploreCountryViewCOntroller animated:YES];
    [exploreCountryViewCOntroller initData];
    

}

//festival letes go clicked
-(IBAction)LetsgoButton:(id)sender{
    OpenWebViewController *OpenWebView = [[OpenWebViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:OpenWebView animated:NO completion:nil];
    [OpenWebView GetTitleString:@"Festival"];
}
-(IBAction)SearchButton:(id)sender{
    SearchViewV2Controller *SearchView = [[SearchViewV2Controller alloc]initWithNibName:@"SearchViewV2Controller" bundle:nil];
    //[self presentViewController:SearchView animated:YES completion:nil];
    [self.navigationController pushViewController:SearchView animated:YES];
}
@end
