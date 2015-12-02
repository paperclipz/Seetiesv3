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
    [Utils setRoundBorder:ShowbackLine color:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f] borderRadius:0.0f borderWidth:1.0f];
    
    ShowRelatedCollectionsText.frame = CGRectMake(20, 0, screenWidth - 40, 50);
    ShowRelatedCollectionsText.text = @"Related Collections";
    ShowRelatedCollectionsText.backgroundColor = [UIColor clearColor];
    
    MainScroll.delegate = self;
    MainScroll.backgroundColor = [UIColor whiteColor];
    MainScroll.frame = CGRectMake(0, 50, screenWidth, 260);
    
    // init scroll view data
    [self InitScrollViewData];

    
    SeeAllButton.frame = CGRectMake(-1, self.frame.size.height - 70, screenWidth + 2, 50);
    [SeeAllButton setTitle:@"See all 5 Collections" forState:UIControlStateNormal];
    SeeAllButton.backgroundColor = [UIColor whiteColor];
    [Utils setRoundBorder:SeeAllButton color:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f] borderRadius:0.0f borderWidth:1.0f];
  
}

-(UIButton*)setupButton
{
    UIButton *TempButton = [[UIButton alloc]init];
    [TempButton setTitle:@"" forState:UIControlStateNormal];
    TempButton.backgroundColor = [UIColor whiteColor];
    [Utils setRoundBorder:TempButton color:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f] borderRadius:10.0f borderWidth:1.0f];

    return TempButton;
}
-(AsyncImageView*)SetupImage
{

    AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
    ShowImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowImage.layer.cornerRadius= 10;
    ShowImage.layer.masksToBounds = YES;
    ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
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

    for (int i = 0; i < 3; i++) {
       
        UIButton* button = [self setupButton];
        button.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,220);
        [MainScroll addSubview:button];
        
        AsyncImageView *ShowImage1 = [self SetupImage];
        ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,150);
        [MainScroll addSubview:ShowImage1];
        
//        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[arrImageData objectAtIndex:i]];
//        NSArray *SplitArray_TempImage = [TempImage componentsSeparatedByString:@"^^^"];
//        if ([SplitArray_TempImage count] == 1) {
//            AsyncImageView *ShowImage1 = [self SetupImage];
//            ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,150);
//            NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:0]];
//            if ([ImageData length] == 0) {
//                ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
//            }else{
//                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
//                ShowImage1.imageURL = url_NearbySmall;
//            }
//            [MainScroll addSubview:ShowImage1];
//        }else{
//            AsyncImageView *ShowImage1 = [self SetupImage];
//            ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,150);
//            NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:0]];
//            if ([ImageData length] == 0) {
//                ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
//            }else{
//                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
//                ShowImage1.imageURL = url_NearbySmall;
//            }
//            [MainScroll addSubview:ShowImage1];
//            
//            AsyncImageView *ShowImage2 = [self SetupImage];
//            ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,150);
//            NSString *ImageData100 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:1]];
//            if ([ImageData100 length] == 0) {
//                ShowImage2.image = [UIImage imageNamed:@"NoImage.png"];
//            }else{
//                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData100];
//                ShowImage2.imageURL = url_NearbySmall;
//            }
//            [MainScroll addSubview:ShowImage2];
//        }

        
        UIImageView *ShowOverlayImg = [self SetupOverlayImage];
        ShowOverlayImg.frame = CGRectMake(10 + i * (screenWidth - 40), 20 , screenWidth - 50 ,180);
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
        
        UILabel *ShowCollectionTitle = [self SetupLabel];
        ShowCollectionTitle.frame = CGRectMake(25 + i * (screenWidth - 40), 180, screenWidth - 190 , 20);
        ShowCollectionTitle.text = @"This is title";
        ShowCollectionTitle.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        ShowCollectionTitle.font = [UIFont fontWithName:CustomFontNameBold size:16];
        [MainScroll addSubview:ShowCollectionTitle];
        
        
       // NSString *TempCount = [[NSString alloc]initWithFormat:@"%@ recommendations",[arrTotalCount objectAtIndex:i]];
        
        UILabel *ShowCollectionCount = [self SetupLabel];
        ShowCollectionCount.frame = CGRectMake(25 + i * (screenWidth - 40), 200, screenWidth - 190, 20);
        ShowCollectionCount.text = @"10 recommendations";
        ShowCollectionCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowCollectionCount.font = [UIFont fontWithName:CustomFontName size:14];
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
