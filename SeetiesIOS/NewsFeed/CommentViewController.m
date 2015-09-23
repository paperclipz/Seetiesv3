//
//  CommentViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "CommentViewController.h"
#import "NewUserProfileV2ViewController.h"
#import "AsyncImageView.h"

#import "LanguageManager.h"
#import "Locale.h"

#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140
@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize inputToolbar;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    

    [sendButton setTitle:CustomLocalisedString(@"Send", nil) forState:UIControlStateNormal];

    
    //ShowNoDataView.frame = CGRectMake(0, 0, screenWidth, [UIScreen mainScreen].bounds.size.height);
    ShowNoDataView.hidden = YES;
    DataUrl = [[UrlDataClass alloc]init];
    
    ShowNoDataText_1.frame = CGRectMake(15, (screenHeight / 2) - 141, screenWidth - 30, 21);
    ShowNoDataText_2.frame = CGRectMake((screenWidth/2) - 126, (screenHeight / 2) - 120, 253, 62);
    ShowNoDataText_1.text = CustomLocalisedString(@"NoComment", nil);
    ShowNoDataText_2.text = CustomLocalisedString(@"FristComment", nil);
    
    BlackgroundButton.clipsToBounds = YES;
    BlackgroundButton.layer.cornerRadius = 10;//half of the width
    
    BlackgroundWhiteButton.clipsToBounds = YES;
    BlackgroundWhiteButton.layer.cornerRadius = 10;

    ShowMainTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    MainScroll.frame = CGRectMake(0, 120, screenWidth, screenHeight - 164);
    LikeScroll.frame = CGRectMake(0, 120, screenWidth, screenHeight - 164);
    CollectionsScroll.frame = CGRectMake(0, 120, screenWidth, screenHeight - 164);
    toolBar.frame = CGRectMake(0, screenHeight - 44, screenWidth, 44);
    TextString.frame = CGRectMake(8, 8, screenWidth - 64 - 8 - 10, 30);
    sendButton.frame = CGRectMake(screenWidth - 64, 0, 64, 44);
    ShowNoDataView.frame = CGRectMake(0, 120, screenWidth, screenHeight);
    NoCommentImage.frame = CGRectMake((screenWidth/2) - 160, 0, 320, 568);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    MainScroll.delegate = self;
    LikeScroll.delegate = self;
    LikeScroll.hidden = YES;
    CollectionsScroll.delegate = self;
    CollectionsScroll.hidden = YES;
    
    /* Calculate screen size */
  //  CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    /* Create toolbar */
