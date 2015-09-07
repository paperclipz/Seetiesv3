//
//  RecommendPopUpViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 8/5/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "RecommendPopUpViewController.h"
#import "LeveyTabBarController.h"
//#import "DraftViewController.h"
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
    TempBackground.backgroundColor = [UIColor whiteColor];
    TempBackground.alpha = 0.8f;
    [self.view addSubview:TempBackground];

    BackgroundButton = [[UIButton alloc]init];
    BackgroundButton.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [BackgroundButton setTitle:@"" forState:UIControlStateNormal];
    BackgroundButton.backgroundColor = [UIColor clearColor];
   // [BackgroundButton addTarget:self action:@selector(BackgroundButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BackgroundButton];
    

    
    ShowSelectImageButton = [[UIButton alloc]init];
    ShowSelectImageButton.frame = CGRectMake(0, screenHeight - 100, screenWidth, 50);
    [ShowSelectImageButton setTitle:@"Write a Recommendation" forState:UIControlStateNormal];
    [ShowSelectImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ShowSelectImageButton.backgroundColor = [UIColor whiteColor];
    [ShowSelectImageButton addTarget:self action:@selector(OpenSelectImgButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ShowSelectImageButton];
    
    ShowSelectDaftButton = [[UIButton alloc]init];
    ShowSelectDaftButton.frame = CGRectMake(0,  screenHeight - 150 , screenWidth, 50);
    [ShowSelectDaftButton setTitle:@"Saved Drafts" forState:UIControlStateNormal];
    [ShowSelectDaftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ShowSelectDaftButton.backgroundColor = [UIColor whiteColor];
    [ShowSelectDaftButton addTarget:self action:@selector(OpenDraftButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ShowSelectDaftButton];
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, screenHeight - 100, screenWidth, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal]; // 238 238 238
    [Line01 setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f]];
    [self.view addSubview:Line01];
    
    UIButton *Line02 = [[UIButton alloc]init];
    Line02.frame = CGRectMake(0, screenHeight - 150, screenWidth, 1);
    [Line02 setTitle:@"" forState:UIControlStateNormal];
    [Line02 setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f]];
    [self.view addSubview:Line02];
    
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
    
//    NSLog(@"in here????");
//    TempBackground.hidden = NO;
//    ShowSelectImageButton.frame = CGRectMake(160, 800, 100, 100);
//    ShowSelectDaftButton.frame = CGRectMake(160, 800, 100, 100);
//    
//    [UIView animateWithDuration:0.2f
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         ShowSelectImageButton.frame = CGRectMake(160, 300, 100, 100);
//                         ShowSelectDaftButton.frame = CGRectMake(160, 300, 100, 100);
//                     }
//                     completion:^(BOOL finished) {
//                         
//                         [UIView animateWithDuration:0.2f
//                                               delay:0
//                                             options:UIViewAnimationOptionCurveEaseOut
//                                          animations:^{
//                                              ShowSelectImageButton.frame = CGRectMake(50, 300, 100, 100);
//                                              ShowSelectDaftButton.frame = CGRectMake(250, 300, 100, 100);
//                                          }
//                                          completion:^(BOOL finished) {
//                                              
//                                          }];
//                     }];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
-(IBAction)OpenSelectImgButton:(id)sender{
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_ASSET;//DO_PICKER_RESULT_UIIMAGE
    cont.nMaxCount = 10;
    cont.nColumnCount = 3;
    
    [self presentViewController:cont animated:YES completion:nil];
    //[self.view.window.rootViewController presentViewController:cont animated:YES completion:nil];
}
-(IBAction)OpenDraftButton:(id)sender{

//    DraftViewController *OpenDraft = [[DraftViewController alloc]init];
//    [self presentViewController:OpenDraft animated:YES completion:nil];
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
                                              [self.leveyTabBarController setSelectedIndex:0];
                                              NSLog(@"self.leveyTabBarController === %@",self.leveyTabBarController);

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
