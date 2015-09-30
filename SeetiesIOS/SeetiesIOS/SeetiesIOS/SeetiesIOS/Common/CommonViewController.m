//
//  CommonViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"


#define TAB_BAR_HEIGHT 50.0f
@interface CommonViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.transitioningDelegate = self;
   // self.modalPresentationStyle = UIModalPresentationCustom;
       // Do any additional setup after loading the view.
}

-(void)applyTabBarContraint
{

    if (self.bottomConstraint) {
        self.bottomConstraint.constant = TAB_BAR_HEIGHT;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(id)init{
    
    if (self = [super init]) {
      //  self.navController = [[UINavigationController alloc]initWithRootViewController:self];
       // [[self navController] setNavigationBarHidden:YES animated:NO];
        
//        SLog(@"view height before : %f",self.view.bounds.size.height);
//        self.view.bounds = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-TAB_BAR_HEIGHT);
//        SLog(@"view height after: %f",self.view.bounds.size.height);
//
//        [self.view updateConstraints];
//        [self.view layoutIfNeeded];
    }
    
    return self;
}
#pragma mark - UIViewControllerTransitionDelegate -

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return [[PresentingAnimationController alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[DismissingAnimationController alloc] init];
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
