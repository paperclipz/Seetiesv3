//
//  SeNearbySeetishop.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 01/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeNearbySeetishop.h"
@interface SeNearbySeetishop()<UIScrollViewDelegate>{
    IBOutlet UIButton *ShowbackLine;
    IBOutlet UILabel *ShowSeenearbySeetishop;
    IBOutlet UIButton *SeeAllButton;
    
    IBOutlet UIScrollView *MainScroll;

}
@end
@implementation SeNearbySeetishop

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
    
    self.frame = CGRectMake(0, 0, screenWidth, 250);
    self.backgroundColor = [UIColor clearColor];
    
    ShowbackLine.frame = CGRectMake(-1, 0, screenWidth + 2 , 50);
    [ShowbackLine setTitle:@"" forState:UIControlStateNormal];
    ShowbackLine.backgroundColor = [UIColor whiteColor];
    [Utils setRoundBorder:ShowbackLine color:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f] borderRadius:0.0f borderWidth:1.0f];
    
    ShowSeenearbySeetishop.frame = CGRectMake(20, 0, screenWidth - 40, 50);
    ShowSeenearbySeetishop.text = @"See nearby Seetishop";
    ShowSeenearbySeetishop.backgroundColor = [UIColor clearColor];
    
    SeeAllButton.frame = CGRectMake(screenWidth - 120, 0, 100, 50);
    [SeeAllButton setTitle:@"See all" forState:UIControlStateNormal];
    SeeAllButton.backgroundColor = [UIColor clearColor];
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 50, screenWidth, 200);
    MainScroll.backgroundColor = [UIColor redColor];
    
    [self InitNearByViewData];
}

-(void)InitNearByViewData{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    int GetWidth = (screenWidth - 100) / 3;
    NSLog(@"GetWidth is %d",GetWidth);
    
    for (int i = 0 ; i < 6; i++) {
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(25 + i * (GetWidth + 25), 0 , GetWidth ,200);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor yellowColor];
        [MainScroll addSubview: TempButton];
        
        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(25 + i * (GetWidth + 25), 20, GetWidth, GetWidth);
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius = GetWidth / 2;
        ShowUserProfileImage.layer.masksToBounds = YES;
        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        //        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        //        NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
        //        if ([ImageData1 length] == 0) {
        //            ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        //        }else{
        //            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
        //            ShowUserProfileImage.imageURL = url_NearbySmall;
        //        }
        [MainScroll addSubview:ShowUserProfileImage];
        
        UILabel *ShowTitle = [[UILabel alloc]init];
        ShowTitle.frame = CGRectMake(25 + i * (GetWidth + 25), 20 + GetWidth + 5, GetWidth, GetWidth);
        ShowTitle.text = @"Butter + Beans";
        ShowTitle.backgroundColor = [UIColor purpleColor];
        ShowTitle.textColor = [UIColor blackColor];
        ShowTitle.textAlignment = NSTextAlignmentCenter;
        ShowTitle.font = [UIFont fontWithName:CustomFontNameBold size:15];
        ShowTitle.numberOfLines = 3;
        [MainScroll addSubview:ShowTitle];


        
        MainScroll.contentSize = CGSizeMake(GetWidth + 50 + i * (GetWidth + 25), 200);
    }

}
@end
