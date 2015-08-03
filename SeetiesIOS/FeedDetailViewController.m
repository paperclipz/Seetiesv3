//
//  FeedDetailViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/12/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "FullImageViewController.h"
#import "LocationFeedDetailViewController.h"
#import "CommentViewController.h"
#import "ExpertsUserProfileViewController.h"
#import "OpenWebViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NSAttributedString+DVSTracking.h"

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"


@interface FeedDetailViewController ()

@end

@implementation FeedDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MainScroll.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 49);
    MImageScroll.frame = CGRectMake(0, 0, 320, 234);
    ShowLanguageTranslationView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
    ShowLanguageTranslationView.hidden = YES;
    
    [self.view addSubview:ShowLanguageTranslationView];
    
    DataUrl = [[UrlDataClass alloc]init];
    pageControlBeingUsed = NO;
    
    // Do any additional setup after loading the view from its nib.
    [MImageScroll setScrollEnabled:YES];
    MImageScroll.delegate = self;
    [MImageScroll setBounces:NO];
    
    MainScroll.delegate = self;
   // SettingBarImage.frame = CGRectMake(0, -64, 320, 64);
    SettingBarImage.hidden = YES;
    ShowTitleBarColor.frame = CGRectMake(0, -64, 320, 64);
    ShowTitleBarColor.hidden = YES;
    
    CheckCommentData = 0;
    CountLanguage = 0;
    ImageShade.frame = CGRectMake(0, 0, 320, 234);
    [MainScroll addSubview:ImageShade];
    
    CheckLanguage = 0;
    LikesText.attributedText = [NSAttributedString dvs_attributedStringWithString:CustomLocalisedString(@"Likes", nil)
                                                                            tracking:200
                                                                                font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    CommentText.attributedText = [NSAttributedString dvs_attributedStringWithString:CustomLocalisedString(@"CommentsBig", nil)
                                                                            tracking:200
                                                                                font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];

    WhiteBackground.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 48, 320, 48);
    ShowDownText.frame = CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 48, 157, 48);
    LikeButton.frame = CGRectMake(180, [UIScreen mainScreen].bounds.size.height - 39, 30, 30);
    CommentButton.frame = CGRectMake(230, [UIScreen mainScreen].bounds.size.height - 39, 30, 30);
    ShareButton.frame = CGRectMake(280, [UIScreen mainScreen].bounds.size.height - 39, 30, 30);
    
    
    [GoToSiteButton setTitle:CustomLocalisedString(@"Gotosite", nil) forState:UIControlStateNormal];
    
