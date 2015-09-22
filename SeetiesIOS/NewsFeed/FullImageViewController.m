//
//  FullImageViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "FullImageViewController.h"
#import "AsyncImageView.h"
@interface FullImageViewController ()

@end

@implementation FullImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    pageControlBeingUsed = NO;
    [MImageScroll setScrollEnabled:YES];
    MImageScroll.delegate = self;
    [MImageScroll setBounces:NO];
    MImageScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowImageCount.frame = CGRectMake(15, screenHeight - 70, screenWidth - 30, 50);
    BackButton.frame = CGRectMake(5, 20, 50, 50);
    
    [self.view addSubview:ShowImageCount];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /* Listen for keyboard */
    self.screenName = @"IOS Full Image Page";
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) prefersStatusBarHidden
{
    return YES;
}
-(IBAction)BackButton:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)GetAllImageArray:(NSMutableArray *)AllImageArray GetIDN:(NSInteger)ImageIdn GetAllCaptionArray:(NSMutableArray *)AllCaptionArray{
    NSLog(@"FullImageView GetAllImageArray");
    GetAllFullImageArray = [[NSMutableArray alloc]initWithArray:AllImageArray];
    GetAllFullCaptionArray = [[NSMutableArray alloc]initWithArray:AllCaptionArray];
    GetCurrentIdn = ImageIdn;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSLog(@"GetAllFullImageArray is %@",GetAllFullImageArray);
    NSLog(@"GetCurrentIdn is %li",(long)GetCurrentIdn);
    
    for (int i = 0 ; i < [GetAllFullImageArray count]; i++) {
        ImageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0 + i * screenWidth, 0, screenWidth, screenHeight)];
        ImageScroll.delegate = self;
        //  ImageScroll.tag = 50000 + j;
        ImageScroll.minimumZoomScale = 1;
        ImageScroll.maximumZoomScale = 4;
        [ImageScroll setScrollEnabled:YES];
        [ImageScroll setNeedsDisplay];
        [MImageScroll addSubview:ImageScroll];
        
        ShowImage = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[GetAllFullImageArray objectAtIndex:i]];
        NSLog(@"FullImagesURL ====== %@",FullImagesURL);
        //  NSURL *url = [NSURL URLWithString:FullImagesURL];
        NSURL *theURL = [NSURL URLWithString:FullImagesURL];
        ShowImage.imageURL = theURL;
        ShowImage.contentMode = UIViewContentModeScaleAspectFit;
        ShowImage.clipsToBounds = YES;
        ShowImage.backgroundColor = [UIColor clearColor];
        ShowImage.tag = 6000000;
        [ImageScroll addSubview:ShowImage];
        
        NSLog(@"ImageScroll is %@",ImageScroll);
        
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(15 + i *screenWidth, screenHeight - 90, screenWidth - 30, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setBackgroundColor:[UIColor whiteColor]];
        [MImageScroll addSubview:Line01];
        
        
        NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",[GetAllFullCaptionArray objectAtIndex:i]];
     //   NSString *TempGetStirngMessage = @"Have a nice trip to Port Dickson with all the amazing people!";
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
        TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
        UILabel *ShowCaptionText = [[UILabel alloc]init];
        //  ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, 265, screenWidth - 30, 60);
        ShowCaptionText.numberOfLines = 0;
        ShowCaptionText.textColor = [UIColor whiteColor];
        // ShowCaptionText.text = [captionArray objectAtIndex:i];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:TempGetStirngMessage];
        NSString *str = TempGetStirngMessage;
        NSError *error = nil;
        
        //I Use regex to detect the pattern I want to change color
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
        NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        for (NSTextCheckingResult *match in matches) {
            NSRange wordRange = [match rangeAtIndex:0];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];
        }
        
        [ShowCaptionText setAttributedText:string];
        
        ShowCaptionText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowCaptionText.textAlignment = NSTextAlignmentLeft;
        ShowCaptionText.backgroundColor = [UIColor clearColor];