//    self.inputToolbar = [[BHInputToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-20, screenFrame.size.width, kDefaultToolbarHeight)];
//    [self.view addSubview:self.inputToolbar];
//    inputToolbar.inputDelegate = self;
//    inputToolbar.textView.placeholder = @"Placeholder";
    

    
    TextString.delegate = self;
    
    isFirstShowKeyboard = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    checkDataLoading = 0;
    checkagain = 0;
    MentionsView.hidden = YES;
    MentionsView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:MentionsView];
   // [self.view addSubview:ShowNoDataView];
    
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /* Listen for keyboard */
    self.screenName = @"IOS Comment Page";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    isKeyboardShowing = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = MainScroll.frame;
                         frame.size.height += keyboardHeight;
                         frame.size.height -= keyboardRect.size.height;
                         MainScroll.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
                     }];
    
    if ( isFirstShowKeyboard ) {
        
        isFirstShowKeyboard = NO;
        
        isSystemBoardShow = !isButtonClicked;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = MainScroll.frame;
                         frame.size.height += keyboardHeight;
                         MainScroll.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
    isKeyboardShowing = NO;
    
    if ( isButtonClicked ) {
        
        isButtonClicked = NO;
        
        [TextString becomeFirstResponder];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
[TextString resignFirstResponder];
}
-(IBAction)SendButton:(id)sender{
    [TextString resignFirstResponder];
    if ([TextString.text length] == 0) {
        
    }else{
        GetMessage = TextString.text;
        [self SendMessageToServer];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"newString is %@",newString);
    //[self updateTextLabelsWithText: newString];
    if([newString rangeOfString:@"@"].location == NSNotFound)
    {
        NSLog(@"not found");
        MentionsView.hidden = YES;
    }
    else
    {
        NSLog(@"found");
        
            NSArray *CheckStringArray = [newString componentsSeparatedByString:@"@"];
            NSLog(@"CheckStringArray is %@",CheckStringArray);
            NSString *GetString = [CheckStringArray objectAtIndex: 1];
            if ([GetString length] > 1) {
            GetMentionsString = GetString;
            if (checkDataLoading == 0) {
                NSLog(@"1 here ......");
                [self SendMentionsToServer];
            }else{
                NSLog(@"2 here ......");
           // [self SendMentionsToServer];
            }
        
          //  [NSThread detachNewThreadSelector:@selector(SendMentionsToServer) toTarget:self withObject:nil];
        }else{
        
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];

    return YES;
}
//-(void)inputButtonPressed:(NSString *)inputText
//{
//    /* Called when toolbar button is pressed */
//    NSLog(@"Pressed button with text: '%@'", inputText);
//    if ([inputText length] == 0) {
//        
//    }else{
//        GetMessage = inputText;
//        [self SendMessageToServer];
//    }
//}

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
-(void)GetRealPostID:(NSString *)PostID{

    GetPostIDN = PostID;
    NSLog(@"GetPostIDN is %@",GetPostIDN);
    
    [self GetLikeData];
}
-(void)GetRealPostIDAndAllComment:(NSString *)PostIDN{

    GetPostIDN = PostIDN;
    [self GetCommentData];
}
-(void)GetCommentIDArray:(NSMutableArray *)CommentIDArray GetPostIDArray:(NSMutableArray *)PostIDArray GetMessageArray:(NSMutableArray *)MessageArray GetUser_Comment_uidArray:(NSMutableArray *)User_Comment_uidArray GetUser_Comment_nameArray:(NSMutableArray *)User_Comment_nameArray GetUser_Comment_usernameArray:(NSMutableArray *)User_Comment_usernameArray GetUser_Comment_photoArray:(NSMutableArray *)User_Comment_photoArray{
    
    NSLog(@"GetPostIDArray is %@",GetPostIDArray);

    GetCommentIDArray = [[NSMutableArray alloc]initWithArray:CommentIDArray];
    GetPostIDArray = [[NSMutableArray alloc]initWithArray:PostIDArray];
    GetMessageArray = [[NSMutableArray alloc]initWithArray:MessageArray];
    GetUser_Comment_uidArray = [[NSMutableArray alloc]initWithArray:User_Comment_uidArray];
    GetUser_Comment_nameArray = [[NSMutableArray alloc]initWithArray:User_Comment_nameArray];
    GetUser_Comment_usernameArray = [[NSMutableArray alloc]initWithArray:User_Comment_usernameArray];
    GetUser_Comment_photoArray = [[NSMutableArray alloc]initWithArray:User_Comment_photoArray];
    if ([GetMessageArray count] == 0) {
        ShowNoDataView.hidden = NO;
    }
   // NSLog(@"GetPostIDArray is %@",GetPostIDArray);
    
    [self InitView];
    
}
-(void)GetWhatView:(NSString *)WhatView{
    GetWhatView = WhatView;
    
  //  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSArray *itemArray = [NSArray arrayWithObjects:@"Comments",@"Collections", @"Likes", nil];
    UISegmentedControl *PostControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    PostControl.frame = CGRectMake(15, 80, screenWidth - 30, 29);
    [PostControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    
    if ([GetWhatView isEqualToString:@"Like"]) {
        PostControl.selectedSegmentIndex = 2;
      //  ShowMainTitle.text = CustomLocalisedString(@"MainTab_Like", nil);
    }else{
       // ShowMainTitle.text = CustomLocalisedString(@"Comments", nil);
        PostControl.selectedSegmentIndex = 0;
    }
    ShowMainTitle.text = @"All activites";
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
    [self.view addSubview:PostControl];
    
    if ([GetWhatView isEqualToString:@"Like"]) {
        MainScroll.hidden = YES;
        toolBar.hidden = YES;
        LikeScroll.hidden = NO;
        ShowNoDataView.hidden = YES;
    }else{
        [TextString becomeFirstResponder];
        MainScroll.hidden = NO;
        toolBar.hidden = NO;
        if ([GetMessageArray count] == 0) {
            ShowNoDataView.hidden = NO;
        }else{
            ShowNoDataView.hidden = YES;
        }
        LikeScroll.hidden = YES;
    }
}
-(void)GetLikeData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@post/%@/like?token=%@",DataUrl.UserWallpaper_Url,GetPostIDN,GetExpertToken];
    
    
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
-(void)InitView{
    
   CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    TagNameArray = [[NSMutableArray alloc]init];
    
    
    GetCommentIDArray = [[[GetCommentIDArray reverseObjectEnumerator] allObjects]mutableCopy];
    GetPostIDArray = [[[GetPostIDArray reverseObjectEnumerator] allObjects]mutableCopy];
    GetMessageArray = [[[GetMessageArray reverseObjectEnumerator] allObjects]mutableCopy];
    GetUser_Comment_uidArray = [[[GetUser_Comment_uidArray reverseObjectEnumerator] allObjects]mutableCopy];
    GetUser_Comment_nameArray = [[[GetUser_Comment_nameArray reverseObjectEnumerator] allObjects]mutableCopy];
    GetUser_Comment_usernameArray = [[[GetUser_Comment_usernameArray reverseObjectEnumerator] allObjects]mutableCopy];
    GetUser_Comment_photoArray = [[[GetUser_Comment_photoArray reverseObjectEnumerator] allObjects]mutableCopy];
    
    
    //comment
    int GetFinalHeight = 0;
    for (int i = 0; i < [GetMessageArray count]; i ++) {
        int GetHeight = 0;
        GetFinalHeight += 10;
        
        AsyncImageView *ShowLikeUserImage = [[AsyncImageView alloc]init];
        ShowLikeUserImage.frame = CGRectMake(20, GetFinalHeight + i, 50, 50);
        ShowLikeUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowLikeUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowLikeUserImage.layer.cornerRadius=25;
        ShowLikeUserImage.layer.borderWidth=1;
        ShowLikeUserImage.layer.masksToBounds = YES;
        ShowLikeUserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowLikeUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[GetUser_Comment_photoArray objectAtIndex:i]];
        if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"null"] || [FullImagesURL1 isEqualToString:@"<null>"]) {
            ShowLikeUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowLikeUserImage.imageURL = url_UserImage;
        }
        [MainScroll addSubview:ShowLikeUserImage];
        
        UIButton *OpenExpertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [OpenExpertsButton setFrame:CGRectMake(20,  GetFinalHeight + i, 50, 50)];
        [OpenExpertsButton setBackgroundColor:[UIColor clearColor]];
        OpenExpertsButton.tag = i;
        [OpenExpertsButton addTarget:self action:@selector(OpenExpertsButton2:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:OpenExpertsButton];
        
        GetFinalHeight += 5;
        
        UILabel *ShowUserName1 = [[UILabel alloc]init];
        ShowUserName1.frame = CGRectMake(80, GetFinalHeight + i, screenWidth - 95, 20);
        ShowUserName1.text = [GetUser_Comment_usernameArray objectAtIndex:i];
        ShowUserName1.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:14];
        ShowUserName1.backgroundColor = [UIColor clearColor];
        ShowUserName1.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        
        GetFinalHeight += 15;
        
        UITextView *ShowCommentLabel = [[UITextView alloc]init];
        //ShowCommentLabel.frame = CGRectMake(80, 35 + i * 120, screenWidth - 95, 70);
        ShowCommentLabel.scrollEnabled = NO;
        ShowCommentLabel.editable = NO;
        ShowCommentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowCommentLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        ShowCommentLabel.backgroundColor = [UIColor clearColor];
        ShowCommentLabel.tag = i;
        

        
        
        NSString *TampMessage = [[NSString alloc]initWithFormat:@"%@",[GetMessageArray objectAtIndex:i]];
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
            FinalString_CheckName = [[NSString alloc]initWithFormat:@"@%@",[SplitArray2 objectAtIndex:0]];
            NSLog(@"FinalString_CheckName is %@",FinalString_CheckName);
            [TagNameArray addObject:[SplitArray2 objectAtIndex:0]];
            NSMutableArray *TampArray = [[NSMutableArray alloc]initWithArray:SplitArray2];
            [TampArray replaceObjectAtIndex:0 withObject:FinalString_CheckName];
            
            NSString *FinalResultFullString = [TampArray componentsJoinedByString:@" "];
            
            
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:FinalResultFullString];
            [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:14] range:NSMakeRange(0, FinalResultFullString.length)];
            [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] range:NSMakeRange(0, FinalResultFullString.length)];
            NSLog(@"mutableAttributedString is %@",mutableAttributedString);
            NSLog(@"FinalString is %@",FinalString);
            NSLog(@"FinalString_CheckName is %@",FinalString_CheckName);
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FinalString_CheckName  options:kNilOptions error:nil];
            NSRange range = NSMakeRange(0,FinalResultFullString.length);
            [regex enumerateMatchesInString:FinalResultFullString options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                NSRange subStringRange = [result rangeAtIndex:0];
                [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:subStringRange];
            }];
            [ShowCommentLabel setAttributedText:mutableAttributedString];
        }
        if([ShowCommentLabel sizeThatFits:CGSizeMake(screenWidth - 95, CGFLOAT_MAX)].height!=ShowCommentLabel.frame.size.height)
        {
            GetHeight += [ShowCommentLabel sizeThatFits:CGSizeMake(screenWidth - 95, CGFLOAT_MAX)].height + 10;
            ShowCommentLabel.frame = CGRectMake(80,GetFinalHeight + i, screenWidth - 95,[ShowCommentLabel sizeThatFits:CGSizeMake(screenWidth - 95, CGFLOAT_MAX)].height);
        }
        GetFinalHeight += GetHeight;
        
        UIButton *TagNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [TagNameButton setTitle:@"" forState:UIControlStateNormal];
        TagNameButton.tag = ShowCommentLabel.tag;
        // [TagNameButton setImage:[UIImage imageNamed:@"PostNoComment.png"] forState:UIControlStateNormal];
        [TagNameButton setFrame:CGRectMake(ShowCommentLabel.frame.origin.x, ShowCommentLabel.frame.origin.y, ShowCommentLabel.frame.size.width, ShowCommentLabel.frame.size.height)];
        [TagNameButton setBackgroundColor:[UIColor clearColor]];
        [TagNameButton addTarget:self action:@selector(TagNameClickButton:) forControlEvents:UIControlEventTouchUpInside];
       
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [TagNameButton addGestureRecognizer:longPress];
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, GetFinalHeight + i, screenWidth, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        [MainScroll addSubview:ShowUserName1];
       // [MainScroll addSubview:ShowUserName2];
        [MainScroll addSubview:ShowCommentLabel];
        [MainScroll addSubview:TagNameButton];
        [MainScroll addSubview:Line01];
       //  MainScroll.contentSize = CGSizeMake(screenWidth, GetFinalHeight + i * GetHeight);
        MainScroll.contentSize = CGSizeMake(screenWidth, GetFinalHeight);
        
    }
    [MainScroll scrollRectToVisible:CGRectMake(MainScroll.contentSize.width - 1,MainScroll.contentSize.height - 1, 1, 1) animated:YES];
    

}
- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    NSLog(@"gesture.view.tag is %ld",(long)gesture.view.tag);
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Long Press");
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetUserUid = [defaults objectForKey:@"Useruid"];
        NSLog(@"GetUserUid is %@",GetUserUid);
        
        GetDeletePostID = [[NSString alloc]initWithFormat:@"%@",[GetPostIDArray objectAtIndex:0]];
        GetDeleteCommentID = [[NSString alloc]initWithFormat:@"%@",[GetCommentIDArray objectAtIndex:gesture.view.tag]];
        
        
        if ([GetUserUid isEqualToString:[GetUser_Comment_uidArray objectAtIndex:gesture.view.tag]]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"DeleteMessage", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) otherButtonTitles:CustomLocalisedString(@"Delete", nil), nil];
            alert.tag = 999;
            [alert show];
        }else{
        
        }
        
        NSLog(@"GetUser_Comment_uidArray is %@",GetUser_Comment_uidArray);
        NSLog(@"GetPostIDArray is %@",GetPostIDArray);
        NSLog(@"GetCommentIDArray is %@",GetCommentIDArray);
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 999) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
        }else{
            //reset clicked
            NSLog(@"Confirm delete");
            [self SendDeleteMessageToServer];
        }
    }

}
-(void)SendDeleteMessageToServer{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/comment/%@/?token=%@",DataUrl.UserWallpaper_Url,GetDeletePostID,GetDeleteCommentID,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];

    
    theConnection_DeleteCommentData = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_DeleteCommentData) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)SendMentionsToServer{
    checkDataLoading = 1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    GetMentionsString = [GetMentionsString stringByReplacingOccurrencesOfString:@"@" withString:@""];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@mentions?token=%@&post_id=%@&s=%@",DataUrl.UserWallpaper_Url,GetExpertToken,GetPostIDN,GetMentionsString];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_Mentions = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_Mentions start];
    
    
    if( theConnection_Mentions ){
        webData = [NSMutableData data];
    }
}
-(void)SendMessageToServer{
    [ShowActivity startAnimating];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/comment",DataUrl.UserWallpaper_Url,GetPostIDN];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    

    
    //1063655260 + CAAGxtEzl7IABANzd8VBZCZAF3YUMAfiambyQ2orfrQ7rE4CEv3uVPZBahkXFFdRmuuZA0CzKZBiHDfUiot9UV3ijM5OddrKh3vcuDZCMCVEvjZBxDdocFAB1omPpVQHuQ9JTdbC58gsdquDicDVtFZBXLTHGOWNF9sVTL39rtBz5Js1dI6ctC3cgolSF6Aqlc54j9lIuvO6UJ7ehPDXGiMx5q1HMZBZBzPVOZCheBR1xTkT5qFauwOpNmu5
    
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
    
    if ([GetMentionsUID length] == 0 || GetMentionsUID == nil ) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetMessage] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }else{
        NSString *TestString;
        NSArray *stringArray = [GetMessage componentsSeparatedByString:@" "];
        NSLog(@"stringArray is %@",stringArray);
        NSMutableArray *TestArray = [[NSMutableArray alloc]initWithArray:stringArray];
        for (int i = 0; i < [stringArray count]; i++) {
            NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[stringArray objectAtIndex:i]];
            if ([TempString rangeOfString:@"@"].location == NSNotFound) {
                NSLog(@"no ?");
            } else {
                NSLog(@"with @ ?");
                NSString *TestAgain = [[NSString alloc]initWithFormat:@"@[user:%@]",GetMentionsUID];
                NSLog(@"TestAgain is %@",TestAgain);
                [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                NSLog(@"TestArray is %@",TestArray);
                TestString = [TestArray componentsJoinedByString:@" "];
                NSLog(@"TestString is %@",TestString);
                break;
            }
        }
//parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",TestString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
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
    
    theConnection_Comment = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Comment) {
        NSLog(@"Connection Successful");
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
    [ShowActivity stopAnimating];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Connection" message:@"Check your wifi or 3G data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_Comment) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Post Comment return get data to server ===== %@",GetData);
        [ShowActivity stopAnimating];
        TextString.text = @"";
        GetMentionsString = @"";
        GetMentionsUID = @"";
        GetMessage = @"";
        [self GetCommentData];
        

    }else if(connection == theConnection_Mentions){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Mentions return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
        NSArray *GetAllData = (NSArray *)[res valueForKey:@"result"];

        Mentions_UsernameArray = [[NSMutableArray alloc]init];
        Mentions_NameArray = [[NSMutableArray alloc]init];
        Mentions_ProfilePhotoArray = [[NSMutableArray alloc]init];
        Mentions_uidArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dict in GetAllData) {
            NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
            [Mentions_UsernameArray addObject:username];
            NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
            [Mentions_NameArray addObject:name];
            NSString *profile_photo = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
            [Mentions_ProfilePhotoArray addObject:profile_photo];
            NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
            [Mentions_uidArray addObject:uid];
        }
        [MetionsTblview reloadData];
        NSLog(@"Mentions_UsernameArray is %@",Mentions_UsernameArray);
        
        NSInteger CheckCount = [Mentions_NameArray count];
        NSLog(@"toolBar x is %f",toolBar.frame.origin.x);
        NSLog(@"toolBar y is %f",toolBar.frame.origin.y);
        NSLog(@"toolBar height is %f",toolBar.frame.size.height);
        NSLog(@"toolBar width is %f",toolBar.frame.size.width);
        if (CheckCount == 1) {
            NSLog(@"1");
//            BlackgroundButton.frame = CGRectMake(29, 199, 202, 46);
//            MetionsTblview.frame = CGRectMake(30, 200, 200, 44);
            BlackgroundButton.frame = CGRectMake(29, toolBar.frame.origin.y - 46, 202, 46);
            BlackgroundWhiteButton.frame = CGRectMake(30, toolBar.frame.origin.y - 45, 200, 44);
            MetionsTblview.frame = CGRectMake(35, toolBar.frame.origin.y - 40, 190, 34);
        }else if(CheckCount == 2){
            NSLog(@"2");
//            BlackgroundButton.frame = CGRectMake(29, 199, 202, 90);
//            MetionsTblview.frame = CGRectMake(30, 200, 200, 88);
            BlackgroundButton.frame = CGRectMake(29, toolBar.frame.origin.y - 90, 202, 90);
            BlackgroundWhiteButton.frame = CGRectMake(30, toolBar.frame.origin.y - 89, 200, 88);
            MetionsTblview.frame = CGRectMake(35, toolBar.frame.origin.y - 84, 190, 78);
        }else if(CheckCount == 3){
            NSLog(@"3");
//            BlackgroundButton.frame = CGRectMake(29, 199, 202, 134);
//            MetionsTblview.frame = CGRectMake(30, 200, 200, 132);
            BlackgroundButton.frame = CGRectMake(29, toolBar.frame.origin.y - 134, 202, 134);
            BlackgroundWhiteButton.frame = CGRectMake(30, toolBar.frame.origin.y - 133, 200, 132);
            MetionsTblview.frame = CGRectMake(35, toolBar.frame.origin.y - 128, 190, 122);
        }else if(CheckCount > 3){
            NSLog(@"4");
//            BlackgroundButton.frame = CGRectMake(29, 199, 202, 202);
//            MetionsTblview.frame = CGRectMake(30, 200, 200, 200);
            BlackgroundButton.frame = CGRectMake(29, toolBar.frame.origin.y - 202, 202, 202);
            BlackgroundWhiteButton.frame = CGRectMake(30, toolBar.frame.origin.y - 201, 200, 200);
            MetionsTblview.frame = CGRectMake(35, toolBar.frame.origin.y - 196, 190, 190);
        }
        
        if ([Mentions_NameArray count] == 0) {
            MentionsView.hidden = YES;
        }else{
            MentionsView.hidden = NO;
        }
        
        checkDataLoading = 0;
        
        [ShowActivity stopAnimating];
        
       // checkDataLoading = 0;
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
            //NSLog(@"GetAllData is %@",GetAllData);
            
            NSDictionary *UserInfoData_ = [GetAllData valueForKey:@"like_list"];
            //NSLog(@"UserInfoData_ is %@",UserInfoData_);
            
            Like_UseruidArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            Like_UserProfilePhotoArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            Like_UsernameArray = [[NSMutableArray alloc]initWithCapacity:[UserInfoData_ count]];
            Like_UserFollowingArray =[[NSMutableArray alloc]initWithCapacity:[UserInfoData_ count]];
            for (NSDictionary * dict in UserInfoData_) {
                NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                [Like_UseruidArray addObject:uid];
                NSString *photo = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [Like_UserProfilePhotoArray addObject:photo];
                NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [Like_UsernameArray addObject:username];
                NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                [Like_UserFollowingArray addObject:following];
            }
        }