//    ShowDescription.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    
//    CGFloat yVelocity = [MainScroll.panGestureRecognizer velocityInView:MainScroll].y;
//    if (yVelocity < 0) {
//        NSLog(@"Up");
//    } else {
//        NSLog(@"Down");
//    }
    
    LanguageButton.hidden = YES;
    TestingUse = NO;

}
+ (instancetype) dvs_attributedStringWithString:(NSString *)string
                                       tracking:(CGFloat)tracking
                                           font:(UIFont *)font
{
    CGFloat fontSize = font.pointSize;
    CGFloat characterSpacing = tracking * fontSize / 1000;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSKernAttributeName: [NSNumber numberWithFloat:characterSpacing]};
    
    return [[NSAttributedString alloc] initWithString:string 
                                           attributes:attributes];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Feed Detail Page";
    if (CheckCommentData == 1) {
        [self GetCommentData];
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)GetPostID:(NSString *)PostID{

    GetPostID = PostID;
    [self GetPostAllData];
}
-(void)GetPostAllData{
   [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@post/%@?token=%@",DataUrl.UserWallpaper_Url,GetPostID,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
//    NSLog(@"theRequest === %@",theRequest);
//    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData                                         timeoutInterval:30];
    
    theConnection_GetPostAllData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetPostAllData start];
    
    
    if( theConnection_GetPostAllData ){
        webData = [NSMutableData data];
    }
}
-(void)GetPostID:(NSString *)PostID GetUserUid:(NSString *)uid GetUserFollowing:(NSString *)Following GetCheckLike:(NSString *)like GetLink:(NSString *)link{

    GetPostID = PostID;
    NSLog(@"GetPostID is %@",GetPostID);
    GetUserUid = uid;
    GetUserFollowing = Following;
    GetLikes = like;
    GetLink = link;
    
    NSLog(@"GetUserUid is %@",GetUserUid);
    NSLog(@"GetUserFollowing is %@",GetUserFollowing);
    NSLog(@"GetLikes is %@",GetLikes);
    
    if ([GetUserFollowing isEqualToString:@"0"]) {
        //no user follow
        [FollowButton setImage:[UIImage imageNamed:@"FollowMini.png"] forState:UIControlStateNormal];
    }else{
        [FollowButton setImage:[UIImage imageNamed:@"FollowingMini.png"] forState:UIControlStateNormal];
    }
    
    if ([GetLink length] == 0 || GetLink == nil || [GetLink isEqualToString:@"(null)"]) {
        GoToSiteButton.hidden = YES;
    }else{
    }
   // [self GetPostAllData];
    [self GetCommentData];
}
-(void)GetLang:(NSString *)Lang{
    GetLang = Lang;
    NSLog(@"GetLang is %@",GetLang);
    if ([GetLang isEqualToString:@"EN"]) {
        ShowLangImg.image = [UIImage imageNamed:@"LanguageEng.png"];
    }else{
        ShowLangImg.image = [UIImage imageNamed:@"LanguageChi.png"];
    }
}
-(void)GetLat:(NSString *)Lat GetLong:(NSString *)Long GetLocation:(NSString *)Location{

    GetLat = Lat;
    GetLong = Long;
    GetLocation = Location;
    
    NSLog(@"GetLat is %@",GetLat);
    NSLog(@"GetLong is %@",GetLong);
    NSLog(@"GetLocation is %@",GetLocation);
}
-(void)GetImageArray:(NSString *)ImageData GetTitle:(NSString *)Title GetUserName:(NSString *)UserName GetUserProfilePhoto:(NSString *)UserProfilePhoto GetMessage:(NSString *)Message GetUserAddress:(NSString *)Address GetCategory:(NSString *)Category GetTotalLikes:(NSString *)Likes GetTotalComment:(NSString *)Comment{
    GetImageData = ImageData;
    GetTitle = Title;
    GetUserName = UserName;
    GetUserProfilePhoto = UserProfilePhoto;
    GetMessage = Message;
    GetUserAddress = Address;
    GetCategory = Category;
    GetTotalLikes = Likes;
    GetTotalComments = Comment;
    
    NSLog(@"GetImageData is %@",GetImageData);
    NSLog(@"GetTitle is %@",GetTitle);
    NSLog(@"GetUserName is %@",GetUserName);
    NSLog(@"GetUserProfilePhoto is %@",GetUserProfilePhoto);
    NSLog(@"GetMessage is %@",GetMessage);
    NSLog(@"GetUserAddress is %@",GetUserAddress);
    NSLog(@"GetCategory is %@",GetCategory);
    NSLog(@"GetTotalLikes is %@",GetTotalLikes);
    NSLog(@"GetTotalComments is %@",GetTotalComments);
    
    
    
    ShowTitle.text = GetTitle;
    ShowUserName.text = GetUserName;
    NSString *TempString = [[NSString alloc]initWithFormat:@"by %@",GetUserName];
    ShowUserNameby.text = TempString;
    ShowUserLocation.text = GetUserAddress;
  //  ShowCategory.text = [GetCategory uppercaseString];
    ShowCategory.attributedText = [NSAttributedString dvs_attributedStringWithString:[GetCategory uppercaseString]
                                                                            tracking:200
                                                                                font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    ShowTotalLikes.text = GetTotalLikes;
    ShowLikesCount.text = GetTotalLikes;
    ShowTotalComments.text = GetTotalComments;
    
    // will cause trouble if you have "abc\\\\uvw"
    NSString* esc1 = [GetMessage stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString* esc2 = [esc1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString* quoted = [[@"\"" stringByAppendingString:esc2] stringByAppendingString:@"\""];
    NSData* data = [quoted dataUsingEncoding:NSUTF8StringEncoding];
    NSString* unesc = [NSPropertyListSerialization propertyListFromData:data
                                                       mutabilityOption:NSPropertyListImmutable format:NULL
                                                       errorDescription:NULL];
    assert([unesc isKindOfClass:[NSString class]]);
    NSLog(@"Output = %@", unesc);
    ShowDescription.text = unesc;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (sender == MImageScroll) {
        // Update the page when more than 50% of the previous/next page is visible
        CGFloat pageWidth = MImageScroll.frame.size.width;
        int page = floor((MImageScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        PageControlOn.currentPage = page;
    }else{
        CGFloat contentOffSet = MainScroll.contentOffset.y;
       // NSLog(@"MainScroll.contentOffset.y is %f",MainScroll.contentOffset.y);
        if (contentOffSet == 0) {
            
            if (MainScroll.contentOffset.y == 0) {
                SettingBarImage.frame = CGRectMake(0, -64, 320, 64);
                SettingBarImage.hidden = YES;
                ShowTitleBarColor.frame = CGRectMake(0, -64, 320, 64);
                ShowTitleBarColor.hidden = YES;
            }else{
                SettingBarImage.frame = CGRectMake(0, MainScroll.contentOffset.y - 1, 320, 64);
                ShowTitleBarColor.frame = CGRectMake(0, MainScroll.contentOffset.y - 1, 320, 64);
            }
        }else{
            SettingBarImage.hidden = NO;
            ShowTitleBarColor.hidden = NO;
            if (MainScroll.contentOffset.y > 64) {
                SettingBarImage.frame = CGRectMake(0, 0, 320, 64);
                ShowTitleBarColor.frame = CGRectMake(0, 0, 320, 64);
            }else{
             SettingBarImage.frame = CGRectMake(0, -64 + MainScroll.contentOffset.y + 1, 320, 64);
                ShowTitleBarColor.frame = CGRectMake(0, -64 + MainScroll.contentOffset.y + 1, 320, 64);
            }
        }
    }

}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = MImageScroll.frame.size.width * PageControlOn.currentPage;
    frame.origin.y = 0;
    frame.size = MImageScroll.frame.size;
    [MImageScroll scrollRectToVisible:frame animated:YES];
    
    pageControlBeingUsed = YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}
-(IBAction)ImageButtonClick:(id)sender{
    
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FullImageViewController *FullImageView = [[FullImageViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FullImageView animated:NO completion:nil];
    [FullImageView GetAllImageArray:ImageArray GetIDN:getbuttonIDN GetAllCaptionArray:ImageArray];
    
}
-(IBAction)LocationButton:(id)sender{
    LocationFeedDetailViewController *LocationFeedDetailView = [[LocationFeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:LocationFeedDetailView animated:NO completion:nil];
    [LocationFeedDetailView GetLat:GetLat GetLong:GetLong GetFirstImage:[ImageArray objectAtIndex:0] GetTitle:GetTitle GetLocation:GetLocation ];
}
-(void)GetCommentData{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@/%@/comments?token=%@",DataUrl.GetComment_URl,GetPostID,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
//    NSLog(@"theRequest === %@",theRequest);
//    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData                                         timeoutInterval:30];
    
    theConnection_GetComment = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetComment start];
    
    
    if( theConnection_GetComment ){
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
    if (connection == theConnection_GetPostAllData) {

        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"GetPostAllData return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            NSLog(@"ErrorString is %@",ErrorString);
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                // NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
                NSDictionary *GetAllData = [res valueForKey:@"data"];
                NSDictionary *UserInfoData_Nearby = [GetAllData valueForKey:@"user_info"];
                NSLog(@"UserInfoData_Nearby is %@",UserInfoData_Nearby);
                NSDictionary *UserInfoData_Nearby_ProfilePhoto = [UserInfoData_Nearby valueForKey:@"profile_photo"];
                NSLog(@"UserInfoData_Nearby_ProfilePhoto is %@",UserInfoData_Nearby_ProfilePhoto);
                // NSLog(@"UserInfoData_ProfilePhoto count = %i",[UserInfoData_ProfilePhoto count]);
                NSDictionary *titleData_Nearby = [GetAllData valueForKey:@"title"];
                NSLog(@"titleData is %@",titleData_Nearby);
                NSDictionary *messageData_Nearby = [GetAllData valueForKey:@"message"];
                NSLog(@"messageData is %@",messageData_Nearby);
                NSDictionary *locationData_Nearby = [GetAllData valueForKey:@"location"];
                NSLog(@"locationData is %@",locationData_Nearby);
                NSDictionary *locationData_Address_Nearby = [locationData_Nearby valueForKey:@"address_components"];
                NSLog(@"locationData_Address is %@",locationData_Address_Nearby);
                NSDictionary *CategoryMeta_Nearby = [GetAllData valueForKey:@"category_meta"];
                NSLog(@"Feed Detail CategoryMeta_Nearby is %@",CategoryMeta_Nearby);
                NSDictionary *SingleLine_Nearby = [CategoryMeta_Nearby valueForKey:@"single_line"];
                NSLog(@"Feed Detail SingleLine_Nearby is %@",SingleLine_Nearby);
                
                for (NSDictionary * dict in SingleLine_Nearby) {
                GetCategory = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                    NSLog(@"GetCategory is %@",GetCategory);
                }
                for (NSDictionary * dict in CategoryMeta_Nearby) {
                GetCategoryBackgroundColor = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"background_color"]];
                NSLog(@"2 GetCategoryBackgroundColor is %@",GetCategoryBackgroundColor);
                }
                GetUserName = [[NSString alloc]initWithFormat:@"%@",[UserInfoData_Nearby objectForKey:@"username"]];
                GetUserUid = [[NSString alloc]initWithFormat:@"%@",[UserInfoData_Nearby objectForKey:@"uid"]];
                GetUserFollowing = [[NSString alloc]initWithFormat:@"%@",[UserInfoData_Nearby objectForKey:@"following"]];
                GetUserAddress = [[NSString alloc]initWithFormat:@"%@",[UserInfoData_Nearby objectForKey:@"location"]];
                //        }
                //        for (NSDictionary * dict in UserInfoData_Nearby_ProfilePhoto) {
                GetUserProfilePhoto = [[NSString alloc]initWithFormat:@"%@",[UserInfoData_Nearby_ProfilePhoto objectForKey:@"url"]];
                //        }
                //        for (NSDictionary * dict in titleData_Nearby) {
                ChineseTitle = [[NSString alloc]initWithFormat:@"%@",[titleData_Nearby objectForKey:@"530b0aa16424400c76000002"]];
                EngTitle = [[NSString alloc]initWithFormat:@"%@",[titleData_Nearby objectForKey:@"530b0ab26424400c76000003"]];
                ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[titleData_Nearby objectForKey:@"544481503efa3ff1588b4567"]];
                IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[titleData_Nearby objectForKey:@"53672e863efa3f857f8b4ed2"]];
                PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[titleData_Nearby objectForKey:@"539fbb273efa3fde3f8b4567"]];
                NSLog(@"ChineseTitle is %@",ChineseTitle);
                NSLog(@"EngTitle is %@",EngTitle);
                NSLog(@"ThaiTitle is %@",ThaiTitle);
                NSLog(@"IndonesianTitle is %@",IndonesianTitle);
                NSLog(@"PhilippinesTitle is %@",PhilippinesTitle);
                
                if ([ChineseTitle length] == 0 || ChineseTitle == nil || [ChineseTitle isEqualToString:@"(null)"]) {
                    if ([EngTitle length] == 0 || EngTitle == nil || [EngTitle isEqualToString:@"(null)"]) {
                        if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                            if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                }else{
                                    GetTitle = PhilippinesTitle;
                                    GetLang = @"PH";
                                    [LanguageButton setImage:[UIImage imageNamed:@"LanguagePh.png"] forState:UIControlStateNormal];
                                }
                            }else{
                                GetTitle = IndonesianTitle;
                                GetLang = @"IN";
                                [LanguageButton setImage:[UIImage imageNamed:@"LanguageInd.png"] forState:UIControlStateNormal];
                            }
                        }else{
                            GetTitle = ThaiTitle;
                            GetLang = @"TH";
                            [LanguageButton setImage:[UIImage imageNamed:@"LanguageTh.png"] forState:UIControlStateNormal];
                        }
                    }else{
                        GetTitle = EngTitle;
                        GetLang = @"EN";
                        [LanguageButton setImage:[UIImage imageNamed:@"LanguageEng.png"] forState:UIControlStateNormal];
                    }
                    
                }else{
                    GetTitle = ChineseTitle;
                    GetLang = @"CN";
                    [LanguageButton setImage:[UIImage imageNamed:@"LanguageChi.png"] forState:UIControlStateNormal];
                }
                //        }aa
                //        for (NSDictionary * dict in messageData_Nearby) {
                ChineseMessage = [[NSString alloc]initWithFormat:@"%@",[messageData_Nearby objectForKey:@"530b0aa16424400c76000002"]];
                EndMessage = [[NSString alloc]initWithFormat:@"%@",[messageData_Nearby objectForKey:@"530b0ab26424400c76000003"]];
                ThaiMessage = [[NSString alloc]initWithFormat:@"%@",[messageData_Nearby objectForKey:@"544481503efa3ff1588b4567"]];
                IndonesianMessage = [[NSString alloc]initWithFormat:@"%@",[messageData_Nearby objectForKey:@"53672e863efa3f857f8b4ed2"]];
                PhilippinesMessage = [[NSString alloc]initWithFormat:@"%@",[messageData_Nearby objectForKey:@"539fbb273efa3fde3f8b4567"]];
                if ([ChineseMessage length] == 0 || ChineseMessage == nil || [ChineseMessage isEqualToString:@"(null)"]) {
                    if ([EndMessage length] == 0 || EndMessage == nil || [EndMessage isEqualToString:@"(null)"]) {
                        if ([ThaiMessage length] == 0 || ThaiMessage == nil || [ThaiMessage isEqualToString:@"(null)"]) {
                            if ([IndonesianMessage length] == 0 || IndonesianMessage == nil || [IndonesianMessage isEqualToString:@"(null)"]) {
                                if ([PhilippinesMessage length] == 0 || PhilippinesMessage == nil || [PhilippinesMessage isEqualToString:@"(null)"]) {
                                }else{
                                    GetMessage = PhilippinesMessage;
                                }
                            }else{
                                GetMessage = IndonesianMessage;
                            }
                        }else{
                            GetMessage = ThaiMessage;
                        }
                        
                    }else{
                        GetMessage = EndMessage;
                    }
                    
                }else{
                    GetMessage = ChineseMessage;
                }
                CountLanguageArray = [[NSMutableArray alloc]init];
                
                if ([EngTitle isEqualToString:@"(null)"] || [EngTitle length] == 0) {
                    //  CountLanguage = 0;
                    // NSLog(@"EngTitle 1");
                }else{
                    CountLanguage++;
                    [CountLanguageArray addObject:@"1"];
                    //  NSLog(@"EngTitle 2");
                }
                if ([ChineseTitle isEqualToString:@"(null)"] || [ChineseTitle length] == 0) {
                    //   CountLanguage = 0;
                }else{
                    CountLanguage++;
                    [CountLanguageArray addObject:@"2"];
                }
                if ([ThaiTitle isEqualToString:@"(null)"] || [ThaiTitle length] == 0) {
                    //   CountLanguage = 0;
                }else{
                    CountLanguage++;
                    [CountLanguageArray addObject:@"3"];
                }
                if ([IndonesianTitle isEqualToString:@"(null)"] || [IndonesianTitle length] == 0) {
                    //   CountLanguage = 0;
                }else{
                    CountLanguage++;
                    [CountLanguageArray addObject:@"4"];
                }
                if ([PhilippinesTitle isEqualToString:@"(null)"] || [PhilippinesTitle length] == 0) {
                    //  CountLanguage = 0;
                }else{
                    CountLanguage++;
                    [CountLanguageArray addObject:@"5"];
                }
                NSLog(@"CountLanguage is %li",(long)CountLanguage);
                
                
                if (CountLanguage == 1) {
                    NSLog(@"only one lang");
                    LanguageButton.hidden = YES;
                    ShowTopTitle.frame = CGRectMake(40, 20, 240, 44);
                }else{
                    LanguageButton.hidden = NO;
                    //CheckLanguage = 1;
                    ShowTopTitle.frame = CGRectMake(40, 20, 204, 44);
                    ClickCount = 0;
                }
                
                //        if ([ChineseTitle isEqualToString:@"(null)"] || [EngTitle isEqualToString:@"(null)"] || [ThaiTitle isEqualToString:@"(null)"] || [IndonesianTitle isEqualToString:@"(null)"] || [PhilippinesTitle isEqualToString:@"(null)"]) {
                //
                //            NSLog(@"only one lang");
                //            LanguageButton.hidden = YES;
                //            ShowTopTitle.frame = CGRectMake(40, 20, 240, 44);
                //        }else{
                //            NSLog(@"Got en and cn");
                //            LanguageButton.hidden = NO;
                //            CheckLanguage = 1;
                //            ShowTopTitle.frame = CGRectMake(40, 20, 204, 44);
                //        }
                //        }
                //        for (NSDictionary * dict in locationData_Nearby) {
                GetLat = [[NSString alloc]initWithFormat:@"%@",[locationData_Nearby objectForKey:@"lat"]];
                GetLong = [[NSString alloc]initWithFormat:@"%@",[locationData_Nearby objectForKey:@"lng"]];
                //        }
                //        for (NSDictionary * dict in locationData_Address_Nearby) {
                NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[locationData_Address_Nearby objectForKey:@"administrative_area_level_1"]];
                NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[locationData_Address_Nearby objectForKey:@"country"]];
                
                NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Address2];
                GetLocation = FullString;
                //        }
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                NSMutableArray *TempImageArray = [[NSMutableArray alloc]init];
                GetTotalLikes =  [NSString stringWithFormat:@"%@",[GetAllData valueForKey:@"total_like"]];
                GetTotalComments =  [NSString stringWithFormat:@"%@",[GetAllData valueForKey:@"total_comments"]];
                GetPostID =  [NSString stringWithFormat:@"%@",[GetAllData valueForKey:@"post_id"]];
                GetLikes =  [NSString stringWithFormat:@"%@",[GetAllData valueForKey:@"like"]];
                NSLog(@"GetLikes is %@",GetLikes);
                GetLink =  [NSString stringWithFormat:@"%@",[GetAllData valueForKey:@"link"]];
                GetPlaceName = [NSString stringWithFormat:@"%@",[GetAllData valueForKey:@"place_name"]];
                GetFormattedAddress = [NSString stringWithFormat:@"%@",[locationData_Nearby valueForKey:@"formatted_address"]];
                GetLanguages = [NSString stringWithFormat:@"%@",[GetAllData valueForKey:@"languages"]];
                NSLog(@"GetLanguages is %@",GetLanguages);
                //  NSLog(@"GetFormattedAddress is %@",GetFormattedAddress);
                //        for (NSDictionary * dict in GetAllData){
                NSString *photos =  [NSString stringWithFormat:@"%@",[GetAllData objectForKey:@"photos"]];
                //  NSLog(@"photos is %@",photos);
                // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                photos = [[photos componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                // NSLog(@"photos is %@", photos);
                NSArray *SplitArray = [photos componentsSeparatedByString:@"url="];
                //  NSLog(@"SplitArray is %@",SplitArray);
                NSString *GetSplitString;
                if ([SplitArray count] > 1) {
                    GetSplitString = [SplitArray objectAtIndex: 1];
                    NSMutableArray *testarray = [[NSMutableArray alloc]init];
                    for (int i = 0; i < [SplitArray count]; i++) {
                        NSString *GetData = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
                        
                        if ([GetData rangeOfString:@"m="].location == NSNotFound) {
                        } else {
                            //  NSLog(@"Get GetData is %@",GetData);
                            NSArray *SplitArray2 = [GetData componentsSeparatedByString:@"m="];
                            NSString *FinalString = [SplitArray2 objectAtIndex:0];
                            [testarray addObject:FinalString];
                        }
                    }
                    //   NSLog(@"testarray is %@",testarray);
                    NSString * result = [testarray componentsJoinedByString:@","];
                    [TempImageArray addObject:result];
                }else{
                    GetSplitString = @"";
                }
                //
                //
                //
                //
                //        }
                GetImageData = [[NSString alloc]initWithFormat:@"%@",[TempImageArray objectAtIndex:0]];
                NSLog(@"GetLikes is %@",GetLikes);
                if ([GetLikes isEqualToString:@"1"]) {
                    [LikeButton setImage:[UIImage imageNamed:@"PostLiked.png"] forState:UIControlStateNormal];
                }else{
                    [LikeButton setImage:[UIImage imageNamed:@"PostNoLike.png"] forState:UIControlStateNormal];
                }
                if ([GetUserFollowing isEqualToString:@"0"]) {
                    //no user follow
                    [FollowButton setImage:[UIImage imageNamed:@"FollowMini.png"] forState:UIControlStateNormal];
                }else{
                    [FollowButton setImage:[UIImage imageNamed:@"FollowingMini.png"] forState:UIControlStateNormal];
                }
                if ([GetLang isEqualToString:@"EN"]) {
                    ShowLangImg.image = [UIImage imageNamed:@"LanguageEng.png"];
                }else{
                    ShowLangImg.image = [UIImage imageNamed:@"LanguageChi.png"];
                }
                
                ShowTitle.text = GetTitle;
                ShowTopTitle.text = GetPlaceName;
                ShowUserName.text = GetUserName;
                NSString *TempString = [[NSString alloc]initWithFormat:@"by %@",GetUserName];
                ShowUserNameby.text = TempString;
                ShowUserLocation.text = GetUserAddress;
                // ShowCategory.text = [GetCategory uppercaseString];
                NSLog(@"GetCategory is %@",GetCategory);
                NSString *tempCategoryText;
                if ([GetCategory isEqualToString:@"Art & Entertainment"]) {
                    tempCategoryText = CustomLocalisedString(@"Art", nil);
                }else if ([GetCategory isEqualToString:@"Beauty & Fashion"]) {
                    tempCategoryText = CustomLocalisedString(@"Beauty", nil);
                }else if ([GetCategory isEqualToString:@"Food & Drink"]) {
                    tempCategoryText = CustomLocalisedString(@"Food", nil);
                }else if ([GetCategory isEqualToString:@"Outdoor & Sport"]) {
                    tempCategoryText = CustomLocalisedString(@"Outdoor", nil);
                }else if ([GetCategory isEqualToString:@"Staycation"]) {
                    tempCategoryText = CustomLocalisedString(@"Staycation", nil);
                }else if ([GetCategory isEqualToString:@"Product"]) {
                    tempCategoryText = CustomLocalisedString(@"Product", nil);
                }else if ([GetCategory isEqualToString:@"Nightlife"]) {
                    tempCategoryText = CustomLocalisedString(@"Nightlife", nil);
                }else if ([GetCategory isEqualToString:@"Culture & Landmark"]) {
                    tempCategoryText = CustomLocalisedString(@"Culture", nil);
                }else if ([GetCategory isEqualToString:@"Kitchen Recipe"]) {
                    tempCategoryText = CustomLocalisedString(@"Kitchen", nil);
                }
                NSUInteger red, green, blue;
                sscanf([GetCategoryBackgroundColor UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
                
                UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
                ShowCategory.textColor = color;
                [ShowTitleBarColor setBackgroundColor:color];
                
                
                NSLog(@"tempCategoryText is %@",tempCategoryText);
                ShowCategory.attributedText = [NSAttributedString dvs_attributedStringWithString:[tempCategoryText uppercaseString]
                                                                                        tracking:200
                                                                                            font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
                ShowTotalLikes.text = GetTotalLikes;
                ShowLikesCount.text = GetTotalLikes;
                ShowTotalComments.text = GetTotalComments;
                
                // will cause trouble if you have "abc\\\\uvw"
                NSString* esc1 = [GetMessage stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
                NSString* esc2 = [esc1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                NSString* quoted = [[@"\"" stringByAppendingString:esc2] stringByAppendingString:@"\""];
                NSData* data = [quoted dataUsingEncoding:NSUTF8StringEncoding];
                NSString* unesc = [NSPropertyListSerialization propertyListFromData:data
                                                                   mutabilityOption:NSPropertyListImmutable format:NULL
                                                                   errorDescription:NULL];
                assert([unesc isKindOfClass:[NSString class]]);
                NSLog(@"Output = %@", unesc);
                ShowDescription.text = unesc;
                
                //language
                NSCharacterSet *doNotWant_Language = [NSCharacterSet characterSetWithCharactersInString:@"\n() "];
                GetLanguages = [[GetLanguages componentsSeparatedByCharactersInSet: doNotWant_Language] componentsJoinedByString: @""];
                NSLog(@"GetLanguages 1 is %@",GetLanguages);
                
                if ([GetLanguages isEqualToString:@"530b0ab26424400c76000003"]) {
                    
                }else{
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    //  [defaults setObject:GetUserSelectLanguagesArray forKey:@"GetUserSelectLanguagesArray"];
                    NSMutableArray *GetUserSelectLanguagesArray = [[NSMutableArray alloc]initWithArray:[defaults valueForKey:@"GetUserSelectLanguagesArray"]];
                    NSLog(@"GetUserSelectLanguagesArray is %@",GetUserSelectLanguagesArray);
                    if (CountLanguage == 1) {
                        NSLog(@"only one lang");
                        if ([GetUserSelectLanguagesArray count] == 2) {
                            NSLog(@"2 language");
                            NSString *TempLanguage1 = [[NSString alloc]initWithFormat:@"%@",[GetUserSelectLanguagesArray objectAtIndex:0]];
                            NSString *TempLanguage2 = [[NSString alloc]initWithFormat:@"%@",[GetUserSelectLanguagesArray objectAtIndex:1]];
                            
                            if ([GetLanguages isEqualToString:TempLanguage1]) {
                                ShowLanguageTranslationView.hidden = YES;
                            }else if([GetLanguages isEqualToString:TempLanguage2]){
                                ShowLanguageTranslationView.hidden = YES;
                            }else{
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                NSString *CheckDontShowAgain = [defaults objectForKey:@"DontShowAgainTranslate"];
                                if ([CheckDontShowAgain isEqualToString:@"DontShowAgain"]) {
                                    ShowLanguageTranslationView.hidden = YES;
                                }else{
                                    ShowLanguageTranslationView.hidden = NO;
                                }
                                ShowTopTitle.frame = CGRectMake(40, 20, 204, 44);
                                NewLanguageButton.frame = CGRectMake(229, 26, 55, 33);
                                [self.view addSubview:NewLanguageButton];
                            }
                            
                        }else{
                            NSLog(@"1 language");
                            NSString *TempLanguage1 = [[NSString alloc]initWithFormat:@"%@",[GetUserSelectLanguagesArray objectAtIndex:0]];
                            if ([GetLanguages isEqualToString:TempLanguage1]) {
                                ShowLanguageTranslationView.hidden = YES;
                            }else{
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                NSString *CheckDontShowAgain = [defaults objectForKey:@"DontShowAgainTranslate"];
                                if ([CheckDontShowAgain isEqualToString:@"DontShowAgain"]) {
                                    ShowLanguageTranslationView.hidden = YES;
                                }else{
                                    ShowLanguageTranslationView.hidden = NO;
                                }
                                ShowTopTitle.frame = CGRectMake(40, 20, 204, 44);
                                NewLanguageButton.frame = CGRectMake(229, 26, 55, 33);
                                [self.view addSubview:NewLanguageButton];
                            }
                        }
                        
                        //  for (int i = 0; i < [GetUserSelectLanguagesArray count]; i++) {
                        //                NSString *TempLanguage = [[NSString alloc]initWithFormat:@"%@",[GetUserSelectLanguagesArray objectAtIndex:i]];
                        //                NSLog(@"TempLanguage is %@",TempLanguage);
                        //                if ([GetLanguages isEqualToString:TempLanguage]) {
                        //                    ShowLanguageTranslationView.hidden = YES;
                        //                }else{
                        //                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        //                    NSString *CheckDontShowAgain = [defaults objectForKey:@"DontShowAgainTranslate"];
                        //                    if ([CheckDontShowAgain isEqualToString:@"DontShowAgain"]) {
                        //                        ShowLanguageTranslationView.hidden = YES;
                        //                    }else{
                        //                        ShowLanguageTranslationView.hidden = NO;
                        //                    }
                        //                    ShowTopTitle.frame = CGRectMake(40, 20, 204, 44);
                        //                    NewLanguageButton.frame = CGRectMake(229, 26, 55, 33);
                        //                    [self.view addSubview:NewLanguageButton];
                        //                }
                        //    }
                        
                        
                        
                        
                    }else{
                        
                    }
                    
                }
                
                
                
                [self GetCommentData];
            }
        }
        
      
    }else if (connection == theConnection_GetComment) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Comment return get data to server ===== %@",GetData);
        
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
        GetCommentCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_comments"]];
        NSLog(@"GetCommentCount is %@",GetCommentCount);
        
        ShowCommentCount.text = GetCommentCount;
        
        NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
        NSLog(@"GetAllData is %@",GetAllData);
        
        CommentIDArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
        PostIDArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
        MessageArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
        for (NSDictionary * dict in GetAllData) {
            NSString *comment_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"comment_id"]];
            [CommentIDArray addObject:comment_id];
            NSString *post_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
            [PostIDArray addObject:post_id];
            NSString *message = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"message"]];
            [MessageArray addObject:message];
        }
        
        NSDictionary *UserInfoData_ = [GetAllData valueForKey:@"user_info"];
        NSLog(@"UserInfoData_ is %@",UserInfoData_);
        
        User_Comment_uidArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
        User_Comment_nameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
        User_Comment_usernameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
        User_Comment_photoArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
        for (NSDictionary * dict in UserInfoData_) {
            NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
            [User_Comment_uidArray addObject:uid];
            NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
            [User_Comment_nameArray addObject:name];
            NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
            [User_Comment_usernameArray addObject:username];
            NSString *photo = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"photo"]];
            [User_Comment_photoArray addObject:photo];
        }
        [self GetLikeData];


    }else if(connection == theConnection_Following){
    
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Following return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *ResultString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"result"]];
        NSLog(@"ResultString is %@",ResultString);
        
        if ([ResultString isEqualToString:@"ok"]) {
            if ([GetUserFollowing isEqualToString:@"0"]) {
                GetUserFollowing = @"1";
                [FollowButton setImage:[UIImage imageNamed:@"FollowingMini.png"] forState:UIControlStateNormal];
            }else{
                GetUserFollowing = @"0";
                [FollowButton setImage:[UIImage imageNamed:@"FollowMini.png"] forState:UIControlStateNormal];
            }

        }
    }else if(connection == theConnection_GetAllUserlikes){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get likes return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
            NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
            NSLog(@"GetAllData is %@",GetAllData);

            NSDictionary *UserInfoData_ = [GetAllData valueForKey:@"like_list"];
            NSLog(@"UserInfoData_ is %@",UserInfoData_);
            
            Like_UseruidArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            Like_UserProfilePhotoArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            Like_UsernameArray = [[NSMutableArray alloc]initWithCapacity:[UserInfoData_ count]];
            for (NSDictionary * dict in UserInfoData_) {
                NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                [Like_UseruidArray addObject:uid];
                NSString *photo = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [Like_UserProfilePhotoArray addObject:photo];
                NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [Like_UsernameArray addObject:username];
            }
        }
        NSLog(@"Like_UserProfilePhotoArray is %@",Like_UserProfilePhotoArray);
        
        [self InitView];
       [ShowActivity stopAnimating];
    }else if(connection == theConnection_GetTranslate){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Translate return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            NSDictionary *GetAllData = [res valueForKey:@"data"];
            NSLog(@"GetAllData is %@",GetAllData);
            NSDictionary *GetAlltranslation = [GetAllData valueForKey:@"translation"];
            NSLog(@"GetAlltranslation is %@",GetAlltranslation);
            NSDictionary *GetAllENData = [GetAlltranslation valueForKey:@"530b0ab26424400c76000003"];
            NSLog(@"GetAllENData is %@",GetAllENData);
            
            GetENMessageString = [[NSString alloc]initWithFormat:@"%@",[GetAllENData objectForKey:@"message"]];
            NSLog(@"GetENMessageString is %@",GetENMessageString);
            
            GetENTItleStirng = [[NSString alloc]initWithFormat:@"%@",[GetAllENData objectForKey:@"title"]];
            NSLog(@"GetENTItleStirng is %@",GetENTItleStirng);
            
            CheckENTranslation = @"1";
            
            GetMessage = GetENMessageString;
            GetTitle = GetENTItleStirng;
            ShowDescription.text = GetMessage;
            ShowTitle.text = GetTitle;
            ShowLanguageTranslationView.hidden = YES;
            TestingUse = YES;
            [self InitView];
            
            [ShowActivity stopAnimating];
            
        }
        
        [ShowActivity stopAnimating];
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Send post like return get data to server ===== %@",GetData);
    
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            NSDictionary *GetAllData = [res valueForKey:@"data"];
            NSLog(@"GetAllData is %@",GetAllData);
            
            NSString *likeString = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"like"]];
            NSLog(@"likeString is %@",likeString);
            
            NSString *likeStringCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"total_like"]];
            NSLog(@"likeStringCount is %@",likeStringCount);
            
            NSString *TempString = [[NSString alloc]initWithFormat:@"%@ %@  %@ %@",CustomLocalisedString(@"Likes", nil),likeStringCount,CustomLocalisedString(@"CommentsBig", nil),ShowCommentCount.text];
            ShowDownText.text = TempString;
            ShowLikesCount.text = likeStringCount;
            
            if ([likeString isEqualToString:@"1"]) {
                GetLikes = @"1";
                [LikeButton setImage:[UIImage imageNamed:@"PostLiked.png"] forState:UIControlStateNormal];
                [self GetLikeData];
            }else{
                GetLikes = @"0";
                [LikeButton setImage:[UIImage imageNamed:@"PostNoLike.png"] forState:UIControlStateNormal];
                [self GetLikeData];
            }
           // [self InitView];
        }
    }
    
    
}
-(void)InitView{
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    [MainScroll setNeedsDisplay];
    [MainScroll setNeedsLayout];
    // NSLog(@"GetImageData is %@",GetImageData);
    NSArray *SplitArray = [GetImageData componentsSeparatedByString:@","];
    
    ImageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
        [ImageArray addObject:GetSplitData];
    }
    // NSLog(@"ImageArray is %@",ImageArray);
    // ImageArray = [[NSMutableArray alloc]initWithArray:ImageData];
    [MainScroll addSubview:MImageScroll];
    [MainScroll addSubview:PageControlOn];
    for (int i = 0 ; i < [ImageArray count]; i++) {
        ImageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake( 0+ i *320, 0, 320, 234)];
        ImageScroll.delegate = self;
        //  ImageScroll.tag = 50000 + j;
        ImageScroll.minimumZoomScale = 1;
        ImageScroll.maximumZoomScale = 4;
        [ImageScroll setScrollEnabled:YES];
        [ImageScroll setNeedsDisplay];
        [MImageScroll addSubview:ImageScroll];
        
        ShowImage = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 234)];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[ImageArray objectAtIndex:i]];
        //   NSLog(@"FullImagesURL ====== %@",FullImagesURL);
        //  NSURL *url = [NSURL URLWithString:FullImagesURL];
        NSURL *theURL = [NSURL URLWithString:FullImagesURL];
        ShowImage.imageURL = theURL;
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.backgroundColor = [UIColor clearColor];
        ShowImage.tag = 6000000;
        [ImageScroll addSubview:ShowImage];
        
        UIButton *ImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ImageButton setTitle:@"" forState:UIControlStateNormal];
        [ImageButton setFrame:CGRectMake(0, 0, 320, 234)];
        [ImageButton setBackgroundColor:[UIColor clearColor]];
        ImageButton.tag = i;
        [ImageButton addTarget:self action:@selector(ImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [ImageScroll addSubview:ImageButton];
    }
    NSInteger productcount = [ImageArray count];
    MImageScroll.contentSize = CGSizeMake(productcount * 320, 234);
    
    PageControlOn.currentPage = 0;
    PageControlOn.numberOfPages = productcount;
    
    UIButton *ClickUserIconToProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    [ClickUserIconToProfile setTitle:@"" forState:UIControlStateNormal];
    [ClickUserIconToProfile setBackgroundColor:[UIColor clearColor]];

    [MainScroll addSubview:ShowDescription];
    [MainScroll addSubview:GoToSiteButton];
    [MainScroll addSubview:ShowGoogleTranslateText];
    [MainScroll addSubview:UserImage];
    [MainScroll addSubview:ShowUserName];
    [MainScroll addSubview:ShowUserLocation];
    [MainScroll addSubview:FollowButton];
    [MainScroll addSubview:Line001];
    [MainScroll addSubview:LikesText];
    [MainScroll addSubview:ShowLikesUserImageScroll];
    [MainScroll addSubview:Line002];
    [MainScroll addSubview:CommentText];
    [MainScroll addSubview:AddCommentButton];
    [MainScroll addSubview:ShowCommentCount];
    [MainScroll addSubview:ShowLikesCount];
    [MainScroll addSubview:ShowCategory];
    [MainScroll addSubview:ShowTitle];
    [MainScroll addSubview:ShowUserNameby];
    [MainScroll addSubview:ImageShade];
    if([ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height!=ShowDescription.frame.size.height)
    {
        //change this to reflect the constraints of your UITextView
        ShowDescription.frame = CGRectMake(10, 355, 300,[ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height);
        NSLog(@"textView is %f",ShowDescription.frame.size.height);
        if (ShowDescription.frame.size.height  > 100) {
            if (TestingUse == YES) {
                ShowGoogleTranslateText.hidden = NO;
                ShowGoogleTranslateText.frame = CGRectMake(15, 358 +[ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 290, 40);
                GoToSiteButton.frame = CGRectMake(15,  418 +[ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 290, 30);
                UserImage.frame = CGRectMake(15, 451 +[ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 60, 60);
                ShowUserName.frame = CGRectMake(88, 460 +[ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 163, 21);
                ShowUserLocation.frame = CGRectMake(88, 482 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 163, 21);
                FollowButton.frame = CGRectMake(259, 460 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 41, 40);
                Line001.frame = CGRectMake(0, 529 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 1);
                LikesText.frame = CGRectMake(15, 541 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 280, 21);
                ShowLikesUserImageScroll.frame = CGRectMake(0, 568 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 70);
                Line002.frame = CGRectMake(0, 662 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 1);
                CommentText.frame = CGRectMake(15, 671 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 215, 21);
                AddCommentButton.frame = CGRectMake(265, 665 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 46, 34);
                [LikesText sizeToFit];
                [LikesText setNeedsDisplay];
                [CommentText sizeToFit];
                [CommentText setNeedsDisplay];
              //  NSLog(@"LikesText is %@",LikesText);
              //  NSLog(@"CommentText is %@",CommentText);
                ShowCommentCount.frame = CGRectMake(CommentText.frame.size.width + 20, 668 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 42, 21);
                ShowLikesCount.frame = CGRectMake(LikesText.frame.size.width + 20, 538 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 42, 21);
                [ClickUserIconToProfile setFrame:CGRectMake(20, 446 +[ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 60, 60)];
            }else{
                ShowGoogleTranslateText.hidden = YES;
                GoToSiteButton.frame = CGRectMake(15,  358 +[ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 290, 30);
                UserImage.frame = CGRectMake(15, 391 +[ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 60, 60);
                ShowUserName.frame = CGRectMake(88, 400 +[ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 163, 21);
                ShowUserLocation.frame = CGRectMake(88, 422 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 163, 21);
                FollowButton.frame = CGRectMake(259, 400 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 41, 40);
                Line001.frame = CGRectMake(0, 469 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 1);
                LikesText.frame = CGRectMake(15, 481 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 280, 21);
                ShowLikesUserImageScroll.frame = CGRectMake(0, 508 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 70);
                Line002.frame = CGRectMake(0, 602 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 1);
                CommentText.frame = CGRectMake(15, 611 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 215, 21);
                AddCommentButton.frame = CGRectMake(265, 605 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 46, 34);
                [LikesText sizeToFit];
                [LikesText setNeedsDisplay];
                [CommentText sizeToFit];
                [CommentText setNeedsDisplay];
               // NSLog(@"LikesText is %@",LikesText);
              //  NSLog(@"CommentText is %@",CommentText);
                ShowCommentCount.frame = CGRectMake(CommentText.frame.size.width + 20, 608 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 42, 21);
                ShowLikesCount.frame = CGRectMake(LikesText.frame.size.width + 20, 478 + [ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 42, 21);
                [ClickUserIconToProfile setFrame:CGRectMake(20, 386 +[ShowDescription sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 60, 60)];
            }

        }else{
            if (TestingUse == YES) {
                ShowGoogleTranslateText.hidden = NO;
                ShowGoogleTranslateText.frame = CGRectMake(15, 495, 290, 40);
                GoToSiteButton.frame = CGRectMake(15, 555, 290, 30);
                UserImage.frame = CGRectMake(15, 593, 60, 60);
                ShowUserName.frame = CGRectMake(88, 601, 163, 21);
                ShowUserLocation.frame = CGRectMake(88, 623, 163, 21);
                FollowButton.frame = CGRectMake(259, 601, 41, 40);
                Line001.frame = CGRectMake(0, 675, 320, 1);
                LikesText.frame = CGRectMake(15, 687, 280, 21);
                ShowLikesUserImageScroll.frame = CGRectMake(0, 714, 320, 70);
                Line002.frame = CGRectMake(0, 808, 320, 1);
                CommentText.frame = CGRectMake(15, 817, 215, 21);
                AddCommentButton.frame = CGRectMake(265, 811, 46, 34);
                ShowCommentCount.frame = CGRectMake(115, 815, 42, 21);
                ShowLikesCount.frame = CGRectMake(70, 686, 42, 21);
                [ClickUserIconToProfile setFrame:CGRectMake(20, 593, 60, 60)];
            }else{
                ShowGoogleTranslateText.hidden = YES;
                GoToSiteButton.frame = CGRectMake(15, 495, 290, 30);
                UserImage.frame = CGRectMake(15, 533, 60, 60);
                ShowUserName.frame = CGRectMake(88, 541, 163, 21);
                ShowUserLocation.frame = CGRectMake(88, 563, 163, 21);
                FollowButton.frame = CGRectMake(259, 541, 41, 40);
                Line001.frame = CGRectMake(0, 615, 320, 1);
                LikesText.frame = CGRectMake(15, 627, 280, 21);
                ShowLikesUserImageScroll.frame = CGRectMake(0, 654, 320, 70);
                Line002.frame = CGRectMake(0, 748, 320, 1);
                CommentText.frame = CGRectMake(15, 757, 215, 21);
                AddCommentButton.frame = CGRectMake(265, 751, 46, 34);
                ShowCommentCount.frame = CGRectMake(115, 755, 42, 21);
                ShowLikesCount.frame = CGRectMake(70, 626, 42, 21);
                [ClickUserIconToProfile setFrame:CGRectMake(20, 533, 60, 60)];
            }

            
        }
    }
    [ClickUserIconToProfile addTarget:self action:@selector(OpenProfileButton:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"ShowUserName is %@",ShowUserName);
    NSLog(@"ShowUserLocation is %@",ShowUserLocation);
    [MainScroll addSubview:ClickUserIconToProfile];
    
    UserImage.contentMode = UIViewContentModeScaleAspectFill;
    UserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    UserImage.layer.cornerRadius=30;
    UserImage.layer.borderWidth=1;
    UserImage.layer.masksToBounds = YES;
    UserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImage];
    NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",GetUserProfilePhoto];
    NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
    if ([FullImagesURL1 length] == 0) {
        UserImage.image = [UIImage imageNamed:@"avatar.png"];
    }else{
        NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
        //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
        UserImage.imageURL = url_UserImage;
    }
    
    ShowLikesUserImageScroll.delegate = self;
    for (int i = 0; i < [Like_UserProfilePhotoArray count]; i++) {
        AsyncImageView *ShowLikeUserImage = [[AsyncImageView alloc]init];
        ShowLikeUserImage.frame = CGRectMake(20 + i * 60, 10, 50, 50);
        ShowLikeUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowLikeUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowLikeUserImage.layer.cornerRadius=25;
        ShowLikeUserImage.layer.borderWidth=1;
        ShowLikeUserImage.layer.masksToBounds = YES;
        ShowLikeUserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowLikeUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[Like_UserProfilePhotoArray objectAtIndex:i]];
        if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"null"] || [FullImagesURL1 isEqualToString:@"<null>"]) {
            ShowLikeUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowLikeUserImage.imageURL = url_UserImage;
        }
        [ShowLikesUserImageScroll addSubview:ShowLikeUserImage];
        
        UIButton *OpenExpertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
       // [OpenExpertsButton setImage:[UIImage imageNamed:@"PostNoComment.png"] forState:UIControlStateNormal];
        [OpenExpertsButton setFrame:CGRectMake(20 + i * 60, 10, 50, 50)];
        [OpenExpertsButton setBackgroundColor:[UIColor clearColor]];
        OpenExpertsButton.tag = i;
        [OpenExpertsButton addTarget:self action:@selector(OpenExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
        [ShowLikesUserImageScroll addSubview:OpenExpertsButton];
        
        ShowLikesUserImageScroll.contentSize = CGSizeMake(80 + i * 60, 70);
    }
    
    int GetHeight = CommentText.frame.origin.y;
    NSLog(@"GetHeight is %i",GetHeight);
    int FinalGetHeight = 0;
    
    int GetCount = [GetCommentCount intValue];
    
    if (GetCount == 0) {
        
        
        CommentText.hidden = YES;
        AddCommentButton.hidden = YES;
        ShowCommentCount.hidden = YES;
        
        int GetCountLike = [GetTotalLikes intValue];
        NSLog(@"GetCountLike is %i",GetCountLike);
        if (GetCountLike == 0) {
            LikesText.hidden = YES;
            ShowLikesCount.hidden = YES;
        FinalGetHeight = Line001.frame.origin.y;
            NSLog(@"Line002 is %i",FinalGetHeight);
        }else{
         FinalGetHeight = Line002.frame.origin.y;
        }
        
//        UIButton *SeeAllCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [SeeAllCommentButton setTitle:@"See All Comment" forState:UIControlStateNormal];
//        // [MoreCommendationsButton setImage:[UIImage imageNamed:@"Morerecommendation.png"] forState:UIControlStateNormal];
//        [SeeAllCommentButton setFrame:CGRectMake(14, FinalGetHeight + 10, 280, 30)];
//        [SeeAllCommentButton setBackgroundColor:[UIColor clearColor]];
//        [SeeAllCommentButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        // [MoreCommendationsButton addTarget:self action:@selector(MoreCommendationsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [MainScroll addSubview:SeeAllCommentButton];
        
//        UIButton *LineFinal = [UIButton buttonWithType:UIButtonTypeCustom];
//        [LineFinal setTitle:@"" forState:UIControlStateNormal];
//        [LineFinal setFrame:CGRectMake(0, FinalGetHeight + 5, 320, 1)];
//        [LineFinal setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
//        [MainScroll addSubview:LineFinal];
        
//        UIButton *AddCollectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [AddCollectionButton setImage:[UIImage imageNamed:@"AddCollection.png"] forState:UIControlStateNormal];
//        [AddCollectionButton setFrame:CGRectMake(14, FinalGetHeight + 50, 133, 28)];
//        [AddCollectionButton setBackgroundColor:[UIColor clearColor]];
//        // [MoreCommendationsButton addTarget:self action:@selector(MoreCommendationsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [MainScroll addSubview:AddCollectionButton];
        
        NSString *TempString = [[NSString alloc]initWithFormat:@"%@ %@  %@ %@",CustomLocalisedString(@"Likes", nil),ShowLikesCount.text,CustomLocalisedString(@"CommentsBig", nil),ShowCommentCount.text];
        ShowDownText.text = TempString;
//        UILabel *AddLikeAndCommentText = [[UILabel alloc]init];
//        AddLikeAndCommentText.frame = CGRectMake(15, FinalGetHeight + 15, 150, 30);
//        AddLikeAndCommentText.text = TempString;
//        AddLikeAndCommentText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
//        AddLikeAndCommentText.textColor = [UIColor blackColor];
//        AddLikeAndCommentText.backgroundColor = [UIColor clearColor];
//        [MainScroll addSubview:AddLikeAndCommentText];
        
        //LikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([GetLikes isEqualToString:@"0"]) {
            [LikeButton setImage:[UIImage imageNamed:@"PostNoLike.png"] forState:UIControlStateNormal];
        }else{
            [LikeButton setImage:[UIImage imageNamed:@"PostLiked.png"] forState:UIControlStateNormal];
        }
//       // [LikeButton setImage:[UIImage imageNamed:@"PostNoLike.png"] forState:UIControlStateNormal];
//        [LikeButton setFrame:CGRectMake(180, FinalGetHeight + 15, 30, 30)];
//        [LikeButton setBackgroundColor:[UIColor clearColor]];
//        [LikeButton addTarget:self action:@selector(LikeButton:) forControlEvents:UIControlEventTouchUpInside];
//        [MainScroll addSubview:LikeButton];
        
//        UIButton *CommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [CommentButton setImage:[UIImage imageNamed:@"PostNoComment.png"] forState:UIControlStateNormal];
//        [CommentButton setFrame:CGRectMake(230, FinalGetHeight + 15, 30, 30)];
//        [CommentButton setBackgroundColor:[UIColor clearColor]];
//        [CommentButton addTarget:self action:@selector(CommentButton:) forControlEvents:UIControlEventTouchUpInside];
//        [MainScroll addSubview:CommentButton];
//        
//        UIButton *ShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [ShareButton setImage:[UIImage imageNamed:@"PostShare.png"] forState:UIControlStateNormal];
//        [ShareButton setFrame:CGRectMake(280, FinalGetHeight + 15, 30, 30)];
//        [ShareButton setBackgroundColor:[UIColor clearColor]];
//        [ShareButton addTarget:self action:@selector(ShareButton:) forControlEvents:UIControlEventTouchUpInside];
//        [MainScroll addSubview:ShareButton];
        
        
        MainScroll.contentSize = CGSizeMake(320, FinalGetHeight);
        
        
    }else{
        if (GetCount < 4) {
            TagNameArray = [[NSMutableArray alloc]init];
            //comment
            for (int i = 0; i < GetCount; i ++) {
                AsyncImageView *ShowLikeUserImage = [[AsyncImageView alloc]init];
                ShowLikeUserImage.frame = CGRectMake(20, (GetHeight + 31) + i * 120, 50, 50);
                ShowLikeUserImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowLikeUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowLikeUserImage.layer.cornerRadius=25;
                ShowLikeUserImage.layer.borderWidth=1;
                ShowLikeUserImage.layer.masksToBounds = YES;
                ShowLikeUserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowLikeUserImage];
                NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[User_Comment_photoArray objectAtIndex:i]];
//                //   NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
//                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
//                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
//                ShowLikeUserImage.imageURL = url_UserImage;
                if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"null"] || [FullImagesURL1 isEqualToString:@"<null>"]) {
                    ShowLikeUserImage.image = [UIImage imageNamed:@"avatar.png"];
                }else{
                    NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                    ShowLikeUserImage.imageURL = url_UserImage;
                }
                [MainScroll addSubview:ShowLikeUserImage];
                
                UIButton *OpenExpertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
                // [OpenExpertsButton setImage:[UIImage imageNamed:@"PostNoComment.png"] forState:UIControlStateNormal];
                [OpenExpertsButton setFrame:CGRectMake(20, (GetHeight + 31) + i * 120, 50, 50)];
                [OpenExpertsButton setBackgroundColor:[UIColor clearColor]];
                OpenExpertsButton.tag = i;
                [OpenExpertsButton addTarget:self action:@selector(OpenExpertsButton2:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:OpenExpertsButton];
                
                UILabel *ShowUserName1 = [[UILabel alloc]init];
                ShowUserName1.frame = CGRectMake(80, (GetHeight + 31) + i * 120, 230, 20);
                ShowUserName1.text = [User_Comment_nameArray objectAtIndex:i];
                ShowUserName1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
                ShowUserName1.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                
                UILabel *ShowUserName2 = [[UILabel alloc]init];
                ShowUserName2.frame = CGRectMake(80, (GetHeight + 51) + i * 120, 230, 20);
                NSString *TempString = [[NSString alloc]initWithFormat:@"@%@",[User_Comment_usernameArray objectAtIndex:i]];
                ShowUserName2.text = TempString;
                ShowUserName2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
                ShowUserName2.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                
                UILabel *ShowCommentLabel = [[UILabel alloc]init];
                ShowCommentLabel.frame = CGRectMake(80, (GetHeight + 81) + i * 120, 230, 50);
                //  ShowCommentLabel.text = FinalString;
                ShowCommentLabel.tag = i;
                ShowCommentLabel.numberOfLines = 5;
                ShowCommentLabel.textAlignment = NSTextAlignmentLeft;
                ShowCommentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
                ShowCommentLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
                ShowCommentLabel.backgroundColor = [UIColor clearColor];
                
                NSString *TampMessage = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:i]];
                NSLog(@"TampMessage is %@",TampMessage);
                NSString *FinalString;
                NSString *FinalString_CheckName;
                
                if ([TampMessage rangeOfString:@"user:"].location == NSNotFound) {
                    NSLog(@"string does not contain user:");
                    FinalString = TampMessage;
                    [TagNameArray addObject:@"Null"];
                    ShowCommentLabel.text = FinalString;
                } else {
                    NSLog(@"string contains user:!");
                    NSString *CheckString1 = [TampMessage stringByReplacingOccurrencesOfString:@"@[user:" withString:@""];
                    NSLog(@"CheckString1 %@", CheckString1);
                    NSString* CheckString2 = [CheckString1 stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    NSLog(@"CheckString2 %@", CheckString2);
                    NSArray *SplitArray = [CheckString2 componentsSeparatedByString: @":"];
                    NSLog(@"SplitArray is %@",SplitArray);
                    FinalString = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:1]];
                    NSLog(@"FinalString is %@",FinalString);
                    
                    NSArray *SplitArray2 = [FinalString componentsSeparatedByString:@" "];
                    NSLog(@"SplitArray2 is %@",SplitArray2);
                    FinalString_CheckName = [[NSString alloc]initWithFormat:@"%@",[SplitArray2 objectAtIndex:0]];
                    NSLog(@"FinalString_CheckName is %@",FinalString_CheckName);
                    [TagNameArray addObject:FinalString_CheckName];
                    
                    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:FinalString];
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FinalString_CheckName options:kNilOptions error:nil];
                    NSRange range = NSMakeRange(0,FinalString.length);
                    [regex enumerateMatchesInString:FinalString options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                        NSRange subStringRange = [result rangeAtIndex:0];
                        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:subStringRange];
                    }];
                    [ShowCommentLabel setAttributedText:mutableAttributedString];
                    
//                    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TagNameClickButton:)];
//                    [recognizer setNumberOfTapsRequired:1];
//                    ShowCommentLabel.userInteractionEnabled = YES;
//                    [ShowCommentLabel addGestureRecognizer:recognizer];
                }
                
                UIButton *TagNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [TagNameButton setTitle:@"" forState:UIControlStateNormal];
                TagNameButton.tag = ShowCommentLabel.tag;
               // [TagNameButton setImage:[UIImage imageNamed:@"PostNoComment.png"] forState:UIControlStateNormal];
                [TagNameButton setFrame:CGRectMake(ShowCommentLabel.frame.origin.x, ShowCommentLabel.frame.origin.y, ShowCommentLabel.frame.size.width, ShowCommentLabel.frame.size.height)];
                [TagNameButton setBackgroundColor:[UIColor clearColor]];
                [TagNameButton addTarget:self action:@selector(TagNameClickButton:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:TagNameButton];
                


                
                UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
                [Line01 setTitle:@"" forState:UIControlStateNormal];
                [Line01 setFrame:CGRectMake(0, (GetHeight + 137) + i * 120, 320, 1)];
                [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
                
                [MainScroll addSubview:ShowUserName1];
                [MainScroll addSubview:ShowUserName2];
                [MainScroll addSubview:ShowCommentLabel];
                [MainScroll addSubview:Line01];
                
                FinalGetHeight = (GetHeight + 137) + i * 120;
            
                

                
                
            }
            UIButton *LineFinal = [UIButton buttonWithType:UIButtonTypeCustom];
            [LineFinal setTitle:@"" forState:UIControlStateNormal];
            [LineFinal setFrame:CGRectMake(0, FinalGetHeight, 320, 1)];
            [LineFinal setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
            [MainScroll addSubview:LineFinal];
            
//            UIButton *AddCollectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [AddCollectionButton setImage:[UIImage imageNamed:@"AddCollection.png"] forState:UIControlStateNormal];
//            [AddCollectionButton setFrame:CGRectMake(14, FinalGetHeight + 50, 133, 28)];
//            [AddCollectionButton setBackgroundColor:[UIColor clearColor]];
//            //[MoreCommendationsButton addTarget:self action:@selector(MoreCommendationsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//            [MainScroll addSubview:AddCollectionButton];
            
            NSString *TempString = [[NSString alloc]initWithFormat:@"%@ %@  %@ %@",CustomLocalisedString(@"Likes", nil),ShowLikesCount.text,CustomLocalisedString(@"CommentsBig", nil),ShowCommentCount.text];
            ShowDownText.text = TempString;
//            UILabel *AddLikeAndCommentText = [[UILabel alloc]init];
//            AddLikeAndCommentText.frame = CGRectMake(15, FinalGetHeight + 10, 150, 30);
//            AddLikeAndCommentText.text = TempString;
//            AddLikeAndCommentText.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
//            AddLikeAndCommentText.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
//            AddLikeAndCommentText.backgroundColor = [UIColor clearColor];
//            [MainScroll addSubview:AddLikeAndCommentText];
            
         //   LikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([GetLikes isEqualToString:@"0"]) {
                [LikeButton setImage:[UIImage imageNamed:@"PostNoLike.png"] forState:UIControlStateNormal];
            }else{
                [LikeButton setImage:[UIImage imageNamed:@"PostLiked.png"] forState:UIControlStateNormal];
            }
           // [LikeButton setImage:[UIImage imageNamed:@"PostNoLike.png"] forState:UIControlStateNormal];
//            [LikeButton setFrame:CGRectMake(180, FinalGetHeight + 8, 30, 30)];
//            [LikeButton setBackgroundColor:[UIColor clearColor]];
//            [LikeButton addTarget:self action:@selector(LikeButton:) forControlEvents:UIControlEventTouchUpInside];
//            [MainScroll addSubview:LikeButton];
//            
//            UIButton *CommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [CommentButton setImage:[UIImage imageNamed:@"PostNoComment.png"] forState:UIControlStateNormal];
//            [CommentButton setFrame:CGRectMake(230, FinalGetHeight + 8, 30, 30)];
//            [CommentButton setBackgroundColor:[UIColor clearColor]];
//            [CommentButton addTarget:self action:@selector(CommentButton:) forControlEvents:UIControlEventTouchUpInside];
//            [MainScroll addSubview:CommentButton];
//            
//            UIButton *ShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [ShareButton setImage:[UIImage imageNamed:@"PostShare.png"] forState:UIControlStateNormal];
//            [ShareButton setFrame:CGRectMake(280, FinalGetHeight + 8, 30, 30)];
//            [ShareButton setBackgroundColor:[UIColor clearColor]];
//             [ShareButton addTarget:self action:@selector(ShareButton:) forControlEvents:UIControlEventTouchUpInside];
//            [MainScroll addSubview:ShareButton];
            
            
            MainScroll.contentSize = CGSizeMake(320, FinalGetHeight);

        }else{
            TagNameArray = [[NSMutableArray alloc]init];
            //comment
            for (int i = 0; i < 4; i ++) {
                AsyncImageView *ShowLikeUserImage = [[AsyncImageView alloc]init];
                ShowLikeUserImage.frame = CGRectMake(20, (GetHeight + 31) + i * 120, 50, 50);
                ShowLikeUserImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowLikeUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowLikeUserImage.layer.cornerRadius=25;
                ShowLikeUserImage.layer.borderWidth=1;
                ShowLikeUserImage.layer.masksToBounds = YES;
                ShowLikeUserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowLikeUserImage];
                NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[User_Comment_photoArray objectAtIndex:i]];
                //                //   NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
                //                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                //                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                //                ShowLikeUserImage.imageURL = url_UserImage;
                if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"null"] || [FullImagesURL1 isEqualToString:@"<null>"]) {
                    ShowLikeUserImage.image = [UIImage imageNamed:@"avatar.png"];
                }else{
                    NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                    ShowLikeUserImage.imageURL = url_UserImage;
                }
                [MainScroll addSubview:ShowLikeUserImage];
                
                UIButton *OpenExpertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
                // [OpenExpertsButton setImage:[UIImage imageNamed:@"PostNoComment.png"] forState:UIControlStateNormal];
                [OpenExpertsButton setFrame:CGRectMake(20, (GetHeight + 31) + i * 120, 50, 50)];
                [OpenExpertsButton setBackgroundColor:[UIColor clearColor]];
                OpenExpertsButton.tag = i;
                [OpenExpertsButton addTarget:self action:@selector(OpenExpertsButton2:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:OpenExpertsButton];
                
                UILabel *ShowUserName1 = [[UILabel alloc]init];
                ShowUserName1.frame = CGRectMake(80, (GetHeight + 31) + i * 120, 230, 20);
                ShowUserName1.text = [User_Comment_nameArray objectAtIndex:i];
                ShowUserName1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
                ShowUserName1.textColor = [UIColor blackColor];
                
                UILabel *ShowUserName2 = [[UILabel alloc]init];
                ShowUserName2.frame = CGRectMake(80, (GetHeight + 51) + i * 120, 230, 20);
                NSString *TempString = [[NSString alloc]initWithFormat:@"@%@",[User_Comment_usernameArray objectAtIndex:i]];
                ShowUserName2.text = TempString;
                ShowUserName2.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
                ShowUserName2.textColor = [UIColor lightGrayColor];
                
                UILabel *ShowCommentLabel = [[UILabel alloc]init];
                ShowCommentLabel.frame = CGRectMake(80, (GetHeight + 81) + i * 120, 230, 50);
               // ShowCommentLabel.text = FinalString;
                ShowCommentLabel.tag = i;
                ShowCommentLabel.numberOfLines = 5;
                ShowCommentLabel.textAlignment = NSTextAlignmentLeft;
                ShowCommentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
             //   ShowCommentLabel.textColor = [UIColor blackColor];
                ShowCommentLabel.backgroundColor = [UIColor clearColor];
                ShowCommentLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
                
                NSString *TampMessage = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:i]];
                NSLog(@"TampMessage is %@",TampMessage);
                NSString *FinalString;
                NSString *FinalString_CheckName;
                
                if ([TampMessage rangeOfString:@"user:"].location == NSNotFound) {
                    NSLog(@"string does not contain user:");
                    FinalString = TampMessage;
                    [TagNameArray addObject:@"Null"];
                    ShowCommentLabel.text = FinalString;
                } else {
                    NSLog(@"string contains user:!");
                    NSString *CheckString1 = [TampMessage stringByReplacingOccurrencesOfString:@"@[user:" withString:@""];
                    NSLog(@"CheckString1 %@", CheckString1);
                    NSString* CheckString2 = [CheckString1 stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    NSLog(@"CheckString2 %@", CheckString2);
                    NSArray *SplitArray = [CheckString2 componentsSeparatedByString: @":"];
                    NSLog(@"SplitArray is %@",SplitArray);
                    FinalString = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:1]];
                    NSLog(@"FinalString is %@",FinalString);
                    
                    NSArray *SplitArray2 = [FinalString componentsSeparatedByString:@" "];
                    NSLog(@"SplitArray2 is %@",SplitArray2);
                    FinalString_CheckName = [[NSString alloc]initWithFormat:@"%@",[SplitArray2 objectAtIndex:0]];
                    NSLog(@"FinalString_CheckName is %@",FinalString_CheckName);
                    [TagNameArray addObject:FinalString_CheckName];
                    
                
                    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:FinalString];
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FinalString_CheckName options:kNilOptions error:nil];
                    NSRange range = NSMakeRange(0,FinalString.length);
                    [regex enumerateMatchesInString:FinalString options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                        NSRange subStringRange = [result rangeAtIndex:0];
                        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:subStringRange];
                    }];
                    [ShowCommentLabel setAttributedText:mutableAttributedString];
                    
