//
//  ProfileViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+FX.h"

//#import "ParallaxHeaderView.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfileBG;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfilePic;
@property (strong, nonatomic) IBOutlet UIView *ibTopContentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (strong, nonatomic) IBOutlet UIView *ibContentView;

@property (strong, nonatomic) IBOutlet UIImageView *viewHeader;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;

@end

@implementation ProfileViewController
- (IBAction)btnSegmentedControlClicked:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [Utils setRoundBorder:self.ibImgProfilePic color:[UIColor whiteColor] borderRadius:self.ibImgProfilePic.frame.size.width/2 borderWidth:6.0f];

    [self.ibImgProfilePic sd_setImageWithURL:[NSURL URLWithString:@"http://www.ambwallpapers.com/wp-content/uploads/2015/02/scarlett-johansson-wallpapers-2.jpg"] placeholderImage:[UIImage imageNamed:@"DefaultProfilePic.png"]];

    [self.ibImgProfileBG sd_setImageWithURL:[NSURL URLWithString:@"http://i.ytimg.com/vi/tjW1mKwNUSo/maxresdefault.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.ibImgProfileBG.image = [image imageCroppedAndScaledToSize:self.ibImgProfileBG.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
        
    }];
    

}

@end
