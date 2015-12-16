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
    IBOutlet UIButton *ShowbackLineSeeAll;
    
    IBOutlet UIScrollView *MainScroll;

}
@property(nonatomic,strong)NSMutableArray* arrShop;
@property (strong, nonatomic) SeetiShopsModel* seetiShopsModel;
@property(nonatomic,strong)NSString* seetiesID;
@property(nonatomic,strong)NSString* placeID;
@property(nonatomic,strong)NSString* postID;
@property(nonatomic,assign)float shoplat;
@property(nonatomic,assign)float shopLgn;
@end
@implementation SeNearbySeetishop

- (IBAction)btnSeeAllClicked:(id)sender {
    
    if (self.btnSelectSeetiShopListBlock) {
        self.btnSelectSeetiShopListBlock();
    }
}

-(void)initSelfView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.frame = CGRectMake(0, 0, screenWidth, 300);
    self.backgroundColor = [UIColor clearColor];
    
    ShowbackLine.frame = CGRectMake(-1, 0, screenWidth + 2 , 50);
    [ShowbackLine setTitle:@"" forState:UIControlStateNormal];
    ShowbackLine.backgroundColor = [UIColor whiteColor];
    [Utils setRoundBorder:ShowbackLine color:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f] borderRadius:0.0f borderWidth:1.0f];
    
    ShowSeenearbySeetishop.frame = CGRectMake(20, 0, screenWidth - 40, 50);
    ShowSeenearbySeetishop.text = LocalisedString(@"See nearby Seetishop");
    ShowSeenearbySeetishop.backgroundColor = [UIColor clearColor];
    
    ShowbackLineSeeAll.frame = CGRectMake(-1, 250, screenWidth + 2 , 50);
    [ShowbackLineSeeAll setTitle:@"" forState:UIControlStateNormal];
    ShowbackLineSeeAll.backgroundColor = [UIColor whiteColor];
    [Utils setRoundBorder:ShowbackLineSeeAll color:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f] borderRadius:0.0f borderWidth:1.0f];
    
    SeeAllButton.frame = CGRectMake(0, 250, screenWidth, 50);
    [SeeAllButton setTitle:LocalisedString(@"See All") forState:UIControlStateNormal];
    SeeAllButton.backgroundColor = [UIColor clearColor];
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 50, screenWidth, 200);
    MainScroll.backgroundColor = [UIColor whiteColor];
    
    
}

-(void)InitNearByViewData{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    int GetWidth = (screenWidth - 100) / 3;
    NSLog(@"GetWidth is %d",GetWidth);
    
    for (int i = 0 ; i < [self.arrShop count]; i++) {
        ShopModel* shopModel = self.arrShop[i];
        
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(25 + i * (GetWidth + 25), 0 , GetWidth ,200);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor clearColor];
        [MainScroll addSubview: TempButton];
        
        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(25 + i * (GetWidth + 25), 20, GetWidth, GetWidth);
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius = GetWidth / 2;
        ShowUserProfileImage.layer.masksToBounds = YES;
        
        if (![shopModel.arrPhotos isNull])
        {
            PhotoModel* ImgModel = shopModel.arrPhotos[0];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
            NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",ImgModel.imageURL];
            if ([ImageData1 length] == 0) {
                ShowUserProfileImage.image = [UIImage imageNamed:@"NoImage.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
                ShowUserProfileImage.imageURL = url_NearbySmall;
            }
        }else{
             ShowUserProfileImage.image = [UIImage imageNamed:@"NoImage.png"];
        }


        [MainScroll addSubview:ShowUserProfileImage];
        
        UILabel *ShowTitle = [[UILabel alloc]init];
        ShowTitle.frame = CGRectMake(25 + i * (GetWidth + 25), 20 + GetWidth + 5, GetWidth, GetWidth);
        ShowTitle.text = shopModel.name;
        ShowTitle.backgroundColor = [UIColor clearColor];
        ShowTitle.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowTitle.textAlignment = NSTextAlignmentCenter;
        ShowTitle.font = [UIFont fontWithName:CustomFontNameBold size:14];
        ShowTitle.numberOfLines = 3;
        [MainScroll addSubview:ShowTitle];


        
        MainScroll.contentSize = CGSizeMake(GetWidth + 50 + i * (GetWidth + 25), 200);
    }

}
-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID
{
    self.seetiesID = seetiesID;
    self.placeID = placeID;
    self.postID = postID;
    self.shoplat = [[SearchManager Instance]getLocation].coordinate.latitude;
    self.shopLgn = [[SearchManager Instance]getLocation].coordinate.longitude;
    [self requestServerForSeetiShopNearbyShop];

}

-(void)requestServerForSeetiShopNearbyShop
{
    //  NSDictionary* param;
    NSString* appendString = @"56397e301c4d5be92e8b4711/nearby/shops";
    NSDictionary* dict = @{@"limit":@"6",
                           @"offset":@"1",
                           @"lat" : @(self.shoplat),
                           @"lng" : @(self.shopLgn),                           
                           };
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetoShopNearbyShop param:dict appendString:appendString completeHandler:^(id object) {
        
        self.seetiShopsModel = [[ConnectionManager dataManager]seNearbyShopModel];
        [self.arrShop addObjectsFromArray:self.seetiShopsModel.userPostData.shops];

        [self InitNearByViewData];
        
        if (self.viewDidFinishLoadBlock) {
            self.viewDidFinishLoadBlock();
        }
    } errorBlock:^(id object) {
        
        
    }];
    
}
-(NSMutableArray*)arrShop
{
    if(!_arrShop)
    {
        _arrShop = [NSMutableArray new];
    }
    return _arrShop;
}
@end
