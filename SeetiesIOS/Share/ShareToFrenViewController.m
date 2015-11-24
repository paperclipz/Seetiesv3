//
//  ShareToFrenViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 27/10/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ShareToFrenViewController.h"

@interface ShareToFrenViewController ()

@end

@implementation ShareToFrenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    MainScroll.delegate = self;
    //MainScroll.frame = CGRectMake(0, screenHeight - 450, screenWidth, 450);
    
    ShowTitle.text = LocalisedString(@"Share with your buddies!");
    ShowSendTo.text = LocalisedString(@"Send to...");
    
    SearchKeywordField.placeholder = LocalisedString(@"Username or name");
    
    BackButton.frame = CGRectMake(screenWidth - 50, 0, 50, 50);
    SearchKeywordField.frame = CGRectMake(93, 62, screenWidth - 103, 30);
    SearchKeywordField.delegate = self;
    [self GetFriendsList];
}
-(void)GetPostsID:(NSString *)PostID GetCollectionID:(NSString *)CollectionID{

    GetPostsID = PostID;
    GetCollectionID = CollectionID;
    
    NSLog(@"GetPostsID is %@ and GetCollectionID is %@",GetPostsID,GetCollectionID);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)BackButtonOnClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [SearchKeywordField resignFirstResponder];
    [self performSearch];
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if ([newString length] >= 3) {
//       // [self performSearch];
//    }else{
//        
//    }
//    
//    return YES;
//}

-(void)performSearch{
    [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/friends?token=%@&list_size=30&keyword=%@",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken,SearchKeywordField.text];;
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"GetFriendsList check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetFriendsListData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetFriendsListData start];
    if( theConnection_GetFriendsListData ){
        webData = [NSMutableData data];
    }
}

-(void)GetFriendsList{
    [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/friends?token=%@&list_size=30",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken];;
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"GetFriendsList check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetFriendsListData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetFriendsListData start];
    if( theConnection_GetFriendsListData ){
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
    if (connection == theConnection_GetFriendsListData) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"Search Keyword return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"theConnection_GetFriendsListData Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
         NSDictionary *ResData = [res valueForKey:@"data"];
         NSArray *GetAllData = (NSArray *)[ResData valueForKey:@"result"];
            //friends data
            arrUID = [[NSMutableArray alloc]init];
            arrusername = [[NSMutableArray alloc]init];
            arrProfileImg = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in GetAllData) {
                NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                [arrUID addObject:uid];
                NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [arrusername addObject:username];
                NSString *profileimg = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [arrProfileImg addObject:profileimg];
            }
            
            [self InitView];

        }
        
        
    }else if(connection == theConnection_SendCollectionata){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"theConnection_SendCollectionata return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"theConnection_SendCollectionata Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            [TSMessage showNotificationWithTitle:@"System" subtitle:LocalisedString(@"Success Send to Friends") type:TSMessageNotificationTypeSuccess];
        }else{
            
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            [TSMessage showNotificationWithTitle:@"System" subtitle:MessageString type:TSMessageNotificationTypeError];

        }
        
    }else if(connection == theConnection_SendPostsData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"Search Keyword return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"theConnection_SendPostsData Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            [TSMessage showNotificationWithTitle:@"System" subtitle:LocalisedString(@"Success Send to Friends") type:TSMessageNotificationTypeSuccess];
        }else{
            
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            [TSMessage showNotificationWithTitle:@"System" subtitle:MessageString type:TSMessageNotificationTypeError];
        }
        
    }
    
    
    [ShowActivity stopAnimating];
}
-(void)InitView{
    for (UIView *subview in MainScroll.subviews) {
        // if ([subview isKindOfClass:[UIButton class]])
        [subview removeFromSuperview];
    }
    
    [MainScroll addSubview:ShowTitle];
    [MainScroll addSubview:BackButton];
    [MainScroll addSubview:Line01];
    [MainScroll addSubview:ShowSendTo];
    [MainScroll addSubview:SearchKeywordField];
    [MainScroll addSubview:Line02];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    for (int i = 0; i < [arrUID count]; i ++) {
        
        AsyncImageView *UserImage = [[AsyncImageView alloc]init];
        UserImage.frame = CGRectMake(20, 108 + i * 45, 28, 28);
        UserImage.contentMode = UIViewContentModeScaleAspectFill;
        UserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        UserImage.layer.cornerRadius=14;
        UserImage.layer.borderWidth=0;
        UserImage.layer.masksToBounds = YES;
        UserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[arrProfileImg objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            UserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            UserImage.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview:UserImage];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(68, 112 + i * 45, screenWidth - 88, 20);
        ShowUserName.text = [arrusername objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [MainScroll addSubview:ShowUserName];
        
        UIButton *ButtonClick = [UIButton buttonWithType:UIButtonTypeCustom];
        [ButtonClick setTitle:@"" forState:UIControlStateNormal];
        [ButtonClick setFrame:CGRectMake(20, 112 + i * 45, screenWidth - 40, 44)];
        [ButtonClick setBackgroundColor:[UIColor clearColor]];
        ButtonClick.tag = i;
        [ButtonClick addTarget:self action:@selector(FriendListButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ButtonClick];
        
        
        UIButton *TempLine01 = [[UIButton alloc]init];
        TempLine01.frame = CGRectMake(20, 145 + i * 45, screenWidth, 1);
        [TempLine01 setTitle:@"" forState:UIControlStateNormal];//238
        [TempLine01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:TempLine01];
        
        MainScroll.contentSize = CGSizeMake(screenWidth, 145 + i * 45);
        
    }

}
-(IBAction)FriendListButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    ShareUserUID = [[NSString alloc]initWithFormat:@"%@",[arrUID objectAtIndex:getbuttonIDN]];
    
    if ([GetPostsID length] == 0 || [GetPostsID isEqualToString:@""] || [GetPostsID isEqualToString:@"(null)"] || [GetPostsID isEqualToString:@"<null>"]) {
        [self SendCollectionToFriend];
    }else{
        [self SendPostsToFriend];
    }
    
}
-(void)SendPostsToFriend{
    [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [[NSString alloc]initWithFormat:@"%@/post/%@/share",DataUrl.UserWallpaper_Url,GetPostsID];
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
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_ids[0]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",ShareUserUID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_SendPostsData = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_SendPostsData) {
        webData = [NSMutableData data];
    } else {
    }
}
-(void)SendCollectionToFriend{
    [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [[NSString alloc]initWithFormat:@"%@%@/collections/%@/share",DataUrl.UserWallpaper_Url,Getuid,GetCollectionID];
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
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_ids[0]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",ShareUserUID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_SendCollectionata = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_SendCollectionata) {
        webData = [NSMutableData data];
    } else {
    }
}
@end
