//
//  CommonViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"


@interface CommonViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@end

@implementation CommonViewController
- (IBAction)btnBackClicked:(id)sender {
    
    if (_btnBackBlock) {
        self.btnBackBlock(nil);
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeLanguage];
}



//-(void)applyTabBarContraint
//{
//    if (self.bottomConstraint) {
//        self.bottomConstraint.constant = TAB_BAR_HEIGHT;
//    }
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)init
{
    if (self = [super init])
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)changeLanguage
{
    if (self.lblTitle) {
        self.lblTitle.text = LocalisedString(self.lblTitle.text);
    }
}
@end
