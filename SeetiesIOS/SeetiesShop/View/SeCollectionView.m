//
//  SeCollectionView.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 01/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeCollectionView.h"
#import "CollectionViewController.h"
#import "UrlDataClass.h"
@interface SeCollectionView()<UIScrollViewDelegate>{
    IBOutlet UIButton *ShowbackLine;
    IBOutlet UILabel *ShowRelatedCollectionsText;
    IBOutlet UIButton *SeeAllButton;
    
    IBOutlet UIScrollView *MainScroll;
    
    //old way
    NSURLConnection *theConnection_FollowCollect;
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSString *GetCollectionFollowing;
    NSString *GetCollectUserID;
    NSString *GetCollectID;
}
@property(nonatomic,strong)NSMutableArray* arrCollections;
@property(nonatomic,strong)NSMutableArray* arrCollectFollow;
@property(nonatomic,strong)CollectionsModel* SeetiShopCollectionsModel;

@property(nonatomic,strong)NSString* seetiesID;
@property(nonatomic,strong)NSString* placeID;
@property(nonatomic,strong)NSString* postID;
@end
@implementation SeCollectionView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initSelfView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
   // NSLog(@"screenWidth == %f",screenWidth);

    self.frame = CGRectMake(0, 0, screenWidth, 370);
    self.backgroundColor = [UIColor clearColor];

    ShowbackLine.frame = CGRectMake(-1, 0, screenWidth + 2 , 50);
    [ShowbackLine setTitle:@"" forState:UIControlStateNormal];
    ShowbackLine.backgroundColor = [UIColor whiteColor];
    [Utils setRoundBorder:ShowbackLine color:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f] borderRadius:0.0f borderWidth:1.0f];
    
    ShowRelatedCollectionsText.frame = CGRectMake(20, 0, screenWidth - 40, 50);
    ShowRelatedCollectionsText.text = LocalisedString(@"Related collections");
    ShowRelatedCollectionsText.backgroundColor = [UIColor clearColor];
    
    MainScroll.delegate = self;
    MainScroll.backgroundColor = [UIColor whiteColor];
    MainScroll.frame = CGRectMake(0, 50, screenWidth, 260);

    self.arrCollectFollow = [[NSMutableArray alloc]init];
    

}

-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID
{
    
    self.seetiesID = seetiesID;
    self.placeID = placeID;
    self.postID = postID;

    [self requestServerForSeetiShopCollection];
    [self DrawView];
}
-(void)DrawView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    
 //   NSString *GetTotalCollection = [[NSString alloc]initWithFormat:@"See all %i Collections",self.SeetiShopCollectionsModel.total_collections];
    
    SeeAllButton.frame = CGRectMake(-1, self.frame.size.height - 60, screenWidth + 2, 50);
    [SeeAllButton setTitle:LocalisedString(@"See all collections") forState:UIControlStateNormal];
    SeeAllButton.backgroundColor = [UIColor whiteColor];
    [SeeAllButton addTarget:self action:@selector(SeeAllButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [Utils setRoundBorder:SeeAllButton color:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f] borderRadius:0.0f borderWidth:1.0f];
    
    //[self InitScrollViewData];
}

