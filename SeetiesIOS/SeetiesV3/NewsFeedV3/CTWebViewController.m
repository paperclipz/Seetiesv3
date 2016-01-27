//
//  CTWebViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/19/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CTWebViewController.h"

@interface CTWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *ibWebView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation CTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ibWebView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData:(AnnouncementModel*)model
{
    self.lblTitle.text = model.title[[Utils getDeviceAppLanguageCode]];
    [self.ibWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.relatedID]]];
    

}

-(void)initDataWithURL:(NSString *)url andTitle:(NSString*)title
{
    self.lblTitle.text = LocalisedString(title);
    [self.ibWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