//        NSLog(@"Like_UserProfilePhotoArray is %@",Like_UserProfilePhotoArray);
//        if (CheckLikeInitView == YES) {
//            [self InitView];
//        }else{
//            if ([totalCommentCount isEqualToString:@"0"]) {
//                [self InitView];
//            }else{
//                [self GetAllCommentData];
//            }
//        }
        [self InitLikeView];
        [self InitCollectionsView];
        [ShowActivity stopAnimating];
        
    }else if(connection == theConnection_SendFollowData){
            NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
            NSLog(@"Get Following return get data to server ===== %@",GetData);
            
            NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
            NSError *myError = nil;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
            NSLog(@"Expert Json = %@",res);
            
            NSString *ResultString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
            NSLog(@"ResultString is %@",ResultString);
            
            if ([ResultString isEqualToString:@"ok"]) {
                [self GetLikeData];
                
            }
        
            [ShowActivity stopAnimating];
    }else if(connection == theConnection_DeleteCommentData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Delete Comment return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *ResultString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"ResultString is %@",ResultString);
        
        if ([ResultString isEqualToString:@"ok"]) {
            TextString.text = @"";
            [self GetCommentData];
        }
    
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Comment return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
        NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
        NSLog(@"GetAllData is %@",GetAllData);
        
        GetCommentCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData valueForKey:@"total_comments"]];
        NSLog(@"GetCommentCount is %@",GetCommentCount);
        
        if ([GetCommentCount isEqualToString:@"0"]) {
            for (UIView *subview in MainScroll.subviews) {
                [subview removeFromSuperview];
            }
            ShowNoDataView.hidden = NO;
            NSLog(@"no comment here?");
        }else{
            ShowNoDataView.hidden = YES;
            // ShowCommentCount.text = GetCommentCount;
            NSArray *GetData = (NSArray *)[GetAllData valueForKey:@"comments"];
            NSLog(@"GetData is %@",GetData);
            
            GetCommentIDArray = [[NSMutableArray alloc] initWithCapacity:[GetData count]];
            GetPostIDArray = [[NSMutableArray alloc] initWithCapacity:[GetData count]];
            GetMessageArray = [[NSMutableArray alloc] initWithCapacity:[GetData count]];
            for (NSDictionary * dict in GetData) {
                NSString *comment_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"comment_id"]];
                [GetCommentIDArray addObject:comment_id];
                NSString *post_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                [GetPostIDArray addObject:post_id];
                NSString *message = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"message"]];
                [GetMessageArray addObject:message];
            }
            
            NSDictionary *UserInfoData_ = [GetData valueForKey:@"author_info"];
            NSLog(@"UserInfoData_ is %@",UserInfoData_);
            
            GetUser_Comment_uidArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            GetUser_Comment_nameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            GetUser_Comment_usernameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            GetUser_Comment_photoArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            for (NSDictionary * dict in UserInfoData_) {
                NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                [GetUser_Comment_uidArray addObject:uid];
                NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [GetUser_Comment_nameArray addObject:name];
                NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [GetUser_Comment_usernameArray addObject:username];
                NSString *photo = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [GetUser_Comment_photoArray addObject:photo];
            }
            
            [self InitView];
            [self InitCollectionsView];
            //        CATransition *transition = [CATransition animation];
            //        transition.duration = 0.4;
            //        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            //        transition.type = kCATransitionPush;
            //        transition.subtype = kCATransitionFromLeft;
            //        [self.view.window.layer addAnimation:transition forKey:nil];
            //        //[self presentViewController:ListingDetail animated:NO completion:nil];
            //        [self dismissViewControllerAnimated:NO completion:nil];
            
            [ShowActivity stopAnimating];
        }
        
      
    }
     [ShowActivity stopAnimating];
}
-(IBAction)HideMentionsViewButton:(id)sender{
        MentionsView.hidden = YES;
        checkDataLoading = 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Mentions_UsernameArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        AsyncImageView *ShowCategoryImage = [[AsyncImageView alloc]init];
        ShowCategoryImage.frame = CGRectMake(7, 7, 30, 30);
        ShowCategoryImage.tag = 101;
        ShowCategoryImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowCategoryImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowCategoryImage.layer.cornerRadius=15;
        ShowCategoryImage.layer.borderWidth=0.5;
        ShowCategoryImage.layer.masksToBounds = YES;
        ShowCategoryImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        
        
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.frame = CGRectMake(50, 0, 270, 44);
        ShowName.textColor = [UIColor darkGrayColor];
        ShowName.tag = 100;
        ShowName.backgroundColor = [UIColor clearColor];
        ShowName.font = [UIFont fontWithName:@"Avenir" size:15];
        [cell addSubview:ShowCategoryImage];
        [cell addSubview:ShowName];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UILabel *ShowName = (UILabel *)[cell viewWithTag:100];
    ShowName.text = [Mentions_NameArray objectAtIndex:indexPath.row];
    
    AsyncImageView *ShowCategoryImage = (AsyncImageView *)[cell viewWithTag:101];
    // ShowCategoryImage.text = [CategoryImageArray objectAtIndex:indexPath.row];
    //ShowCategoryImage.image = [UIImage imageNamed:[Mentions_ProfilePhotoArray objectAtIndex:indexPath.row]];
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowCategoryImage];
    NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[Mentions_ProfilePhotoArray objectAtIndex:indexPath.row]];
    NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
    // NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
    if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"null"] || [FullImagesURL1 isEqualToString:@"<null>"]) {
        ShowCategoryImage.image = [UIImage imageNamed:@"No_image_available.jpg"];
    }else{
        NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
        //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
        ShowCategoryImage.imageURL = url_UserImage;
    }
    
    // cell.textLabel.text = [NameArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Click...");

    NSArray *CheckStringArray = [TextString.text componentsSeparatedByString:@"@"];
    NSLog(@"tblview click CheckStringArray is %@",CheckStringArray);
    NSString *GetString = [CheckStringArray objectAtIndex: 0];

    NSString *NewString = [[NSString alloc]initWithFormat:@"%@@%@",GetString,[Mentions_UsernameArray objectAtIndex:indexPath.row]];
    NSLog(@"NewString is %@",NewString);
    TextString.text = NewString;
    GetMentionsUID = [Mentions_uidArray objectAtIndex:indexPath.row];
    MentionsView.hidden = YES;
}
-(void)GetCommentData{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@/%@/comments?token=%@",DataUrl.GetComment_URl,GetPostIDN,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetComment = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetComment start];
    
    
    if( theConnection_GetComment ){
        webData = [NSMutableData data];
    }
    
    [GetCommentIDArray removeAllObjects];
    [GetPostIDArray removeAllObjects];
    [GetMessageArray removeAllObjects];
    [GetUser_Comment_uidArray removeAllObjects];
    [GetUser_Comment_nameArray removeAllObjects];
    [GetUser_Comment_usernameArray removeAllObjects];
    [GetUser_Comment_photoArray removeAllObjects];
}
-(IBAction)TagNameClickButton:(id)sender{
    NSLog(@"TagName Click.");
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    NSLog(@"Tag Name is %@",[TagNameArray objectAtIndex:getbuttonIDN]);
    
    NSString *TempCheckString = [[NSString alloc]initWithFormat:@"%@",[TagNameArray objectAtIndex:getbuttonIDN]];
    if (TempCheckString == nil || [TempCheckString isEqualToString:@"Null"]) {
        
    }else{
        NewUserProfileV2ViewController *ExpertsUserProfileView = [[NewUserProfileV2ViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
        [ExpertsUserProfileView GetUserName:[TagNameArray objectAtIndex:getbuttonIDN]];
    }
    

}
-(IBAction)OpenExpertsButton2:(id)sender{
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
    [ExpertsUserProfileView GetUserName:[GetUser_Comment_usernameArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)OpenExpertsButton3:(id)sender{
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
    [ExpertsUserProfileView GetUserName:[Like_UsernameArray objectAtIndex:getbuttonIDN]];
}
- (void)segmentAction:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Posts click");
            MainScroll.hidden = NO;
            toolBar.hidden = NO;
            if ([GetMessageArray count] == 0) {
                ShowNoDataView.hidden = NO;
            }else{
            ShowNoDataView.hidden = YES;
                [TextString becomeFirstResponder];
            }
            LikeScroll.hidden = YES;
            CollectionsScroll.hidden = YES;
            break;
        case 1:
            NSLog(@"Collections click");
            [TextString resignFirstResponder];
            MainScroll.hidden = YES;
            toolBar.hidden = YES;
            LikeScroll.hidden = YES;
            ShowNoDataView.hidden = YES;
            CollectionsScroll.hidden = NO;
            break;
        case 2:
            NSLog(@"Likes click");
            [TextString resignFirstResponder];
            MainScroll.hidden = YES;
            toolBar.hidden = YES;
            LikeScroll.hidden = NO;
            ShowNoDataView.hidden = YES;
            CollectionsScroll.hidden = YES;
            break;
        default:
            break;
    }
    
    //[self InitView];
}
-(void)InitLikeView{
    for (UIView *subview in LikeScroll.subviews) {
        [subview removeFromSuperview];
    }
    
  //  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    for (int i = 0; i < [Like_UseruidArray count]; i++) {
        AsyncImageView *ShowLikeUserImage = [[AsyncImageView alloc]init];
        ShowLikeUserImage.frame = CGRectMake(15, 20 + i * 70, 50, 50);
        ShowLikeUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowLikeUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowLikeUserImage.layer.cornerRadius=25;
        ShowLikeUserImage.layer.borderWidth=1;
        ShowLikeUserImage.layer.masksToBounds = YES;
        ShowLikeUserImage.image = [UIImage imageNamed:@"avatar.png"];
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
        [LikeScroll addSubview:ShowLikeUserImage];
        
        UIImageView *AvatarLike = [[UIImageView alloc]init];
        AvatarLike.frame = CGRectMake(15 + 50 - 18, 55 + i * 70, 18, 15);
        AvatarLike.image = [UIImage imageNamed:@"AvatarLike.png"];
        [LikeScroll addSubview:AvatarLike];
        
        UIButton *OpenExpertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [OpenExpertsButton setFrame:CGRectMake(15, 20 + i * 70, 50, 50)];
        [OpenExpertsButton setBackgroundColor:[UIColor clearColor]];
        OpenExpertsButton.tag = i;
        [OpenExpertsButton addTarget:self action:@selector(OpenExpertsButton3:) forControlEvents:UIControlEventTouchUpInside];
        [LikeScroll addSubview:OpenExpertsButton];
        
        UILabel *ShowUserName1 = [[UILabel alloc]init];
        ShowUserName1.frame = CGRectMake(80, 20 + i * 70, screenWidth - 95, 50);
        ShowUserName1.text = [Like_UsernameArray objectAtIndex:i];
        //  ShowUserName1.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        ShowUserName1.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:14];
        ShowUserName1.backgroundColor = [UIColor clearColor];
        ShowUserName1.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        
        [LikeScroll addSubview:ShowUserName1];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetSelfuid = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"Useruid"]];
        
        if ([GetSelfuid isEqualToString:[Like_UseruidArray objectAtIndex:i]]) {
            
        }else{
            NSString *GetFollowing = [[NSString alloc]initWithFormat:@"%@",[Like_UserFollowingArray objectAtIndex:i]];
            
            //follow button
            UIButton *ShowFollowButton = [[UIButton alloc]init];
            ShowFollowButton.frame = CGRectMake(screenWidth - 40 - 15, 30 + i * 70, 40, 40);
            if ([GetFollowing isEqualToString:@"1"]) {
                
                [ShowFollowButton setImage:[UIImage imageNamed:@"FollowingMini.png"] forState:UIControlStateNormal];
            }else{
                [ShowFollowButton setImage:[UIImage imageNamed:@"FollowMini.png"] forState:UIControlStateNormal];
            }
            ShowFollowButton.tag = i;
            [ShowFollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
            [LikeScroll addSubview:ShowFollowButton];
        }
        

        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 80 + i * 70, screenWidth, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        [LikeScroll addSubview:Line01];
        
        [LikeScroll setContentSize:CGSizeMake(screenWidth, 140 + i * 70)];
    }
}

