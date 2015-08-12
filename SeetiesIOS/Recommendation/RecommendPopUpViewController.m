//
//  RecommendPopUpViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 8/5/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "RecommendPopUpViewController.h"
#import "LeveyTabBarController.h"
@interface RecommendPopUpViewController ()

@end

@implementation RecommendPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    TempBackground.hidden = NO;
    
    TempBackground = [[UIView alloc]init];
    TempBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    TempBackground.backgroundColor = [UIColor blackColor];
    TempBackground.alpha = 0.5f;
    [self.view addSubview:TempBackground];

    BackgroundButton = [[UIButton alloc]init];
    BackgroundButton.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [BackgroundButton setTitle:@"" forState:UIControlStateNormal];
    BackgroundButton.backgroundColor = [UIColor clearColor];
    [BackgroundButton addTarget:self action:@selector(BackgroundButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BackgroundButton];
    
    ShowSelectImageButton = [[UIButton alloc]init];
    ShowSelectImageButton.frame = CGRectMake(160, 800, 100, 100);
    [ShowSelectImageButton setTitle:@"Image" forState:UIControlStateNormal];
    ShowSelectImageButton.backgroundColor = [UIColor redColor];
     [ShowSelectImageButton addTarget:self action:@selector(OpenSelectImgButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ShowSelectImageButton];
    
    ShowSelectDaftButton = [[UIButton alloc]init];
    ShowSelectDaftButton.frame = CGRectMake(160, 800, 100, 100);
    [ShowSelectDaftButton setTitle:@"Draft" forState:UIControlStateNormal];
    ShowSelectDaftButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:ShowSelectDaftButton];
    
    CheckButtonClick = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"Selected INDEX OF TAB-BAR ==> %lu", (unsigned long)tabBarController.selectedIndex);
    
    if (tabBarController.selectedIndex == 3) {
        //[self getFeedsFromServer];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"in here????");
    TempBackground.hidden = NO;
    ShowSelectImageButton.frame = CGRectMake(160, 800, 100, 100);
    ShowSelectDaftButton.frame = CGRectMake(160, 800, 100, 100);
    
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         ShowSelectImageButton.frame = CGRectMake(160, 300, 100, 100);
                         ShowSelectDaftButton.frame = CGRectMake(160, 300, 100, 100);
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2f
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              ShowSelectImageButton.frame = CGRectMake(50, 300, 100, 100);
                                              ShowSelectDaftButton.frame = CGRectMake(250, 300, 100, 100);
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
     NSLog(@"out here????");
    
}
-(IBAction)OpenSelectImgButton:(id)sender{
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_ASSET;//DO_PICKER_RESULT_UIIMAGE
    cont.nMaxCount = 10;
    cont.nColumnCount = 3;
    
    [self presentViewController:cont animated:YES completion:nil];
    
}

-(IBAction)BackgroundButton:(id)sender{
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         ShowSelectImageButton.frame = CGRectMake(160, 300, 100, 100);
                         ShowSelectDaftButton.frame = CGRectMake(160, 300, 100, 100);
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2f
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              ShowSelectImageButton.frame = CGRectMake(160, 800, 100, 100);
                                              ShowSelectDaftButton.frame = CGRectMake(160, 800, 100, 100);
                                          }
                                          completion:^(BOOL finished) {
                                              TempBackground.hidden = YES;
                                              self.leveyTabBarController.selectedIndex = 0;
                                          }];
                     }];
    
    
}
#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
