//
//  ProfileViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+FX.h"
#import "ProfileCollectionTableViewCell.h"
#import "UIScrollView+APParallaxHeader.h"

//#import "ParallaxHeaderView.h"


@interface ProfileViewController ()<APParallaxViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfilePic;
@property (strong, nonatomic) IBOutlet UIView *ibTopContentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
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

    [self.ibImgProfilePic sd_setImageWithURL:[NSURL URLWithString:@"http://i2.listal.com/image/1005436/936full-rooney-mara.jpg"] placeholderImage:[UIImage imageNamed:@"DefaultProfilePic.png"]];

//    [self.ibImgProfileBG sd_setImageWithURL:[NSURL URLWithString:@"http://i.ytimg.com/vi/tjW1mKwNUSo/maxresdefault.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        self.ibImgProfileBG.image = [image imageCroppedAndScaledToSize:self.ibImgProfileBG.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
//        
//    }];
    
    [self initTableViewWithDelegate:self];

   // [self.ibTableView addParallaxWithView:self.ibTopContentView andHeight:160];
    
   // [self.ibTableView.parallaxView setDelegate:self];
    [self.ibTopContentView adjustToScreenWidth];

    UIImageView* imageView = [[UIImageView alloc]initWithFrame:self.ibTopContentView.frame];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://i.ytimg.com/vi/tjW1mKwNUSo/maxresdefault.jpg"]];
    [self.ibTableView addParallaxWithView:imageView andHeight:212];
    [imageView addSubview:self.ibTopContentView];
    self.ibTableView.parallaxView.shadowView.hidden = YES;

}


-(void)initTableViewWithDelegate:(id)delegate
{
    
    self.ibTableView.delegate = delegate;
    self.ibTableView.dataSource = delegate;
    [self.ibTableView registerClass:[ProfileCollectionTableViewCell class] forCellReuseIdentifier:@"ProfileCollectionTableViewCell"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.ibTopContentView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.ibTopContentView.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProfileCollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCollectionTableViewCell"];
    
    return cell;
}


@end