//                    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TagNameClickButton:)];
//                    [recognizer setNumberOfTapsRequired:1];
//                    ShowCommentLabel.userInteractionEnabled = YES;
//                    [ShowCommentLabel addGestureRecognizer:recognizer];
                }
                

                UIButton *TagNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [TagNameButton setTitle:@"" forState:UIControlStateNormal];
                TagNameButton.tag = ShowCommentLabel.tag;
                // [TagNameButton setImage:[UIImage imageNamed:@"PostNoComment.png"] forState:UIControlStateNormal];
                [TagNameButton setFrame:CGRectMake(ShowCommentLabel.frame.origin.x, ShowCommentLabel.frame.origin.y, ShowCommentLabel.frame.size.width, ShowCommentLabel.frame.size.height)];
                [TagNameButton setBackgroundColor:[UIColor clearColor]];
                [TagNameButton addTarget:self action:@selector(TagNameClickButton:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:TagNameButton];

                
                UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
                [Line01 setTitle:@"" forState:UIControlStateNormal];
                [Line01 setFrame:CGRectMake(0, (GetHeight + 137) + i * 120, 320, 1)];
                [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
                
                [MainScroll addSubview:ShowUserName1];
                [MainScroll addSubview:ShowUserName2];
                [MainScroll addSubview:ShowCommentLabel];
                [MainScroll addSubview:Line01];
                
                FinalGetHeight = (GetHeight + 137) + i * 120;
                
            }
            
//            UIButton *SeeAllCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [SeeAllCommentButton setTitle:@"See All Comment" forState:UIControlStateNormal];
//            SeeAllCommentButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
//            // [MoreCommendationsButton setImage:[UIImage imageNamed:@"Morerecommendation.png"] forState:UIControlStateNormal];
//            [SeeAllCommentButton setFrame:CGRectMake(14, FinalGetHeight + 10, 280, 30)];
//            [SeeAllCommentButton setBackgroundColor:[UIColor clearColor]];
//            [SeeAllCommentButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//            // [MoreCommendationsButton addTarget:self action:@selector(MoreCommendationsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [MainScroll addSubview:SeeAllCommentButton];
            
            UIButton *LineFinal = [UIButton buttonWithType:UIButtonTypeCustom];
            [LineFinal setTitle:@"" forState:UIControlStateNormal];
            [LineFinal setFrame:CGRectMake(0, FinalGetHeight, 320, 1)];
            [LineFinal setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
            [MainScroll addSubview:LineFinal];
            
//            UIButton *AddCollectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [AddCollectionButton setImage:[UIImage imageNamed:@"AddCollection.png"] forState:UIControlStateNormal];
//            [AddCollectionButton setFrame:CGRectMake(14, FinalGetHeight + 50, 133, 28)];
//            [AddCollectionButton setBackgroundColor:[UIColor clearColor]];
//            // [MoreCommendationsButton addTarget:self action:@selector(MoreCommendationsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//            [MainScroll addSubview:AddCollectionButton];
            
            NSString *TempString = [[NSString alloc]initWithFormat:@"%@ %@  %@ %@",CustomLocalisedString(@"Likes", nil),ShowLikesCount.text,CustomLocalisedString(@"CommentsBig", nil),ShowCommentCount.text];
            ShowDownText.text = TempString;
//            UILabel *AddLikeAndCommentText = [[UILabel alloc]init];
//            AddLikeAndCommentText.frame = CGRectMake(15, FinalGetHeight + 10, 150, 30);
//            AddLikeAndCommentText.text = TempString;
//            AddLikeAndCommentText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
//            AddLikeAndCommentText.textColor = [UIColor blackColor];
//            AddLikeAndCommentText.backgroundColor = [UIColor clearColor];
//            [MainScroll addSubview:AddLikeAndCommentText];
            
        //    LikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([GetLikes isEqualToString:@"0"]) {
                [LikeButton setImage:[UIImage imageNamed:@"PostNoLike.png"] forState:UIControlStateNormal];
            }else{
                [LikeButton setImage:[UIImage imageNamed:@"PostLiked.png"] forState:UIControlStateNormal];
            }
//           // [LikeButton setImage:[UIImage imageNamed:@"PostNoLike.png"] forState:UIControlStateNormal];
//            [LikeButton setFrame:CGRectMake(180, FinalGetHeight + 8, 30, 30)];
//            [LikeButton setBackgroundColor:[UIColor clearColor]];
//            [LikeButton addTarget:self action:@selector(LikeButton:) forControlEvents:UIControlEventTouchUpInside];
//            [MainScroll addSubview:LikeButton];
//            
//            UIButton *CommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [CommentButton setImage:[UIImage imageNamed:@"PostNoComment.png"] forState:UIControlStateNormal];
//            [CommentButton setFrame:CGRectMake(230, FinalGetHeight + 8, 30, 30)];
//            [CommentButton setBackgroundColor:[UIColor clearColor]];
//            [CommentButton addTarget:self action:@selector(CommentButton:) forControlEvents:UIControlEventTouchUpInside];
//            [MainScroll addSubview:CommentButton];
//            
//            UIButton *ShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [ShareButton setImage:[UIImage imageNamed:@"PostShare.png"] forState:UIControlStateNormal];
//            [ShareButton setFrame:CGRectMake(280, FinalGetHeight + 8, 30, 30)];
//            [ShareButton setBackgroundColor:[UIColor clearColor]];
//            [ShareButton addTarget:self action:@selector(ShareButton:) forControlEvents:UIControlEventTouchUpInside];
//            [MainScroll addSubview:ShareButton];
            
            
            MainScroll.contentSize = CGSizeMake(320, FinalGetHeight);

        
        }
        
        
    }
    
    
    
 //   NSLog(@"ShowGoogleTranslateText is %@",ShowGoogleTranslateText);
    
}
-(IBAction)FollowingButton:(id)sender{
    NSLog(@"FollowingButton Click.");
    [self SendFollowingData];
    
}
-(void)SendFollowingData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@follow/%@",DataUrl.UserWallpaper_Url,GetUserUid];
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
    
