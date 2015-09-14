//
//  SearchResultV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "SearchResultV2ViewController.h"

@interface SearchResultV2ViewController ()

@end

@implementation SearchResultV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 95);
    SearchTextField.frame = CGRectMake(50, 25, screenWidth - 60 - 20, 30);
    SearchAddressField.frame = CGRectMake(50, 58, screenWidth - 60 - 20, 30);
    FilterButton.frame = CGRectMake(screenWidth - 29 , 20, 41, 38);
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 95 , screenWidth, screenHeight - 95);

    
    SearchTextField.delegate = self;
    SearchAddressField.delegate = self;
    
    ShowSearchLocationView.frame = CGRectMake(0, 95, screenWidth, screenHeight - 95);
    ShowSearchLocationView.hidden = YES;
    [self.view addSubview:ShowSearchLocationView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)CancelButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    
    if(textField == SearchTextField){
        NSLog(@"SearchTextField begin");
     //   MainScroll.hidden = NO;
     //   ShowSearchLocationView.hidden = YES;
    }
    if (textField == SearchAddressField) {
        NSLog(@"SearchAddressField begin");
       // MainScroll.hidden = YES;
       // ShowSearchLocationView.hidden = NO;
       // [LocationTblView reloadData];
    }
    return YES;
}
@end