-(UIButton*)setupButton
{
    UIButton *TempButton = [[UIButton alloc]init];
    [TempButton setTitle:@"" forState:UIControlStateNormal];
    TempButton.backgroundColor = [UIColor whiteColor];
    [Utils setRoundBorder:TempButton color:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f] borderRadius:10.0f borderWidth:1.0f];

    return TempButton;
}
-(AsyncImageView*)SetupImage
{

    AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
    ShowImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowImage.layer.cornerRadius= 10;
    ShowImage.layer.masksToBounds = YES;
    //ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
    return ShowImage;
    
}
-(UIImageView *)SetupOverlayImage
{
    UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
    ShowOverlayImg.image = [UIImage imageNamed:@"DealsAndRecommendationOverlay.png"];
    ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
    ShowOverlayImg.layer.masksToBounds = YES;
    ShowOverlayImg.layer.cornerRadius = 10;
    return ShowOverlayImg;
}
-(UILabel *)SetupLabel{
    
    UILabel *ShowLabelSetup = [[UILabel alloc]init];
    ShowLabelSetup.backgroundColor = [UIColor clearColor];
    ShowLabelSetup.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    ShowLabelSetup.textAlignment = NSTextAlignmentLeft;
    ShowLabelSetup.font = [UIFont fontWithName:CustomFontNameBold size:16];
    
    return ShowLabelSetup;
}
-(void)InitScrollViewData{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    for (int i = 0; i < [self.arrCollections count]; i++) {
        
        CollectionModel* collModel = self.arrCollections[i];
        NSString *TempString = [[NSString alloc]initWithFormat:@"%d",collModel.following ? 1:0];
        [self.arrCollectFollow addObject:TempString];
       
        UIButton* button = [self setupButton];
        button.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,220);
        [MainScroll addSubview:button];
        
        AsyncImageView *ShowImage1 = [self SetupImage];
        ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,150);
        [MainScroll addSubview:ShowImage1];
        
        
        if (![collModel.arrayPost isNull])
        {
            DraftModel* draftModel = collModel.arrayPost[0];
            PhotoModel* photoModel1 = draftModel.arrPhotos[0];
            if (collModel.arrayPost.count > 1) {
                DraftModel* draftModel2 = collModel.arrayPost[1];
                PhotoModel* photoModel2 = draftModel2.arrPhotos[0];
                
                AsyncImageView *ShowImage1 = [self SetupImage];
                ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , ((screenWidth - 55) / 2) ,150);
                NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",photoModel1.imageURL];
                if ([ImageData length] == 0) {
                    ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                    ShowImage1.imageURL = url_NearbySmall;
                }
                [MainScroll addSubview:ShowImage1];
                
                AsyncImageView *ShowImage2 = [self SetupImage];
                ShowImage2.frame = CGRectMake(10 + ((screenWidth - 40) / 2) + i * (screenWidth - 40), 20 , ((screenWidth - 60) / 2) ,150);
                NSString *ImageData100 = [[NSString alloc]initWithFormat:@"%@",photoModel2.imageURL];
                if ([ImageData100 length] == 0) {
                    ShowImage2.image = [UIImage imageNamed:@"NoImage.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:ImageData100];
                    ShowImage2.imageURL = url_NearbySmall;
                }
                [MainScroll addSubview:ShowImage2];
            }else{
                AsyncImageView *ShowImage1 = [self SetupImage];
                ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,150);
                NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",photoModel1.imageURL];
                if ([ImageData length] == 0) {
                    ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                    ShowImage1.imageURL = url_NearbySmall;
                }
                [MainScroll addSubview:ShowImage1];

            }
        }

        
        UIImageView *ShowOverlayImg = [self SetupOverlayImage];
        ShowOverlayImg.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,180);
        [MainScroll addSubview:ShowOverlayImg];

        
        UIButton *OpenCollectionButton = [self setupButton];
        OpenCollectionButton.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,220);
        [OpenCollectionButton setTitle:@"" forState:UIControlStateNormal];
        OpenCollectionButton.backgroundColor = [UIColor clearColor];
        OpenCollectionButton.layer.cornerRadius = 10;
        OpenCollectionButton.layer.borderWidth=1;
        OpenCollectionButton.layer.masksToBounds = YES;
        OpenCollectionButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
        [OpenCollectionButton addTarget:self action:@selector(OpenCollectionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        OpenCollectionButton.tag = i;
        [MainScroll addSubview: OpenCollectionButton];
        
        UILabel *ShowCollectionTitle = [self SetupLabel];
        ShowCollectionTitle.frame = CGRectMake(25 + i * (screenWidth - 40), 180, screenWidth - 190 , 20);
        ShowCollectionTitle.text = collModel.name;
        ShowCollectionTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        ShowCollectionTitle.font = [UIFont fontWithName:CustomFontNameBold size:15];
        [MainScroll addSubview:ShowCollectionTitle];
        
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%d %@",collModel.collection_posts_count,LocalisedString(@"Recommendations")];
        
        UILabel *ShowCollectionCount = [self SetupLabel];
        ShowCollectionCount.frame = CGRectMake(25 + i * (screenWidth - 40), 200, screenWidth - 190, 20);
        ShowCollectionCount.text = TempCount;
        ShowCollectionCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowCollectionCount.font = [UIFont fontWithName:CustomFontName size:13];
        [MainScroll addSubview:ShowCollectionCount];
        
        
        NSString *CheckCollectionFollowing = [[NSString alloc]initWithFormat:@"%d",collModel.following? 1:0];
       // NSString *CheckCollectionFollowing = @"0";
        UIButton *QuickCollectButtonLocalQR = [[UIButton alloc]init];
        if ([CheckCollectionFollowing isEqualToString:@"0"]) {
            [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateNormal];
            [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateSelected];
        }else{
            [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateNormal];
            [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateSelected];
        }
        [QuickCollectButtonLocalQR setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [QuickCollectButtonLocalQR.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
        QuickCollectButtonLocalQR.backgroundColor = [UIColor clearColor];
        QuickCollectButtonLocalQR.frame = CGRectMake((screenWidth - 45 - 115) + i * (screenWidth - 40), 186, 115, 38);//115,38
        [QuickCollectButtonLocalQR addTarget:self action:@selector(CollectionFollowingButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        QuickCollectButtonLocalQR.tag = i;
        [MainScroll addSubview:QuickCollectButtonLocalQR];
        
        MainScroll.contentSize = CGSizeMake(20 + i * (screenWidth - 40) + (screenWidth - 50), 200);
    }

    self.frame = CGRectMake(0, 0, screenWidth, 370);
}
-(void)requestServerForSeetiShopCollection
{
  //  NSDictionary* param;
//    NSString* appendString = @"56397e301c4d5be92e8b4711/collections";
//    NSDictionary* dict = @{@"limit":@"5",
//                           @"offset":@"1",
//                           };
    
    NSDictionary* dict;
    NSString* appendString;
    if (![Utils stringIsNilOrEmpty:self.seetiesID]) {
        
        dict = @{@"limit":@"6",
                 @"offset":@"1",
                 };
        appendString = [[NSString alloc]initWithFormat:@"%@/collections",self.seetiesID];
        
    }
    else{
        
        dict = @{@"limit":@"6",
                 @"offset":@"1",
                 };

        appendString = [[NSString alloc]initWithFormat:@"%@/collections",self.placeID];
        
    }

    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetiShopCollection param:dict appendString:appendString completeHandler:^(id object) {

        self.SeetiShopCollectionsModel = [[ConnectionManager dataManager]userSuggestedCollectionsModel];
        
       // NSString *GetTotalCollection = [[NSString alloc]initWithFormat:@"See all %i Collections",self.SeetiShopCollectionsModel.total_collections];
        [SeeAllButton setTitle:LocalisedString(@"See all collections") forState:UIControlStateNormal];

        [self.arrCollections addObjectsFromArray:self.SeetiShopCollectionsModel.arrSuggestedCollection];
        
        [self InitScrollViewData];
        
        BOOL isDeleteView = false;
        if (self.arrCollections.count == 0) {
            isDeleteView = true;
        }
        if (self.viewDidFinishLoadBlock) {
            self.viewDidFinishLoadBlock(isDeleteView);
        }
        
    } errorBlock:^(id object) {
        
        
    }];
    
}
-(NSMutableArray*)arrCollections
{
    if(!_arrCollections)
    {
        _arrCollections = [NSMutableArray new];
    }
    return _arrCollections;
}



-(IBAction)OpenCollectionButtonOnClick:(id)sender{

    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    CollectionModel* collModel = self.arrCollections[getbuttonIDN];
    
    if (self.btnCollectionDetailClickedBlock) {
        self.btnCollectionDetailClickedBlock(collModel.collection_id,collModel.user_info.uid);
    }
    
}
-(IBAction)SeeAllButtonOnClick:(id)sender{
    if (self.btnCollectionSeeAllClickedBlock) {
        if (self.seetiesID) {
            self.btnCollectionSeeAllClickedBlock(self.seetiesID);

        }
        else{
            self.btnCollectionSeeAllClickedBlock(self.placeID);

        }
    }
}
-(IBAction)CollectionFollowingButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    CollectionModel* collModel = self.arrCollections[getbuttonIDN];
    
    GetCollectionFollowing = [[NSString alloc]initWithFormat:@"%d",collModel.following ? 1:0];
    GetCollectUserID = [[NSString alloc]initWithFormat:@"%@",collModel.user_info.uid];
    GetCollectID = [[NSString alloc]initWithFormat:@"%@",collModel.collection_id];
    
    if ([GetCollectionFollowing isEqualToString:@"0"]) {
        UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
        buttonWithTag1.selected = !buttonWithTag1.selected;
        [self FollowCollection];
        [self.arrCollectFollow replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
    }else{
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Are You Sure You Want To Unfollow") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"YES"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == [alertView cancelButtonIndex]) {
                NSLog(@"Cancelled");
                
            } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalisedString(@"YES")]) {
                
                UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
                buttonWithTag1.selected = !buttonWithTag1.selected;
                [self DeleteFollowCollection];
                [self.arrCollectFollow replaceObjectAtIndex:getbuttonIDN withObject:@"0"];
                
                
            }
        }];

    }
}
-(void)FollowCollection{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/%@/follow",DataUrl.UserWallpaper_Url,GetCollectUserID,GetCollectID];
    NSLog(@"Send Follow Collection urlString is %@",urlString);
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
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_FollowCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_FollowCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)DeleteFollowCollection{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/%@/follow?token=%@",DataUrl.UserWallpaper_Url,GetCollectUserID,GetCollectID,GetExpertToken];
    NSLog(@"Send Delete Collection urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
    theConnection_FollowCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_FollowCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_FollowCollect) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Follow Collection return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            if ([GetCollectionFollowing isEqualToString:@"0"]) {
             //  [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success follow this collection" type:TSMessageNotificationTypeSuccess];
                GetCollectionFollowing = @"1";
            }else{
             //   [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success unfollow this collection" type:TSMessageNotificationTypeSuccess];
                GetCollectionFollowing = @"0";
            }
            
            
        }

    }
}

@end
