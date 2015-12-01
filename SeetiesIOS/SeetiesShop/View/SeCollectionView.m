//
//  SeCollectionView.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 01/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeCollectionView.h"

@interface SeCollectionView()<UIScrollViewDelegate>{
    IBOutlet UIButton *ShowbackLine;
    IBOutlet UILabel *ShowRelatedCollectionsText;
    IBOutlet UIButton *SeeAllButton;
    
    IBOutlet UIScrollView *MainScroll;
}
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
    NSLog(@"screenWidth == %f",screenWidth);

    self.frame = CGRectMake(0, 0, screenWidth, 380);
    self.backgroundColor = [UIColor clearColor];

    ShowbackLine.frame = CGRectMake(-1, 0, screenWidth + 2 , 50);
    [ShowbackLine setTitle:@"" forState:UIControlStateNormal];
    ShowbackLine.backgroundColor = [UIColor whiteColor];
    ShowbackLine.layer.borderWidth = 1;
    ShowbackLine.layer.masksToBounds = YES;
    ShowbackLine.layer.borderColor=[[UIColor redColor] CGColor];
    
    ShowRelatedCollectionsText.frame = CGRectMake(20, 0, screenWidth - 40, 50);
    ShowRelatedCollectionsText.text = @"Related Collections";
    ShowRelatedCollectionsText.backgroundColor = [UIColor clearColor];
    
    MainScroll.delegate = self;
    MainScroll.backgroundColor = [UIColor whiteColor];
    MainScroll.frame = CGRectMake(0, 50, screenWidth, 260);

    
    SeeAllButton.frame = CGRectMake(-1, self.frame.size.height - 70, screenWidth + 2, 50);
    [SeeAllButton setTitle:@"See all 5 Collections" forState:UIControlStateNormal];
    SeeAllButton.backgroundColor = [UIColor whiteColor];
    SeeAllButton.layer.borderWidth = 1;
    SeeAllButton.layer.masksToBounds = YES;
    SeeAllButton.layer.borderColor=[[UIColor redColor] CGColor];
    
    
    [self InitScrollViewData];
    
}

-(UIButton*)setupButton
{
    UIButton *TempButton = [[UIButton alloc]init];
    [TempButton setTitle:@"" forState:UIControlStateNormal];
    TempButton.backgroundColor = [UIColor whiteColor];
    TempButton.layer.cornerRadius = 10;
    TempButton.layer.borderWidth=1;
    TempButton.layer.masksToBounds = YES;
    TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];

    return TempButton;
}
-(void)InitScrollViewData{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    for (int i = 0; i < 3; i++) {
       
        UIButton* button = [self setupButton];
        button.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,220);
        [MainScroll addSubview:button];
        
        AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
        ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,150);
        //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
        ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowImage1.layer.cornerRadius= 10;
        ShowImage1.layer.masksToBounds = YES;
         ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];

        [MainScroll addSubview:ShowImage1];
        
//        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[arrImageData objectAtIndex:i]];
//        NSArray *SplitArray_TempImage = [TempImage componentsSeparatedByString:@"^^^"];
//        if ([SplitArray_TempImage count] == 1) {
//            AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
//            ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,120);
//            //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
//            ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
//            ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
//            ShowImage1.layer.cornerRadius= 10;
//            ShowImage1.layer.masksToBounds = YES;
//            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
//            NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:0]];
//            if ([ImageData length] == 0) {
//                ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
//            }else{
//                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
//                ShowImage1.imageURL = url_NearbySmall;
//            }
//            [MainScroll addSubview:ShowImage1];
//        }else{
//            AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
//            ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , ((screenWidth - 55) / 2) ,120);
//            //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
//            ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
//            ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
//            ShowImage1.layer.cornerRadius= 10;
//            ShowImage1.layer.masksToBounds = YES;
//            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
//            NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:0]];
//            if ([ImageData length] == 0) {
//                ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
//            }else{
//                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
//                ShowImage1.imageURL = url_NearbySmall;
//            }
//            [MainScroll addSubview:ShowImage1];
//            
//            AsyncImageView *ShowImage2 = [[AsyncImageView alloc]init];
//            ShowImage2.frame = CGRectMake(10 + ((screenWidth - 40) / 2) + i * (screenWidth - 40), 50 , ((screenWidth - 60) / 2) ,120);
//            //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
//            ShowImage2.contentMode = UIViewContentModeScaleAspectFill;
//            ShowImage2.layer.backgroundColor=[[UIColor clearColor] CGColor];
//            ShowImage2.layer.cornerRadius=10;
//            ShowImage2.layer.masksToBounds = YES;
//            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage2];
//            NSString *ImageData100 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:1]];
//            if ([ImageData100 length] == 0) {
//                ShowImage2.image = [UIImage imageNamed:@"NoImage.png"];
//            }else{
//                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData100];
//                ShowImage2.imageURL = url_NearbySmall;
//            }
//            [MainScroll addSubview:ShowImage2];
//        }
        
        
        
        
        UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
        ShowOverlayImg.image = [UIImage imageNamed:@"DealsAndRecommendationOverlay.png"];
        ShowOverlayImg.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,180);
        ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
        ShowOverlayImg.layer.masksToBounds = YES;
        ShowOverlayImg.layer.cornerRadius = 10;
        [MainScroll addSubview:ShowOverlayImg];
        
        
        
        UIButton *OpenCollectionButton = [[UIButton alloc]init];
        OpenCollectionButton.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,220);
        [OpenCollectionButton setTitle:@"" forState:UIControlStateNormal];
        OpenCollectionButton.backgroundColor = [UIColor clearColor];
        OpenCollectionButton.layer.cornerRadius = 10;
        OpenCollectionButton.layer.borderWidth=1;
        OpenCollectionButton.layer.masksToBounds = YES;
        OpenCollectionButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
      //  [OpenCollectionButton addTarget:self action:@selector(OpenCollectionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        OpenCollectionButton.tag = i;
        [MainScroll addSubview: OpenCollectionButton];
        
