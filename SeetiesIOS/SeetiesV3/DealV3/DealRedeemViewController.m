//
//  DealRedeemViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/29/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealRedeemViewController.h"

@interface DealRedeemViewController ()
{
    
    float oldX, oldY;
    BOOL dragging;
    CGRect oldFrame;
    float activationDistance;
    BOOL activateDropEffect;

}
@property (weak, nonatomic) IBOutlet UIView *btnSwipy;
@property (weak, nonatomic) IBOutlet UIView *ibSwipeView;
@property (weak, nonatomic) IBOutlet UIView *ibTestView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation DealRedeemViewController
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    activationDistance = 200;
   
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
  In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  Get the new view controller using [segue destinationViewController].
  Pass the selected object to the new view controller.
 }
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[UIView class]]) {
        
        if (touch.view == self.btnSwipy) {
            dragging = YES;
            activateDropEffect = NO;
            oldX = touchLocation.x;
            oldY = touchLocation.y;
            
            UIView *label = touch.view;
            
            oldFrame = label.frame;

        }
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    UIView *label = touch.view;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (touch.view == self.btnSwipy) {
            label.frame = oldFrame;
        }
        
    }];
    dragging = NO;
    
    if (activateDropEffect) {
        UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.ibSwipeView]];
        //  gravityBehaviour.gravityDirection = CGVectorMake(0, 5);
        [self.animator addBehavior:gravityBehaviour];
        
        UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ibSwipeView]];
        [itemBehaviour addAngularVelocity:M_PI_2 forItem:self.ibSwipeView];
        [self.animator addBehavior:itemBehaviour];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[UIView class]]) {
        UIView *label = touch.view;
        if (touch.view == self.btnSwipy) {
            
            if (dragging) {
                CGRect frame = label.frame;
                
                if (frame.origin.x <= self.ibSwipeView.frame.size.width - frame.size.width - 10) {
                    frame.origin.x = label.frame.origin.x + touchLocation.x - oldX;
                }
                
                frame.origin.y = label.frame.origin.y;
                
                label.frame = frame;
                
                if (label.frame.origin.x - oldFrame.origin.x > activationDistance) {
                    SLog(@"activated");
                    activateDropEffect = YES;
                }
                
                //--------------------------------------------------------
                // Make sure we stay within the bounds of the parent view
                //--------------------------------------------------------
                
            }
        }
        
    }
}
@end
