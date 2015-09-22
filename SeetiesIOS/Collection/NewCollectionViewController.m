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
    
    NameTextView.delegate = self;
    NameTextView.layer.cornerRadius = 5;
    NameTextView.layer.borderWidth=1;
    NameTextView.layer.borderColor=[[UIColor grayColor] CGColor];
    
    DescriptionTextView.delegate = self;
    DescriptionTextView.layer.cornerRadius = 5;
    DescriptionTextView.layer.borderWidth=1;
    DescriptionTextView.layer.borderColor=[[UIColor grayColor] CGColor];
    
    TickButton.frame = CGRectMake(screenWidth - 25 - 10, 18, 25, 25);
    SaveButton.frame = CGRectMake(screenWidth - 60, 20, 60, 44);
    
    SetTagsView.frame = CGRectMake(20, 300, screenWidth - 40, 200);
    SetTagsView.layer.cornerRadius = 5;
    SetTagsView.layer.borderWidth=1;
    SetTagsView.layer.borderColor=[[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f] CGColor];
    
    TagsLine.frame = CGRectMake(0, 50, screenWidth - 40 , 1);
    
    SetPublic = @"1";
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        if ([NameTextView.text isEqualToString:@"Type something..."]) {
            NameTextView.text = @"";
        }
    }else{
        if ([DescriptionTextView.text isEqualToString:@"Type something..."]) {
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
    }else{
        NSUInteger len = textView.text.length;
        ShowDescriptionCount.text = [NSString stringWithFormat:@"%lu / 150",150 - len];
    }

    
    
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
            else if([[textView text] length] >= 30)
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
            else if([[textView text] length] >= 30)
            {
                ShowDescriptionCount.text = @"0 / 150";
                ShowDescriptionCount.textColor = [UIColor redColor];
                return NO;
            }
        }
    }
    

    
    return YES;
}
-(IBAction)SaveButton:(id)sender{
    NSLog(@"Save Button On Click");
    
    NSLog(@"NameTextView === %@",NameTextView.text);
    NSLog(@"DescriptionTextView === %@",DescriptionTextView.text);
    NSLog(@"TagsField === %@",TagsField.text);
    NSLog(@"SetPublic === %@",SetPublic);
    
    if ([NameTextView.text isEqualToString:@"Type something..."] || [NameTextView.text isEqualToString:@""] || [NameTextView.text length] == 0) {
         [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Collection name must be at least 6 characters" type:TSMessageNotificationTypeError];
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
}
-(void)CreateNewCollection{
    [ShowActivity startAnimating];
    
    if ([NameTextView.text isEqualToString:@"Type something..."]) {
        NameTextView.text = @"";
    }
    if ([DescriptionTextView.text isEqualToString:@"Type something..."]) {
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
        
        if ([statusString isEqualToString:@"ok"]) {
            [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Create New Collections" type:TSMessageNotificationTypeSuccess];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        [ShowActivity stopAnimating];
    }
}
@end
