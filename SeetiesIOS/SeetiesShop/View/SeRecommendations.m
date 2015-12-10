//
//  SeRecommendations.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 01/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeRecommendations.h"
#import "FeedV2DetailViewController.h"
@interface SeRecommendations(){
    IBOutlet UIButton *ShowbackLine;
    IBOutlet UILabel *ShowRecommendationsText;
    IBOutlet UIButton *SeeAllButton;

    int Getheight;
}
@property (strong, nonatomic)NSMutableArray* arrPostListing;
@property(nonatomic,strong)ProfilePostModel* userProfilePostModel;
@end
@implementation SeRecommendations

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
    
    self.frame = CGRectMake(0, 0, screenWidth, 270);
    self.backgroundColor = [UIColor clearColor];
    
    ShowbackLine.frame = CGRectMake(-1, 0, screenWidth + 2 , 50);
    [ShowbackLine setTitle:@"" forState:UIControlStateNormal];
    ShowbackLine.backgroundColor = [UIColor whiteColor];
    [Utils setRoundBorder:ShowbackLine color:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f] borderRadius:0.0f borderWidth:1.0f];
    
    ShowRecommendationsText.frame = CGRectMake(20, 0, screenWidth - 40, 50);
    ShowRecommendationsText.text = @"Recommendations";
    ShowRecommendationsText.backgroundColor = [UIColor clearColor];
    
    Getheight = 50;
    
    SeeAllButton.frame = CGRectMake(-1, self.frame.size.height - 70, screenWidth + 2 , 50);
    [SeeAllButton setTitle:@"See all recommendations" forState:UIControlStateNormal];
    SeeAllButton.backgroundColor = [UIColor whiteColor];
    [SeeAllButton addTarget:self action:@selector(SeeAllButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [Utils setRoundBorder:SeeAllButton color:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f] borderRadius:0.0f borderWidth:1.0f];
    

}

