//
//  NewCollectionViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NewCollectionViewController.h"

@interface NewCollectionViewController ()

@end

@implementation NewCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 700)];
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64 - 61);
    SetPublicView.frame = CGRectMake(0, screenHeight - 61, screenWidth, 61);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    NameTextView.frame = CGRectMake(20, 37, screenWidth - 40, 67);
    ShowNameCount.frame = CGRectMake(screenWidth - 20 - 80, 104, 80, 21);
    
    DescriptionTextView.frame = CGRectMake(20, 146, screenWidth - 40, 100);
    ShowDescriptionCount.frame = CGRectMake(screenWidth - 20 - 80, 247, 80, 21);
    
    TagsField.frame = CGRectMake(15, 13, screenWidth - 70, 30);
    TagsField.delegate = self;
    NameTextView.delegate = self;
    DescriptionTextView.delegate = self;
   
    [Utils setRoundBorder:NameTextView color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f borderWidth:1.0f];
    [Utils setRoundBorder:DescriptionTextView color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f borderWidth:1.0f];

    NameTextView.text = LocalisedString(@"eg: Top 10 coffee hideouts in KL, Best spas in Bangkok");
    DescriptionTextView.text = LocalisedString(@"Write a description");
    
    TickButton.frame = CGRectMake(screenWidth - 61, 0, 61, 61);
    SaveButton.frame = CGRectMake(screenWidth - 60, 20, 60, 44);
    
    SetTagsView.frame = CGRectMake(20, 300, screenWidth - 40, 200);
    [Utils setRoundBorder:SetTagsView color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f borderWidth:1.0f];
    
    TagsLine.frame = CGRectMake(0, 50, screenWidth - 40 , 1);
    
    SetPublic = @"0";
    CheckString = 0;
    
    ShowTitle.text = LocalisedString(@"New Collection");
    CollectionTitle.text = LocalisedString(@"Collection title");
    DescriptionTitle.text = LocalisedString(@"Collection description");
    TagTitle.text = LocalisedString(@"Tag it");
    SetasPublicTitle.text = LocalisedString(@"Set as public");
    SubTitleSetasPublic.text = LocalisedString(@"You will not be able to change your privacy settings for this collection once it goes public.");
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight, screenWidth, 50);
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
}
-(IBAction)BackButton:(id)sender{
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [NameTextView resignFirstResponder];
    [DescriptionTextView resignFirstResponder];
    [TagsField resignFirstResponder];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"did begin editing");
    if (textView == NameTextView) {
        if ([NameTextView.text isEqualToString:LocalisedString(@"eg: Top 10 coffee hideouts in KL, Best spas in Bangkok")]) {
            NameTextView.text = @"";
        }
    }else if (textView == DescriptionTextView){
        if ([DescriptionTextView.text isEqualToString:LocalisedString(@"Write a description")]) {
            DescriptionTextView.text = @"";
        }
    }
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == NameTextView) {
        NSUInteger len = textView.text.length;
        ShowNameCount.text = [NSString stringWithFormat:@"%lu / 70",70 - len];
        ShowNameCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    }else if(textView == DescriptionTextView){
        NSUInteger len = textView.text.length;
        ShowDescriptionCount.text = [NSString stringWithFormat:@"%lu / 150",150 - len];
        ShowDescriptionCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString length] >= 2) {
        TagsString = newString;
        if (CheckString == 0) {
             [self GetSearchText];
        }
        
       
    }else{
        CheckString = 0;
    }
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == NameTextView) {
        if ([text isEqualToString:@"\n"]) {
            // Be sure to test for equality using the "isEqualToString" message
            [textView resignFirstResponder];
            // Return FALSE so that the final '\n' character doesn't get added
            return FALSE;
        }else{
            if([text length] == 0)
            {
                if([textView.text length] != 0)
                {
                    return YES;
                }
            }
            else if([[textView text] length] >= 70)
            {
                ShowNameCount.text = @"0 / 70";
                ShowNameCount.textColor = [UIColor redColor];
                return NO;
            }
        }
    }else{
        if ([text isEqualToString:@"\n"]) {
            // Be sure to test for equality using the "isEqualToString" message
            [textView resignFirstResponder];
            // Return FALSE so that the final '\n' character doesn't get added
            return FALSE;
        }else{
            if([text length] == 0)
            {
                if([textView.text length] != 0)
                {
                    return YES;
                }
            }
            else if([[textView text] length] >= 150)
            {
                ShowDescriptionCount.text = @"0 / 150";
                ShowDescriptionCount.textColor = [UIColor redColor];
                return NO;
            }
        }
    }
    
    
    
    return YES;
}
-(void)GetSearchText{
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@tags?keyword=%@",DataUrl.UserWallpaper_Url,TagsString];

    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_GetTagsString = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetTagsString start];
    
    if( theConnection_GetTagsString ){
        webData = [NSMutableData data];
    }
}
-(IBAction)SaveButton:(id)sender{
    NSLog(@"Save Button On Click");
    
    NSLog(@"NameTextView === %@",NameTextView.text);
    NSLog(@"DescriptionTextView === %@",DescriptionTextView.text);
    NSLog(@"TagsField === %@",TagsField.text);
    NSLog(@"SetPublic === %@",SetPublic);
    
    if ([NameTextView.text isEqualToString:LocalisedString(@"eg: Top 10 coffee hideouts in KL, Best spas in Bangkok")] || [NameTextView.text isEqualToString:@""] || [NameTextView.text length] == 0) {
        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Collection name must be at least 1 characters" type:TSMessageNotificationTypeError];
    }else{
        [self CreateNewCollection];
    }
    
    
}
-(IBAction)TickButton:(id)sender{
    NSLog(@"Tick Button On Click");
    TickButton.selected=!TickButton.selected;
    if (TickButton.selected) {
        SetPublic = @"0";
    }else{
        SetPublic = @"1";
    }
    NSLog(@"SetPublic is %@",SetPublic);
}
-(void)CreateNewCollection{
    [ShowActivity startAnimating];
    
    if ([NameTextView.text isEqualToString:LocalisedString(@"eg: Top 10 coffee hideouts in KL, Best spas in Bangkok")]) {
        NameTextView.text = @"";
    }
    if ([DescriptionTextView.text isEqualToString:LocalisedString(@"Write a description")]) {
        DescriptionTextView.text = @"";
    }
    
    if ([TagsField.text isEqualToString:@""]) {
        TagsField.text = @"";
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetUseruid = [defaults objectForKey:@"Useruid"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections",DataUrl.UserWallpaper_Url,GetUseruid];
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
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",NameTextView.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"access\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",SetPublic] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ([DescriptionTextView.text length] == 0) {
        
    }else{
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",DescriptionTextView.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([TagsField.text length] == 0) {
        
    }else{
        NSArray *TempTagsArray = [TagsField.text componentsSeparatedByString:@","];
        for (int i = 0; i < [TempTagsArray count]; i++) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tags[%i]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@"%@",[TempTagsArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_CreateCollection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_CreateCollection) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    SaveButton.enabled = YES;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_CreateCollection) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        // NSLog(@"Edit Profile return get data to server ===== %@",GetData);
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Create new collection return data ===== %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        
        if ([statusString isEqualToString:@"ok"]) {
            [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Create New Collections" type:TSMessageNotificationTypeSuccess];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [TSMessage showNotificationInViewController:self title:@"" subtitle:MessageString type:TSMessageNotificationTypeError];
        }
        
        [ShowActivity stopAnimating];
    }else if(connection == theConnection_GetTagsString){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        // NSLog(@"Edit Profile return get data to server ===== %@",GetData);
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
       // NSLog(@"tags return data ===== %@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSString *StatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
            if ([StatusString isEqualToString:@"ok"]) {
                NSDictionary *GetAllData = [res valueForKey:@"data"];
                
                NSArray *GetStringData = (NSArray *)[GetAllData valueForKey:@"simple"];
                //NSLog(@"GetStringData is %@",GetStringData);
                
                TagsArray = [[NSMutableArray alloc]initWithArray:GetStringData];
                if ([TagsArray count] == 0) {
                    
                }else{
                    CheckString = 1;
                    [self ShowTagsView];
                }
            }
        
        }
    }
}