-(void)InitCollectionsView{
    CollectionsScroll.backgroundColor = [UIColor whiteColor];
    [CollectionsScroll setContentSize:CGSizeMake(400, 800)];
}


-(IBAction)FollowButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    SendUserUid = [[NSString alloc]initWithFormat:@"%@",[Like_UseruidArray objectAtIndex:getbuttonIDN]];
    SendFollowData = [[NSString alloc]initWithFormat:@"%@",[Like_UserFollowingArray objectAtIndex:getbuttonIDN]];
    
    NSLog(@"SendUserUid is %@",SendUserUid);
    NSLog(@"SendFollowData is %@",SendFollowData);
    
//    if ([SendFollowData isEqualToString:@"0"]) {
//        SendFollowData = @"1";
//    }else{
//        SendFollowData = @"0";
//    }
    NSLog(@"After SendFollowData is %@",SendFollowData);
    [self SendFollowData];

}
-(void)SendFollowData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/follow?token=%@",DataUrl.UserWallpaper_Url,SendUserUid,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    if ([SendFollowData isEqualToString:@"1"]) {
        [request setHTTPMethod:@"DELETE"];
    }else{
        [request setHTTPMethod:@"POST"];
    }
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
//    //parameter second
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Attaching the key name @"parameter_second" to the post body
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Attaching the content to be posted ( ParameterSecond )
//    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
//    //parameter second
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Attaching the key name @"parameter_second" to the post body
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"unfollow\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Attaching the content to be posted ( ParameterSecond )
//    [body appendData:[[NSString stringWithFormat:@"%@",SendFollowData] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_SendFollowData = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_SendFollowData) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
@end
