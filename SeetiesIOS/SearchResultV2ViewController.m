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
    SearchTextField.frame = CGRectMake(15, 25, screenWidth - 60 - 20, 30);
    SearchAddressField.frame = CGRectMake(15, 58, screenWidth - 60 - 20, 30);
    CancelButton.frame = CGRectMake(screenWidth - 60, 25, 60, 30);
    FilterButton.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
    
    SearchTextField.delegate = self;
    SearchAddressField.delegate = self;
    
    [self.view addSubview:CancelButton];
    [self.view addSubview:SearchTextField];
    [self.view addSubview:SearchAddressField];
    
    NSString *TempStringCountries = [[NSString alloc]initWithFormat:@"Posts"];
    NSString *TempStringPeople = [[NSString alloc]initWithFormat:@"People"];
    
    NSArray *itemArray = [NSArray arrayWithObjects:TempStringCountries, TempStringPeople, nil];
    PostControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    PostControl.frame = CGRectMake(15, 105, screenWidth - 30, 29);
    [PostControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    PostControl.selectedSegmentIndex = 0;
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
    [self.view addSubview:PostControl];
    
}
- (void)segmentAction:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Posts click");
            break;
        case 1:
            NSLog(@"People click");
            break;
        default:
            break;
    }
    
    //[self InitView];
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
@end
