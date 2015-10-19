//
//  ProfileViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+FX.h"
#import "UIScrollView+APParallaxHeader.h"

//#import "ParallaxHeaderView.h"


@interface ProfileViewController ()
{
    NSMutableArray* arrayTag;
}
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfilePic;
@property (strong, nonatomic) IBOutlet UIView *ibTopContentView;
@property (strong, nonatomic) IBOutlet UIView *ibContentView;
@property (strong, nonatomic) IBOutlet TLTagsControl *ibTagControlView;

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
    
    [self initTagView];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [Utils setRoundBorder:self.ibImgProfilePic color:[UIColor whiteColor] borderRadius:self.ibImgProfilePic.frame.size.width/2 borderWidth:6.0f];

    
    //set image from url
    [self.ibImgProfilePic sd_setImageWithURL:[NSURL URLWithString:@"http://www.ambwallpapers.com/wp-content/uploads/2015/02/scarlett-johansson-wallpapers-2.jpg"] placeholderImage:[UIImage imageNamed:@"DefaultProfilePic.png"]];

    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:@"http://i.ytimg.com/vi/tjW1mKwNUSo/maxresdefault.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.backgroundImageView.image = [image imageCroppedAndScaledToSize:self.backgroundImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
        
    }];
    
    // add parallax view with top content and content
    [self.ibScrollView addParallaxWithView:self.backgroundImageView andHeight:200];
    self.ibScrollView.parallaxView.shadowView.hidden = YES;
    self.ibScrollView.contentSize = CGSizeMake(self.ibScrollView.frame.size.width, self.ibContentView.frame.size.height);
    [self.ibScrollView addSubview:self.ibContentView];
    self.ibContentView.frame = CGRectMake(self.ibContentView.frame.origin.x, self.ibContentView.frame.origin.y- self.ibImgProfilePic.frame.size.height/2, self.ibContentView.frame.size.width, self.ibContentView.frame.size.height);

}

-(UIImageView*)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 212)];
        [_backgroundImageView adjustToScreenWidth];
    }
    
    return _backgroundImageView;
}

#pragma mark - Tag
-(void)initTagView
{
    arrayTag = [[NSMutableArray alloc]initWithArray:@[@"111",@"222",@"333",@"111",@"222",@"333",@"111",@"222",@"333"]];
    _ibTagControlView.tags = arrayTag;
    _ibTagControlView.mode = TLTagsControlModeEdit;
    _ibTagControlView.tagPlaceholder = @"Tag";
    [_ibTagControlView setTapDelegate:self];
    UIColor *whiteTextColor = [UIColor whiteColor];
    
    _ibTagControlView.tagsBackgroundColor = DEVICE_COLOR;
    _ibTagControlView.tagsTextColor = whiteTextColor;
    [_ibTagControlView reloadTagSubviewsCustom];
    
}

- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index
{
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

@end