//        ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, screenHeight - 70 - [ShowCaptionText sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height , screenWidth - 30,[ShowCaptionText sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
        ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, screenHeight - 70, screenWidth - 60 - 30,[ShowCaptionText sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
        
        [MImageScroll addSubview:ShowCaptionText];
    }
    NSInteger productcount = [GetAllFullImageArray count];
    MImageScroll.contentSize = CGSizeMake(productcount * screenWidth, 170);
    
    NSLog(@"productcount is %li",(long)productcount);
    NSLog(@"productcount * screenWidth is %f",productcount * screenWidth);
    
    PageControlOn.currentPage = GetCurrentIdn;
    PageControlOn.numberOfPages = productcount;
    
    CGFloat x = GetCurrentIdn * screenWidth;
    NSLog(@"x is %f",x);
    [MImageScroll setContentOffset:CGPointMake(x, 0) animated:NO];
    
    NSString *TempString = [[NSString alloc]initWithFormat:@"%li/%lu",GetCurrentIdn + 1,(unsigned long)[GetAllFullImageArray count]];
    ShowImageCount.text = TempString;
    
    NSLog(@"MImageScroll is %@",MImageScroll);
    [self.view addSubview:MImageScroll];
    [self.view addSubview:BackButton];
    


}
-(void)GetLocalAllImageArray:(NSMutableArray *)AllImageArray GetIDN:(NSInteger)ImageIdn{
    GetAllFullImageArray = [[NSMutableArray alloc]initWithArray:AllImageArray];
    GetCurrentIdn = ImageIdn;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    for (int i = 0 ; i < [GetAllFullImageArray count]; i++) {
        ImageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake( 0+ i *screenWidth, 0, screenWidth, screenHeight)];
        ImageScroll.delegate = self;
        ImageScroll.minimumZoomScale = 1;
        ImageScroll.maximumZoomScale = 4;
        [ImageScroll setScrollEnabled:YES];
        [ImageScroll setNeedsDisplay];
        [MImageScroll addSubview:ImageScroll];
        
        ShowImage = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        ShowImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetAllFullImageArray objectAtIndex:i]]];
        ShowImage.contentMode = UIViewContentModeScaleAspectFit;
        ShowImage.backgroundColor = [UIColor clearColor];
        ShowImage.clipsToBounds = YES;
        ShowImage.tag = 6000000;
        [ImageScroll addSubview:ShowImage];
        
 
    }
    NSInteger productcount = [GetAllFullImageArray count];
    MImageScroll.contentSize = CGSizeMake(productcount * screenWidth, 170);
    
    PageControlOn.currentPage = GetCurrentIdn;
    PageControlOn.numberOfPages = productcount;
    
    CGFloat x = GetCurrentIdn * screenWidth;
    [MImageScroll setContentOffset:CGPointMake(x, 0) animated:NO];
    
    NSString *TempString = [[NSString alloc]initWithFormat:@"%li/%lu",GetCurrentIdn + 1,(unsigned long)[GetAllFullImageArray count]];
    ShowImageCount.text = TempString;
}
-(void)GetImageString:(NSString *)ImageString{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    GetImageString = ImageString;
    
    ImageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake( 0, 0, screenWidth, screenHeight)];
    ImageScroll.delegate = self;
    //  ImageScroll.tag = 50000 + j;
    ImageScroll.minimumZoomScale = 1;
    ImageScroll.maximumZoomScale = 4;
    [ImageScroll setScrollEnabled:YES];
    [ImageScroll setNeedsDisplay];
    [MImageScroll addSubview:ImageScroll];
    
    ShowImage = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
    NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",GetImageString];
    NSLog(@"FullImagesURL ====== %@",FullImagesURL);
    //  NSURL *url = [NSURL URLWithString:FullImagesURL];
    NSURL *theURL = [NSURL URLWithString:FullImagesURL];
    ShowImage.imageURL = theURL;
    ShowImage.contentMode = UIViewContentModeScaleAspectFit;
    ShowImage.backgroundColor = [UIColor clearColor];
    ShowImage.clipsToBounds = YES;
    ShowImage.tag = 6000000;
    [ImageScroll addSubview:ShowImage];
    
//    NSString *TempString = [[NSString alloc]initWithFormat:@"1/1"];
//    ShowImageCount.text = TempString;
}
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //  return ProductImage_view1;
    return [scrollView viewWithTag:ShowImage.tag];
}
- (IBAction)changePage {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = screenWidth * PageControlOn.currentPage;
    frame.origin.y = 0;
    frame.size = MImageScroll.frame.size;
    [MImageScroll scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
    NSLog(@"scrollViewWillBeginDragging scrollView is %@",scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
    NSLog(@"scrollViewDidEndDecelerating scrollView is %@",scrollView);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat pageWidth = screenWidth;
//    NSInteger page = (NSInteger)floor((MImageScroll.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
//    // Update the page control
//    PageControlOn.currentPage = page;
    
    CGFloat pageWidth = screenWidth; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = MImageScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    PageControlOn.currentPage = page; // you need to have a **iVar** with getter for pageControl
    
    NSString *TempString = [[NSString alloc]initWithFormat:@"%li/%lu",page + 1,(unsigned long)[GetAllFullImageArray count]];
    ShowImageCount.text = TempString;
    
}
@end
