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

@interface Explore2ViewController ()

@end

@implementation Explore2ViewController

-(void)initSelfView
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    
    CountriesScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 114);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
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
    
}
-(IBAction)BackToTopButton:(id)sender{
    self.tabBarController.selectedIndex = 0;
}
-(void)GetExploreDataFromServer{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@?token=%@",[[UrlDataClass sharedManager] Explore_Url],GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    //   NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_All = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_All start];
    
    
    if( theConnection_All ){
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
    //    [spinnerView stopAnimating];
    //    [spinnerView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_All) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
       // NSLog(@"Explore return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
       // NSLog(@"Explore Json = %@",res);
        
        if ([res count] == 0) {
        //    NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Server Error." message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
        //    NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        //    NSLog(@"ErrorString is %@",ErrorString);
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                
                NSArray *GetAllData = (NSArray *)[res valueForKey:@"countries"];
                
                CountryIDArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                NameArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                SeqNoArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                ThumbnailArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                for (NSDictionary * dict in GetAllData){
                    NSString *country_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country_id"]];
                    [CountryIDArray addObject:country_id];
                    NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                    [NameArray addObject:name];
                    NSString *seq_no = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"seq_no"]];
                    [SeqNoArray addObject:seq_no];
                    NSString *thumbnail = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"thumbnail"]];
                    [ThumbnailArray addObject:thumbnail];
                }
                //NSLog(@"NameArray is %@",NameArray);
                
                [self InitCountriesView];
            }
        }
    }}
-(void)InitCountriesView{
    [CountriesScroll setScrollEnabled:YES];
    CountriesScroll.backgroundColor = [UIColor whiteColor];
    
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
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
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[ThumbnailArray objectAtIndex:i]];
        //        //    //  NSLog(@"FullImagesURL ====== %@",FullImagesURL);
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
        NSString *uppercase = [[NameArray objectAtIndex:i] uppercaseString];
        ShowUserName.text = uppercase;
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        ShowUserName.textColor = [UIColor whiteColor];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textAlignment = NSTextAlignmentCenter;
        [CountriesScroll addSubview:ShowUserName];
        
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
        
        [CountriesScroll addSubview:imageView];
        [CountriesScroll addSubview:BackgroundButton];
        [CountriesScroll addSubview:Line01];
        [CountriesScroll addSubview:ShowUserName];
        [CountriesScroll addSubview:Line02];
        [CountriesScroll addSubview:ClickButton];
        
        
        
        heightGet = GetHeight + (SpaceWidth * (CGFloat)(i /2)) + SpaceWidth;
    }
    
    AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, heightGet, screenWidth - 20, 150)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    imageView.tag = 99;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[ThumbnailArray lastObject]];
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
    NSString *uppercase = [[NameArray lastObject] uppercaseString];
    ShowUserName.text = uppercase;
    ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    ShowUserName.textColor = [UIColor whiteColor];
    ShowUserName.backgroundColor = [UIColor clearColor];
    ShowUserName.textAlignment = NSTextAlignmentCenter;
    [CountriesScroll addSubview:ShowUserName];
    
    UIButton *Line02 = [UIButton buttonWithType:UIButtonTypeCustom];
    [Line02 setTitle:@"" forState:UIControlStateNormal];
    [Line02 setFrame:CGRectMake((screenWidth/2) - 60, heightGet + 99, 120, 1)];
    [Line02 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:0.3f]];
    
    UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ClickButton setTitle:@"" forState:UIControlStateNormal];
    [ClickButton setFrame:CGRectMake(10, heightGet, screenWidth - 20, 150)];
    [ClickButton setBackgroundColor:[UIColor clearColor]];
    [ClickButton addTarget:self action:@selector(ClickButton2:) forControlEvents:UIControlEventTouchUpInside];
    
    [CountriesScroll addSubview:imageView];
    [CountriesScroll addSubview:BackgroundButton];
    [CountriesScroll addSubview:Line01];
    [CountriesScroll addSubview:ShowUserName];
    [CountriesScroll addSubview:Line02];
    [CountriesScroll addSubview:ClickButton];
    
    heightGet += 160;
    
    
    UIImage *TempImage = [[UIImage alloc]init];
    TempImage = [UIImage imageNamed:@"BannerFestival.png"];
    
    UIImageView *FestivalImage = [[UIImageView alloc]init];
    FestivalImage.image = TempImage;
    FestivalImage.frame = CGRectMake(10, heightGet, screenWidth - 20, TempImage.size.height);
    [CountriesScroll addSubview:FestivalImage];
    
    UILabel *ShowBigText = [[UILabel alloc]init];
    ShowBigText.frame = CGRectMake(15, heightGet + 20, screenWidth - 30, 72);
    ShowBigText.text = CustomLocalisedString(@"Festival", nil);
    ShowBigText.textAlignment = NSTextAlignmentCenter;
    ShowBigText.textColor = [UIColor whiteColor];
    ShowBigText.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:36];
    [CountriesScroll addSubview:ShowBigText];
    
    UILabel *ShowSubText = [[UILabel alloc]init];
    ShowSubText.frame = CGRectMake(15, heightGet + 75, screenWidth - 30, 40);
    ShowSubText.text = CustomLocalisedString(@"DiscovertheColors", nil);
    ShowSubText.textAlignment = NSTextAlignmentCenter;
    ShowSubText.textColor = [UIColor whiteColor];
    ShowSubText.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:18];
    [CountriesScroll addSubview:ShowSubText];
    
    
    UIButton *FestivalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // [FestivalButton setImage:[UIImage imageNamed:@"BtnLetsgo.png"] forState:UIControlStateNormal];
    [FestivalButton setBackgroundImage:[UIImage imageNamed:@"BtnLetsgo.png"] forState:UIControlStateNormal];
    [FestivalButton setTitle:CustomLocalisedString(@"Letsgo", nil) forState:UIControlStateNormal];
    [FestivalButton setFrame:CGRectMake((screenWidth/2) - 70, heightGet + 120, 140, 47)];
    [FestivalButton setBackgroundColor:[UIColor clearColor]];
    [FestivalButton addTarget:self action:@selector(LetsgoButton:) forControlEvents:UIControlEventTouchUpInside];
    [FestivalButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [CountriesScroll addSubview:FestivalButton];
    
    
    [CountriesScroll setContentSize:CGSizeMake(320, heightGet + TempImage.size.height + 10)];
    
    [ShowActivity stopAnimating];
}
-(IBAction)ClickButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    ExploreCountryV2ViewController *ExploreCountryView = [[ExploreCountryV2ViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:ExploreCountryView animated:NO completion:nil];
//    [ExploreCountryView GetCountryName:[NameArray objectAtIndex:getbuttonIDN] GetCountryIDN:[CountryIDArray objectAtIndex:getbuttonIDN]];
    
    [self.navigationController pushViewController:ExploreCountryView animated:YES];
    [ExploreCountryView GetCountryName:[NameArray objectAtIndex:getbuttonIDN] GetCountryIDN:[CountryIDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)ClickButton2:(id)sender{
    ExploreCountryV2ViewController *ExploreCountryView = [[ExploreCountryV2ViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:ExploreCountryView animated:NO completion:nil];
//    [ExploreCountryView GetCountryName:[NameArray lastObject] GetCountryIDN:[CountryIDArray lastObject]];
    
    [self.navigationController pushViewController:ExploreCountryView animated:YES];
    [ExploreCountryView GetCountryName:[NameArray lastObject] GetCountryIDN:[CountryIDArray lastObject]];
}
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
@end
