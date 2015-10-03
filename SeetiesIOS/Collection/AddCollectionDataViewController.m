//
//  AddCollectionDataViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "AddCollectionDataViewController.h"
#import "NewCollectionViewController.h"
#import "NewCollectionViewController.h"
@interface AddCollectionDataViewController ()

@end

@implementation AddCollectionDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    MainScroll.frame = CGRectMake(0, screenHeight - 450, screenWidth, 450);
    MainScroll.delegate = self;
    BackgroundBlackButton.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    BackButton.frame = CGRectMake(screenWidth - 50, 0, 50, 50);
    
    NoteTextView.delegate = self;
    NoteTextView.frame = CGRectMake(108, 59, screenWidth - 108 - 20, 80);
    NoteTextView.layer.cornerRadius = 5;
    NoteTextView.layer.borderWidth=1;
    NoteTextView.layer.borderColor=[[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f] CGColor];
    NoteTextView.text = LocalisedString(@"Leave a note");
    
    ShowNoteTextCount.frame = CGRectMake(screenWidth - 20 - 42, 119, 42, 20);
    
    PostImg.layer.cornerRadius = 5;
    PostImg.contentMode = UIViewContentModeScaleAspectFill;
    PostImg.layer.borderWidth=0;
    PostImg.layer.masksToBounds = YES;
    
    tblview.frame = CGRectMake(0, 193, screenWidth, 207);
    
    CollectThisTitle.text = LocalisedString(@"Collect this");
    PickaCollectionTitle.text = LocalisedString(@"Pick a collection");
    [CreateCollectionButton setTitle:LocalisedString(@"Create a new collection") forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (CheckReflash == YES) {
        [self GetUserCollections];
    }
}
-(void)GetPostID:(NSString *)PostID GetImageData:(NSString *)ImageData{

    GetPostID = PostID;
    GetImageData = ImageData;
    
    NSLog(@"AddCollectionDataViewController GetPostID is %@",GetPostID);
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:PostImg];
    NSArray *SplitArray = [GetImageData componentsSeparatedByString:@","];
    NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
    if ([FullImagesURL_First length] == 0) {
        PostImg.image = [UIImage imageNamed:@"NoImage.png"];
    }else{
        NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
        PostImg.imageURL = url_NearbySmall;
    }
    [self GetUserCollections];
}

-(void)GetUserCollections{
    [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/collections?token=%@&list_size=50",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"collection list check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_CollectionData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_CollectionData start];
    
    
    if( theConnection_CollectionData ){
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

}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_CollectionData) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
      //  NSLog(@"GetCollectionData is %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        
        NSString *StatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        if ([StatusString isEqualToString:@"0"] || [StatusString isEqualToString:@"401"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
          //  NSLog(@"Get Collection all list data is %@",res);
            NSDictionary *GetResData = [res valueForKey:@"data"];

            CollectionData_IDArray = [[NSMutableArray alloc]init];
            CollectionData_TitleArray = [[NSMutableArray alloc]init];
            
            NSArray *GetAllData = (NSArray *)[GetResData valueForKey:@"result"];
            
            for (NSDictionary * dict in GetAllData) {
                NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collection_id"]];
                [CollectionData_IDArray addObject:PlaceID];
                NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [CollectionData_TitleArray addObject:name];
            }
            NSLog(@"CollectionData_IDArray is %@",CollectionData_IDArray);
            NSLog(@"CollectionData_TitleArray is %@",CollectionData_TitleArray);
            
            [tblview reloadData];
            [ShowActivity stopAnimating];
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
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            [TSMessage showNotificationInViewController:self title:@"" subtitle:MessageString type:TSMessageNotificationTypeError];
        }
    }
    
    
    [ShowActivity stopAnimating];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [CollectionData_IDArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIImageView *ShowIcon = [[UIImageView alloc]init];
        ShowIcon.image = [UIImage imageNamed:@"CollectionFolderIcon.png"];
        ShowIcon.frame = CGRectMake(10, 4, 35, 35);
        [cell addSubview:ShowIcon];
        
        UILabel *ShowTitle = [[UILabel alloc]init];
        ShowTitle.tag = 500;
        ShowTitle.frame = CGRectMake(60, 0, 300, 44);
        ShowTitle.backgroundColor = [UIColor clearColor];
       // ShowTitle.textAlignment = NSTextAlignmentCenter;
        ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [cell addSubview:ShowTitle];
        
    }

    
    UILabel *ShowTitleName = (UILabel *)[cell viewWithTag:500];
    ShowTitleName.text = [CollectionData_TitleArray objectAtIndex:indexPath.row];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath.section IS %ld",(long)indexPath.section);

    GetCollectionID = [CollectionData_IDArray objectAtIndex:indexPath.row];
    [self SendQuickCollect];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [NoteTextView resignFirstResponder];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"did begin editing");
    if ([NoteTextView.text isEqualToString:LocalisedString(@"Leave a note")]) {
        NoteTextView.text = @"";
    }
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([NoteTextView.text length] == 0) {
        NoteTextView.text = LocalisedString(@"Leave a note");
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    NSUInteger len = textView.text.length;
    ShowNoteTextCount.text = [NSString stringWithFormat:@"%lu/30",30 - len];
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

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
            else if([[textView text] length] >= 30)
            {
                ShowNoteTextCount.text = @"0/30";
                ShowNoteTextCount.textColor = [UIColor redColor];
                return NO;
            }
        }
        
    return YES;
}
-(void)SendQuickCollect{
    
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetUseruid = [defaults objectForKey:@"Useruid"];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/%@/collect",DataUrl.UserWallpaper_Url,GetUseruid,GetCollectionID];
    NSLog(@"Send Quick Collection urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *dataString;
    if ([NoteTextView.text isEqualToString:LocalisedString(@"Leave a note")] || [NoteTextView.text length] == 0) {
        NoteTextView.text = @"";
        dataString = [[NSString alloc]initWithFormat:@"token=%@&posts[0][id]=%@",GetExpertToken,GetPostID];
    }else{
        dataString = [[NSString alloc]initWithFormat:@"token=%@&posts[0][id]=%@&posts[0][note]=%@",GetExpertToken,GetPostID,NoteTextView.text];
    }

    
    NSData *postBodyData = [NSData dataWithBytes: [dataString UTF8String] length:[dataString length]];
    [request setHTTPBody:postBodyData];
    
    theConnection_QuickCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_QuickCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(IBAction)CreateCollectionButton:(id)sender{
    CheckReflash = YES;
    NewCollectionViewController *NewCollectionView = [[NewCollectionViewController alloc]init];
    [self presentViewController:NewCollectionView animated:YES completion:nil];
   // [self.view.window.rootViewController presentViewController:NewCollectionView animated:YES completion:nil];
}
@end
