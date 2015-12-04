//
//  SeRecommendations.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 01/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeRecommendations.h"
@interface SeRecommendations(){
    IBOutlet UIButton *ShowbackLine;
    IBOutlet UILabel *ShowRecommendationsText;
    IBOutlet UIButton *SeeAllButton;

    int Getheight;
}
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
    
    [self InitRecommendationViewdata];
    
    
    SeeAllButton.frame = CGRectMake(-1, self.frame.size.height - 70, screenWidth + 2 , 50);
    [SeeAllButton setTitle:@"See all 6 recommendations" forState:UIControlStateNormal];
    SeeAllButton.backgroundColor = [UIColor whiteColor];
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
    
    NSMutableArray *ArrTitle = [[NSMutableArray alloc]init];
    [ArrTitle addObject:@""];
    [ArrTitle addObject:@"Rekindle Cafe is the best"];
    [ArrTitle addObject:@"weekend hangout"];
    
    NSMutableArray *ArrDetail = [[NSMutableArray alloc]init];
    [ArrDetail addObject:@""];
    [ArrDetail addObject:@""];
    [ArrDetail addObject:@"A good place to hangout with friend in night time."];
    
    for (int i = 0; i < 3; i++) {
        AsyncImageView *ShowUserProfileImage = [self SetupUserProfileImage];
        ShowUserProfileImage.frame = CGRectMake(20 , Getheight, 40, 40);
        [self addSubview:ShowUserProfileImage];
        
        UILabel *ShowUsername = [self SetupLabel];
        ShowUsername.frame = CGRectMake(80, Getheight, screenWidth - 100, 40);
        ShowUsername.text = @"Butter + Beans";
        ShowUsername.font = [UIFont fontWithName:CustomFontName size:15];
        [self addSubview:ShowUsername];
        
        Getheight += 40;
        

        NSString *TestTitle = [ArrTitle objectAtIndex:i];
        NSString *TestDetail = [ArrDetail objectAtIndex:i];
        
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
        
        for (int i = 0; i < 3; i++) {
            AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
            ShowUserProfileImage.frame = CGRectMake(80 + i * 65 , Getheight + 5, 60, 60);
            ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowUserProfileImage.layer.cornerRadius = 5;
            ShowUserProfileImage.layer.masksToBounds = YES;
            ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            [self addSubview:ShowUserProfileImage];
            
        }
        
        Getheight += 70;
        
        
        UIButton *Line04 = [self SetupLineBtn];
        Line04.frame = CGRectMake(20, Getheight + 10, screenWidth, 1);
        [self addSubview:Line04];
        

        Getheight += 30;
        

    }
    
    self.frame = CGRectMake(0, 0, screenWidth, Getheight + 50);

}
@end