//    //parameter first
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Attaching the key name @"parameter_first" to the post body
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\":uid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Attaching the content to be posted ( ParameterFirst )
//    [body appendData:[[NSString stringWithFormat:@"%@",GetUserUid] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"unfollow\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetUserFollowing] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
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
    
    theConnection_Following = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Following) {
      //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }

}
-(IBAction)LikeButton:(id)sender{
    NSLog(@"like post click.");
    if ([GetLikes isEqualToString:@"0"]) {
        [self SendPostLike];
        NSLog(@"like post");
    }else{
        [self GetUnLikeData];
        NSLog(@"unlike post");
    }
    
}
-(void)GetLikeData{
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@post/%@/like",DataUrl.UserWallpaper_Url,GetPostID];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetAllUserlikes = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetAllUserlikes start];
    
    
    if( theConnection_GetAllUserlikes ){
        webData = [NSMutableData data];
    }
}
-(void)GetUnLikeData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/like?token=%@",DataUrl.UserWallpaper_Url,GetPostID,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
//    NSMutableData *body = [NSMutableData data];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //parameter second
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Attaching the key name @"parameter_second" to the post body
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Attaching the content to be posted ( ParameterSecond )
//    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    //close form
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
//    
//    //setting the body of the post to the reqeust
//    [request setHTTPBody:body];
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
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
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/like",DataUrl.UserWallpaper_Url,GetPostID];
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
    
    //    //parameter first
    //    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //    //Attaching the key name @"parameter_first" to the post body
    //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\":uid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //    //Attaching the content to be posted ( ParameterFirst )
    //    [body appendData:[[NSString stringWithFormat:@"%@",GetUserUid] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    theConnection_likes = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_likes) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(IBAction)CommentButton:(id)sender{
    CommentViewController *CommentView = [[CommentViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:CommentView animated:NO completion:nil];
    [CommentView GetCommentIDArray:CommentIDArray GetPostIDArray:PostIDArray GetMessageArray:MessageArray GetUser_Comment_uidArray:User_Comment_uidArray GetUser_Comment_nameArray:User_Comment_nameArray GetUser_Comment_usernameArray:User_Comment_usernameArray GetUser_Comment_photoArray:User_Comment_photoArray];
    [CommentView GetRealPostID:GetPostID];
    CheckCommentData = 1;
}
-(IBAction)OpenExpertsButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[Like_UsernameArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)GoToSiteButton:(id)sender{

    if ([GetLink length] == 0 || GetLink == nil || [GetLink isEqualToString:@"(null)"]) {
        
    }else{
        OpenWebViewController *OpenWebView = [[OpenWebViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:OpenWebView animated:NO completion:nil];
        [OpenWebView GetTitleString:GetLink];
    }
}
-(IBAction)OpenProfileButton:(id)sender{
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:ShowUserName.text];
}
-(IBAction)OpenExpertsButton2:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[User_Comment_usernameArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)ShareButton:(id)sender{
    NSLog(@"ShareButton Click.");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"ShareToFacebook", nil),CustomLocalisedString(@"CopyLink", nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 200;
    
//    NSString *message = [NSString stringWithFormat:@"https://seeties.me/post/%@",GetPostID];
//    
//    // Check if the Facebook app is installed and we can present the share dialog
//    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
//    params.link = [NSURL URLWithString:message];
//    
//    // If the Facebook app is installed and we can present the share dialog
//    if ([FBDialogs canPresentShareDialogWithParams:params]) {
//        
//        // Present share dialog
//        [FBDialogs presentShareDialogWithLink:params.link
//                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                          if(error) {
//                                              // An error occurred, we need to handle the error
//                                              // See: https://developers.facebook.com/docs/ios/errors
//                                              NSLog(@"Error publishing story: %@", error.description);
//                                          } else {
//                                              // Success
//                                              NSLog(@"result %@", results);
//                                          }
//                                      }];
//        
//        // If the Facebook app is NOT installed and we can't present the share dialog
//    } else {
//        // FALLBACK: publish just a link using the Feed dialog
//        
//        // Put together the dialog parameters
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"", @"name",
//                                       @"", @"caption",
//                                       @"", @"description",
//                                       message, @"link",
//                                       @"", @"picture",
//                                       nil];
//        
//        // Show the feed dialog
//        [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                               parameters:params
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                      if (error) {
//                                                          // An error occurred, we need to handle the error
//                                                          // See: https://developers.facebook.com/docs/ios/errors
//                                                          NSLog(@"Error publishing story: %@", error.description);
//                                                      } else {
//                                                          if (result == FBWebDialogResultDialogNotCompleted) {
//                                                              // User canceled.
//                                                              NSLog(@"User cancelled.");
//                                                          } else {
//                                                              // Handle the publish feed callback
//                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//                                                              
//                                                              if (![urlParams valueForKey:@"post_id"]) {
//                                                                  // User canceled.
//                                                                  NSLog(@"User cancelled.");
//                                                                  
//                                                              } else {
//                                                                  // User clicked the Share button
//                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
//                                                                  NSLog(@"result %@", result);
//                                                              }
//                                                          }
//                                                      }
//                                                  }];
//    }

    
//    NSString *message = [NSString stringWithFormat:@"%@\nhttps://seeties.me/post/%@\nSent from Seeties - http://seeties.me",ShowTitle.text,GetPostID];
//
//    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
//
//    [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
//         completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
//             if (error)
//             {
//             //showing an alert for failure
//             UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Faild" message:@"Unable to share please try later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//             [ShowAlert show];
//             }else{
//             //showing an alert for success
//             UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Successfully Post." message:@"Your are successfully post to facebook." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//             [ShowAlert show];
//            }
//         }];
//    [connection start];
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(IBAction)TagNameClickButton:(id)sender{
    NSLog(@"TagNameArray is %@",TagNameArray);
    NSLog(@"TagName Click.");
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    NSLog(@"Tag Name is %@",[TagNameArray objectAtIndex:getbuttonIDN]);

    NSString *GetTagName = [[NSString alloc]initWithFormat:@"%@",[TagNameArray objectAtIndex:getbuttonIDN]];
    if ([GetTagName length] == 0 || [GetTagName isEqualToString:@"Null"]) {
        
    }else{
        ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
        [ExpertsUserProfileView GetUsername:GetTagName];
    }
}
-(IBAction)LanguageButton:(id)sender{
  //  if (CheckLanguage == 1) {
    ClickCount++;
    NSLog(@"ClickCount is %i",ClickCount);
    NSLog(@"[CountLanguageArray count] is %lu",(unsigned long)[CountLanguageArray count]);
    if (ClickCount >= [CountLanguageArray count]) {
        ClickCount = 0;
        NSString *TempGetCount = [[NSString alloc]initWithFormat:@"%@",[CountLanguageArray objectAtIndex:ClickCount]];
        CheckLanguage = [TempGetCount integerValue];
    }else{
        
        NSString *TempGetCount = [[NSString alloc]initWithFormat:@"%@",[CountLanguageArray objectAtIndex:ClickCount]];
        CheckLanguage = [TempGetCount integerValue];
    }
        switch (CheckLanguage) {
            case 0:
                break;
            case 1:
                if ([EngTitle isEqualToString:@"(null)"] || [EngTitle length] == 0) {
                    CheckLanguage = 2;
                }else{
                    GetTitle = EngTitle;
                    GetMessage = EndMessage;
                    [LanguageButton setImage:[UIImage imageNamed:@"LanguageEng.png"] forState:UIControlStateNormal];
                    CheckLanguage = 2;
                }

                break;
            case 2:
                if ([ChineseTitle isEqualToString:@"(null)"] || [ChineseTitle length] == 0) {
                    CheckLanguage = 3;
                }else{
                    GetTitle = ChineseTitle;
                    GetMessage = ChineseMessage;
                    [LanguageButton setImage:[UIImage imageNamed:@"LanguageChi.png"] forState:UIControlStateNormal];
                    CheckLanguage = 3;
                }

                break;
            case 3:
                if ([ThaiTitle isEqualToString:@"(null)"] || [ThaiTitle length] == 0) {
                    CheckLanguage = 4;
                }else{
                    GetTitle = ThaiTitle;
                    GetMessage = ThaiMessage;
                    [LanguageButton setImage:[UIImage imageNamed:@"LanguageTh.png"] forState:UIControlStateNormal];
                    CheckLanguage = 4;
                }

                break;
            case 4:
                if ([IndonesianTitle isEqualToString:@"(null)"] || [IndonesianTitle length] == 0) {
                    CheckLanguage = 5;
                }else{
                    GetTitle = IndonesianTitle;
                    GetMessage = IndonesianMessage;
                    [LanguageButton setImage:[UIImage imageNamed:@"LanguageInd.png"] forState:UIControlStateNormal];
                    CheckLanguage = 5;
                }

                break;
            case 5:
                if ([PhilippinesTitle isEqualToString:@"(null)"] || [PhilippinesTitle length] == 0) {
                    CheckLanguage = 1;
                }else{
                    GetTitle = PhilippinesTitle;
                    GetMessage = PhilippinesMessage;
                    [LanguageButton setImage:[UIImage imageNamed:@"LanguagePh.png"] forState:UIControlStateNormal];
                    CheckLanguage = 1;
                }

                break;
                
            default:
                break;
        }
     //   CheckLanguage = 2;

   // }else{
     //   CheckLanguage = 1;
//        GetTitle = ChineseTitle;
//        GetMessage = ChineseMessage;
//        [LanguageButton setImage:[UIImage imageNamed:@"LanguageChi.png"] forState:UIControlStateNormal];
   // }
    
//    // will cause trouble if you have "abc\\\\uvw"
//    NSString* esc1 = [GetMessage stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
//    NSString* esc2 = [esc1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    NSString* quoted = [[@"\"" stringByAppendingString:esc2] stringByAppendingString:@"\""];
//    NSData* data = [quoted dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* unesc = [NSPropertyListSerialization propertyListFromData:data
//                                                       mutabilityOption:NSPropertyListImmutable format:NULL
//                                                       errorDescription:NULL];
//    assert([unesc isKindOfClass:[NSString class]]);
//    NSLog(@"Output = %@", unesc);
    ShowDescription.text = GetMessage;
    ShowTitle.text = GetTitle;
    [self InitView];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 200){
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:@"Share to Facebook"]) {
            NSLog(@"Share to Facebook");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            NSString *message = [NSString stringWithFormat:@"https://seeties.me/post/%@",GetPostID];
            NSString *Description = [NSString stringWithFormat:@"%@",ShowDescription.text];
            NSString *caption = [NSString stringWithFormat:@"SEETIES.ME"];
            
            // Check if the Facebook app is installed and we can present the share dialog
            FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
            params.link = [NSURL URLWithString:message];
            
            
            // If the Facebook app is installed and we can present the share dialog
            if ([FBDialogs canPresentShareDialogWithParams:params]) {
                
                // Present share dialog
                [FBDialogs presentShareDialogWithLink:params.link
                                              handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                  if(error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                      // Success
                                                      NSLog(@"result %@", results);
                                                  }
                                              }];
                
                // If the Facebook app is NOT installed and we can't present the share dialog
            } else {
                // FALLBACK: publish just a link using the Feed dialog
                
                // Put together the dialog parameters
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               @"", @"name",
                                               caption, @"caption",
                                               Description, @"description",
                                               message, @"link",
                                               @"", @"picture",
                                               nil];
                
                // Show the feed dialog
                [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                       parameters:params
                                                          handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                              if (error) {
                                                                  // An error occurred, we need to handle the error
                                                                  // See: https://developers.facebook.com/docs/ios/errors
                                                                  NSLog(@"Error publishing story: %@", error.description);
                                                              } else {
                                                                  if (result == FBWebDialogResultDialogNotCompleted) {
                                                                      // User canceled.
                                                                      NSLog(@"User cancelled.");
                                                                  } else {
                                                                      // Handle the publish feed callback
                                                                      NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                      
                                                                      if (![urlParams valueForKey:@"post_id"]) {
                                                                          // User canceled.
                                                                          NSLog(@"User cancelled.");
                                                                          
                                                                      } else {
                                                                          // User clicked the Share button
                                                                          NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                          NSLog(@"result %@", result);
                                                                      }
                                                                  }
                                                              }
                                                          }];
            }
        }
        if ([buttonTitle isEqualToString:@"Copy Link"]) {
            NSLog(@"Copy Link");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            NSString *message = [NSString stringWithFormat:@"I was reading %@ on Seeties and I thought you might be interested in reading it too.\n\nhttps://seeties.me/post/%@\n\nSent from Seeties - http://seeties.me",ShowTitle.text,GetPostID];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = message;
        }
        
        if ([buttonTitle isEqualToString:@"Cancel Button"]) {
            NSLog(@"Cancel Button");
        }
    }
}
-(IBAction)DontShowAgainButton:(id)sender{

    TestingUse = NO;
    ShowLanguageTranslationView.hidden = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"DontShowAgain" forKey:@"DontShowAgainTranslate"];
    [defaults synchronize];
}
-(IBAction)SkipLanguageTranslationButton:(id)sender{
    TestingUse = NO;
    ShowLanguageTranslationView.hidden = YES;
}
-(IBAction)NewLanguageButton:(id)sender{
    TestingUse = YES;
    //[self InitView];
    if ([GetENMessageString length] == 0) {
        [self GetTranslateData];
    }else{
        if ([CheckENTranslation isEqualToString:@"1"]) {
            TestingUse = NO;
            CheckENTranslation = @"2";
            if ([ChineseMessage length] == 0 || ChineseMessage == nil || [ChineseMessage isEqualToString:@"(null)"]) {
                if ([EndMessage length] == 0 || EndMessage == nil || [EndMessage isEqualToString:@"(null)"]) {
                    if ([ThaiMessage length] == 0 || ThaiMessage == nil || [ThaiMessage isEqualToString:@"(null)"]) {
                        if ([IndonesianMessage length] == 0 || IndonesianMessage == nil || [IndonesianMessage isEqualToString:@"(null)"]) {
                            if ([PhilippinesMessage length] == 0 || PhilippinesMessage == nil || [PhilippinesMessage isEqualToString:@"(null)"]) {
                            }else{
                                GetMessage = PhilippinesMessage;
                                GetTitle = PhilippinesTitle;
                            }
                        }else{
                            GetMessage = IndonesianMessage;
                            GetTitle = IndonesianTitle;
                        }
                    }else{
                        GetMessage = ThaiMessage;
                        GetTitle = ThaiTitle;
                    }
                    
                }else{
                    GetMessage = EndMessage;
                    GetTitle = EngTitle;
                }
                
            }else{
                GetMessage = ChineseMessage;
                GetTitle = ChineseTitle;
            }
            ShowDescription.text = GetMessage;
            ShowTitle.text = GetTitle;
            [self InitView];
        }else{
            TestingUse = YES;
        CheckENTranslation = @"1";
            
            GetTitle = GetENTItleStirng;
            GetMessage = GetENMessageString;
            ShowDescription.text = GetMessage;
            ShowTitle.text = GetTitle;
            [self InitView];
        }
    }
    
}
-(void)GetTranslateData{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@post/%@/translate?token=%@",DataUrl.UserWallpaper_Url,GetPostID,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    //    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    //    NSLog(@"theRequest === %@",theRequest);
    //    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData                                         timeoutInterval:30];
    
    theConnection_GetTranslate = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetTranslate start];
    
    
    if( theConnection_GetTranslate ){
        webData = [NSMutableData data];
    }
}
@end