-(AsyncImageView *)SetupUserProfileImage
{
    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowUserProfileImage.layer.cornerRadius = 20;
    ShowUserProfileImage.layer.masksToBounds = YES;
    ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
    return ShowUserProfileImage;
}
-(UILabel *)SetupLabel
{
    UILabel *Showlabel = [[UILabel alloc]init];
    Showlabel.text = @"Label";
    Showlabel.backgroundColor = [UIColor whiteColor];
    Showlabel.textColor = [UIColor blackColor];
    Showlabel.textAlignment = NSTextAlignmentLeft;
    
    return Showlabel;

}
-(UIButton *)SetupLineBtn
{
    UIButton *Line = [[UIButton alloc]init];
    [Line setTitle:@"" forState:UIControlStateNormal];
    [Line setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    return Line;
}

-(void)InitRecommendationViewdata{
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    Getheight += 20;
    
    UIButton *whiteBack = [self SetupLineBtn];
    whiteBack.frame = CGRectMake(0, 50, screenWidth, 200);
    whiteBack.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteBack];
    
    for (int i = 0; i < [self.arrPostListing count]; i++) {
        
        DraftModel* model = self.arrPostListing[i];
        int btnHeight = Getheight;
        
        
        AsyncImageView *ShowUserProfileImage = [self SetupUserProfileImage];
        ShowUserProfileImage.frame = CGRectMake(20 , Getheight, 40, 40);
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",model.user_info.profile_photo_images];
        if ([ImageData1 length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
            ShowUserProfileImage.imageURL = url_NearbySmall;
        }
        [self addSubview:ShowUserProfileImage];
        
        UILabel *ShowUsername = [self SetupLabel];
        ShowUsername.frame = CGRectMake(80, Getheight, screenWidth - 100, 40);
        ShowUsername.text = model.user_info.name;
        ShowUsername.font = [UIFont fontWithName:CustomFontName size:15];
        [self addSubview:ShowUsername];
        
        Getheight += 40;
        
        NSString* currentlangCode = [Utils getLanguageCodeFromLocale:[[LanguageManager sharedLanguageManager]getSelectedLocale].languageCode];
        NSString *TestTitle;
        NSString *TestDetail;
        if (![model.arrPost isNull]) {
            
            Post* postModel;
            for (int i = 0 ; i< model.arrPost.count; i++) {
                postModel = model.arrPost[i];
                
                if ([postModel.language isEqualToString:currentlangCode]) {
                    TestTitle = model.contents[currentlangCode][@"title"];
                    TestDetail = model.contents[currentlangCode][@"message"];
                    break;
                }
            }
            postModel = model.arrPost[0];

            TestTitle = postModel.title;
            TestDetail = postModel.message;
        }
        
        if ([TestTitle length] == 0 || [TestTitle isEqualToString:@""] || [TestTitle isEqualToString:@"(null)"]) {
            
        }else{
            UILabel *ShowTitle = [self SetupLabel];
            ShowTitle.frame = CGRectMake(80, Getheight, screenWidth - 100, 20);
            ShowTitle.text = TestTitle;
            ShowTitle.font = [UIFont fontWithName:CustomFontNameBold size:15];
            [self addSubview:ShowTitle];
        
            Getheight += 20;
        }
        
        if ([TestDetail length] == 0 || [TestDetail isEqualToString:@""] || [TestDetail isEqualToString:@"(null)"]) {
            
        }else{
            
            UILabel *ShowDetail = [self SetupLabel];
            ShowDetail.frame = CGRectMake(80, Getheight, screenWidth - 100, 20);
            ShowDetail.text = TestDetail;
            ShowDetail.textColor = [UIColor blackColor];
            ShowDetail.font = [UIFont fontWithName:CustomFontName size:15];
            [self addSubview:ShowDetail];
            
            UILabel *ShowReadMore = [self SetupLabel];
            ShowReadMore.frame = CGRectMake(80, Getheight + 20, screenWidth - 100, 20);
            ShowReadMore.text = @"Read more...";
            ShowReadMore.textColor = [UIColor colorWithRed:41.0f/255.0f green:182.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
            ShowReadMore.font = [UIFont fontWithName:CustomFontNameBold size:15];
            [self addSubview:ShowReadMore];
            
            Getheight += 40;
        }

        if (![model.arrPhotos isNull]) {
            
            PhotoModel* photoModel;
            for (int z = 0; z < model.arrPhotos.count; z++) {
                photoModel = model.arrPhotos[z];
               // NSLog(@"photoModel.imageURL === %@",photoModel.imageURL);
                
                if (z >= 4) {
                    break;
                }else{
                    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                    ShowUserProfileImage.frame = CGRectMake(80 + z * 65 , Getheight + 5, 60, 60);
                    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowUserProfileImage.layer.cornerRadius = 5;
                    ShowUserProfileImage.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                    // ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                    NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",photoModel.imageURL];
                    if ([ImageData1 length] == 0) {
                        ShowUserProfileImage.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
                        ShowUserProfileImage.imageURL = url_NearbySmall;
                    }
                    [self addSubview:ShowUserProfileImage];

                }


                

                
            }
            
            Getheight += 70;
        

        }
        else{
            SLog(@"NO Images");
        }
        
        UIButton *OpenPostsDetailButton = [[UIButton alloc]init];
        OpenPostsDetailButton.frame = CGRectMake(0, btnHeight, screenWidth, Getheight);
        [OpenPostsDetailButton setTitle:@"" forState:UIControlStateNormal];
        OpenPostsDetailButton.backgroundColor = [UIColor clearColor];
        OpenPostsDetailButton.tag = i;
        [OpenPostsDetailButton addTarget:self action:@selector(OpenPostsDetailButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:OpenPostsDetailButton];
        
        
        

        UIButton *Line04 = [self SetupLineBtn];
        Line04.frame = CGRectMake(20, Getheight + 10, screenWidth, 1);
        [self addSubview:Line04];
        

        Getheight += 30;
        

    }
    whiteBack.frame = CGRectMake(0, 50, screenWidth,  Getheight - 50);
    self.frame = CGRectMake(0, 0, screenWidth, Getheight + 50);
    SeeAllButton.frame = CGRectMake(-1, self.frame.size.height - 70, screenWidth + 2 , 50);
}
-(void)initData
{
    [self requestServerForSeetiShopRecommendations];

}
-(void)requestServerForSeetiShopRecommendations
{
    //  NSDictionary* param;
    NSString* appendString = @"56397e301c4d5be92e8b4711/posts";
    NSDictionary* dict = @{@"limit":@"4",
                           @"offset":@"1",
                           };
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetoShopRecommendations param:dict appendString:appendString completeHandler:^(id object) {
        self.userProfilePostModel = [[ConnectionManager dataManager]userProfilePostModel];
        [self.arrPostListing addObjectsFromArray:self.userProfilePostModel.userPostData.posts];

         NSString *GetTotalPosts = [[NSString alloc]initWithFormat:@"See all %i recommendations",self.userProfilePostModel.userPostData.total_posts];
         [SeeAllButton setTitle:GetTotalPosts forState:UIControlStateNormal];
         [self InitRecommendationViewdata];
        
        if (self.viewDidFinishLoadBlock) {
            self.viewDidFinishLoadBlock();
        }
    } errorBlock:^(id object) {
        
        
    }];
    
}
-(NSMutableArray*)arrPostListing
{
    if (!_arrPostListing) {
        _arrPostListing = [NSMutableArray new];
    }
    
    return _arrPostListing;
}
-(IBAction)OpenPostsDetailButtonOnClick:(id)sender{
    NSLog(@"SeetiShop OpenPostsDetailButtonOnClick");

    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    DraftModel* model = self.arrPostListing[getbuttonIDN];

    if (self.btnPostsDetailClickedBlock) {
        self.btnPostsDetailClickedBlock(model.post_id);
    }
}
-(IBAction)SeeAllButtonOnClick:(id)sender{
    if (self.btnPostsSeeAllClickedBlock) {
        self.btnPostsSeeAllClickedBlock(@"SeetiShopIDN");
    }
}
@end