-(void)ShowTagsView{
    
    UIScrollView *HashTagScroll = [[UIScrollView alloc]init];
    HashTagScroll.delegate = self;
    HashTagScroll.frame = CGRectMake(0, 85, SetTagsView.frame.size.width - 5, 50);
    HashTagScroll.backgroundColor = [UIColor whiteColor];
    [SetTagsView addSubview:HashTagScroll];
    CGRect frame2 = {0,0};
    
    for (int i= 0; i < [TagsArray count]; i++) {
        UILabel *ShowHashTagText = [[UILabel alloc]init];
        ShowHashTagText.text = [NSString stringWithCString:[[TagsArray objectAtIndex:i] UTF8String] encoding:NSUTF8StringEncoding];
        ShowHashTagText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:12];
        ShowHashTagText.textAlignment = NSTextAlignmentCenter;
        ShowHashTagText.backgroundColor = [UIColor whiteColor];
        ShowHashTagText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowHashTagText.layer.cornerRadius = 5;
        ShowHashTagText.layer.borderWidth = 1;
        ShowHashTagText.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
        
        NSString *Text = [NSString stringWithCString:[[TagsArray objectAtIndex:i] UTF8String] encoding:NSUTF8StringEncoding];
        CGRect r = [Text boundingRectWithSize:CGSizeMake(200, 0)
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:12]}
                                      context:nil];

        UIButton *TagsButton = [[UIButton alloc]init];
        [TagsButton setTitle:@"" forState:UIControlStateNormal];
        TagsButton.backgroundColor = [UIColor clearColor];
        TagsButton.tag = i;
        TagsButton.frame = CGRectMake(15 + frame2.size.width, 15, r.size.width + 20, 20);
        [TagsButton addTarget:self action:@selector(PersonalTagsButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        ShowHashTagText.frame = CGRectMake(15 + frame2.size.width, 15, r.size.width + 20, 20);
        frame2.size.width += r.size.width + 30;
        [HashTagScroll addSubview:ShowHashTagText];
        [HashTagScroll addSubview:TagsButton];
        
        HashTagScroll.contentSize = CGSizeMake(30 + frame2.size.width , 50);
    }
}
-(IBAction)PersonalTagsButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *GetTagsString = [[NSString alloc]initWithFormat:@"%@",[TagsArray objectAtIndex:getbuttonIDN]];
    //NSLog(@"ArrHashTag is %@",GetTagsString);
    NSString *joinedString = [@[TagsField.text, GetTagsString] componentsJoinedByString:@","];
    TagsField.text = joinedString;
}
@end