//        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
//        ShowUserProfileImage.frame = CGRectMake(25 + i * (screenWidth - 40), 21 + 10, 40, 40);
//        // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
//        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
//        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
//        ShowUserProfileImage.layer.cornerRadius=20;
//        ShowUserProfileImage.layer.borderWidth=1;
//        ShowUserProfileImage.layer.masksToBounds = YES;
//        ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
//        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
////        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
////        NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
////        if ([ImageData1 length] == 0) {
////            ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
////        }else{
////            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
////            ShowUserProfileImage.imageURL = url_NearbySmall;
////        }
//        [MainScroll addSubview:ShowUserProfileImage];
//
//        UIButton *OpenUserProfileButton = [[UIButton alloc]init];
//        [OpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
//        OpenUserProfileButton.backgroundColor = [UIColor clearColor];
//        OpenUserProfileButton.frame = CGRectMake(25 + i * (screenWidth - 40), 21 + 10, screenWidth - 75 - 100, 40);
//       // [OpenUserProfileButton addTarget:self action:@selector(CollectionUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        OpenUserProfileButton.tag = i;
//        [MainScroll addSubview:OpenUserProfileButton];
//        
//       // NSString *usernameTemp = [[NSString alloc]initWithFormat:@"%@",[arrUsername objectAtIndex:i]];
//        
//        UILabel *ShowUserName = [[UILabel alloc]init];
//        ShowUserName.frame = CGRectMake(75 + i * (screenWidth - 40), 21 + 10, screenWidth - 75 - 100, 40);
//        ShowUserName.text = @"ahyongah";
//        ShowUserName.backgroundColor = [UIColor clearColor];
//        ShowUserName.textColor = [UIColor whiteColor];
//        ShowUserName.textAlignment = NSTextAlignmentLeft;
//        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
//        [MainScroll addSubview:ShowUserName];
        
        UILabel *ShowCollectionTitle = [[UILabel alloc]init];
        ShowCollectionTitle.frame = CGRectMake(25 + i * (screenWidth - 40), 180, screenWidth - 190 , 20);
        ShowCollectionTitle.text = @"This is title";
        ShowCollectionTitle.backgroundColor = [UIColor clearColor];
        ShowCollectionTitle.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        ShowCollectionTitle.textAlignment = NSTextAlignmentLeft;
        ShowCollectionTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:16];
        [MainScroll addSubview:ShowCollectionTitle];
        
        
       // NSString *TempCount = [[NSString alloc]initWithFormat:@"%@ recommendations",[arrTotalCount objectAtIndex:i]];
        
        UILabel *ShowCollectionCount = [[UILabel alloc]init];
        ShowCollectionCount.frame = CGRectMake(25 + i * (screenWidth - 40), 200, screenWidth - 190, 20);
        ShowCollectionCount.text = @"10 recommendations";
        ShowCollectionCount.backgroundColor = [UIColor clearColor];
        ShowCollectionCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowCollectionCount.textAlignment = NSTextAlignmentLeft;
        ShowCollectionCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
        [MainScroll addSubview:ShowCollectionCount];
        
        
       // NSString *CheckCollectionFollowing = [[NSString alloc]initWithFormat:@"%@",[arrFollowing objectAtIndex:i]];
        NSString *CheckCollectionFollowing = @"0";
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
        //[QuickCollectButtonLocalQR addTarget:self action:@selector(CollectionFollowingButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        QuickCollectButtonLocalQR.tag = i;
        [MainScroll addSubview:QuickCollectButtonLocalQR];
        MainScroll.contentSize = CGSizeMake(20 + i * (screenWidth - 40) + (screenWidth - 50), 200);
    }
}
@end
