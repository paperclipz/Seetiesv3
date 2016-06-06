//
//  STAlertController.m
//  TEST
//
//  Created by ZackTvZ on 6/2/16.
//  Copyright © 2016 ZackTvZ. All rights reserved.
//

#import "STAlertController.h"
#import "STAlertTypeViewController.h"
#import "QuartzCore/QuartzCore.h"

#define defaultDuration 0.25
#define defaultshowDuration 3


@interface STAlertController ()<UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *messages;
@property(strong, nonatomic)STAlertTypeViewController *showView;
@property(assign, nonatomic)Boolean isShowing;
@property(strong, nonatomic)NSTimer *timer;
@end

@implementation STAlertController
+ (STAlertController *)instance {
    
    static STAlertController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.messages = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

///// popover only
+(void)popoverErroMessage:(NSString *)message target:(id)target popFrom:(id)popFrom{
    STAlertTypeViewController *controller = [[STAlertTypeViewController alloc]
                                    initWithNibName:@"STAlertTypeViewController"
                                             bundle:nil
                                        stAlertType:STAlertPopover
                                            message:message];
    
    controller.preferredContentSize = CGSizeMake([popFrom frame].size.width, 50);
    
    controller.view.clipsToBounds = YES;
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    popController.delegate = [self instance];
    popController.backgroundColor = controller.view.backgroundColor;
    
    // in case we don't have a bar button as reference
    popController.sourceView = [target view];
    popController.sourceRect = [[self instance] getViewRect:popFrom target:target];
    popController.canOverlapSourceViewRect = NO;
    [target presentViewController:controller animated:YES completion:nil];
}

-(CGRect)getViewRect:(UIView *)view target:(id)target{
    CGPoint viewPoint = [view convertPoint:view.bounds.origin toView:[target view]];
    return CGRectMake(viewPoint.x, viewPoint.y, view.frame.size.width, view.frame.size.height);
    
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

/////
+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message{
    [self presentSTAlertType:stAlertType stAlertDisplayType:stAlertDisplayType message:message tapClose:nil];
}

+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message tapClose:(TapClose)tapClose{
    [self presentSTAlertType:stAlertType stAlertDisplayType:stAlertDisplayType message:message tapClose:tapClose duration:defaultDuration];
}

+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message tapClose:(TapClose)tapClose duration:(NSTimeInterval)duration{
    [self presentSTAlertType:stAlertType stAlertDisplayType:stAlertDisplayType message:message tapClose:tapClose duration:duration showDuration:defaultshowDuration];
}

+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message tapClose:(TapClose)tapClose duration:(NSTimeInterval)duration showDuration:(NSTimeInterval)showDuration{
    [self presentSTAlertType:stAlertType stAlertDisplayType:stAlertDisplayType message:message onlyCurrentViewShow:NO tapClose:tapClose duration:duration showDuration:showDuration];
}

/////
+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message onlyCurrentViewShow:(BOOL)onlyCurrentViewShow{
    [self presentSTAlertType:stAlertType stAlertDisplayType:stAlertDisplayType message:message onlyCurrentViewShow:onlyCurrentViewShow tapClose:nil];
}

+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message onlyCurrentViewShow:(BOOL)onlyCurrentViewShow tapClose:(TapClose)tapClose{
    [self presentSTAlertType:stAlertType stAlertDisplayType:stAlertDisplayType message:message onlyCurrentViewShow:onlyCurrentViewShow tapClose:tapClose duration:defaultDuration];
}

+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message onlyCurrentViewShow:(BOOL)onlyCurrentViewShow tapClose:(TapClose)tapClose duration:(NSTimeInterval)duration{
    [self presentSTAlertType:stAlertType stAlertDisplayType:stAlertDisplayType message:message onlyCurrentViewShow:onlyCurrentViewShow tapClose:tapClose duration:duration showDuration:defaultshowDuration];
}

+(void)presentSTAlertType:(STAlertType)stAlertType stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType message:(NSString *)message  onlyCurrentViewShow:(BOOL)onlyCurrentViewShow tapClose:(TapClose)tapClose duration:(NSTimeInterval)duration showDuration:(NSTimeInterval)showDuration{
    
    STAlertTypeViewController *v = [[STAlertTypeViewController alloc]
                                    initWithNibName:@"STAlertTypeViewController"
                                    bundle:nil
                                    stAlertType:stAlertType
                                    stAlertDisplayType:stAlertDisplayType
                                    message:message
                                    duration:duration
                                    showDuration:showDuration
                                    topView:[[STAlertController instance] topViewController]
                                    tapClose:tapClose
                                    onlyCurrentViewShow:onlyCurrentViewShow];
    
    [STAlertController prepareNotificationToBeShown:v];
}

+ (void)prepareNotificationToBeShown:(STAlertTypeViewController *)messageView
{
    for (STAlertTypeViewController *vc in [STAlertController instance].messages) {
        if([vc.message isEqualToString:messageView.message]){
            return;
        }
    }
    
    
    [[STAlertController instance].messages addObject:messageView];
    
    if(![STAlertController instance].isShowing)
        [[STAlertController instance] showAlert];
}


-(void)showAlert{
    if(self.messages.count==0)
        return;
    
    self.showView = [self.messages objectAtIndex:0];
    //show on current view only not working with ori navigation bar
    BOOL onlyCurrentViewShow = self.showView.onlyCurrentViewShow&&self.showView.topView.navigationController.navigationBarHidden;
    
    
    if(![self.showView.topView isMemberOfClass:[[self topViewController] class]]){
        [self prepareForNextMessage];
        return;
    }
    self.isShowing = YES;
    
    CGRect rect  = self.showView.view.frame;
    rect.origin.y = [self getSTAlertPositionY];
    rect.size.height = 0;
    self.showView.view.frame = rect;
    
    if(self.showView.topView.navigationController&&self.showView.stAlertDisplayType==STAlertDisplayTypeOverlayNavBar&&!onlyCurrentViewShow)
        [self.showView.topView.navigationController.view addSubview:self.showView.view];
    else if(self.showView.topView.tabBarController&&self.showView.stAlertDisplayType==STAlertDisplayTypeOverlayTabBar&&!onlyCurrentViewShow)
        [self.showView.topView.tabBarController.view addSubview:self.showView.view];
    else
        [self.showView.topView.view addSubview:self.showView.view];
    self.showView.view.layer.zPosition = 1;
    if(self.showView.stAlertDisplayType == STAlertDisplayTypeBottom || self.showView.stAlertDisplayType == STAlertDisplayTypeOverlayTabBar){
        rect.origin.y -=self.showView.oriHeight;
    }
    rect.size.height = self.showView.oriHeight;
    [UIView animateWithDuration:self.showView.duration animations:^{
        if(self.showView.stAlertDisplayType == STAlertDisplayTypeOverlayNavBar || rect.origin.y == 0)
            [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar+1];
        self.showView.view.frame = rect;
    } completion:^(BOOL finished) {
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.showView.showDuration target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
    }];
}

-(void)dismissAlert{
    [self dismissAlert:YES];
}

-(void)dismissAlert:(BOOL)animation{
    CGRect rect  = self.showView.view.frame;
    rect.origin.y = [self getSTAlertPositionY];
    rect.size.height = 0;
    if(animation){
        [UIView animateWithDuration:self.showView.duration animations:^{
            self.showView.view.frame = rect;
        } completion:^(BOOL finished) {
            [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelNormal];
            [self.showView.view removeFromSuperview];
            [self prepareForNextMessage];
            
        }];
    }else{
        self.showView.view.frame = rect;
        [self.showView.view removeFromSuperview];
        [self prepareForNextMessage];
    }
}

- (void)fadeOutNotification:(STAlertTypeViewController *)currentView
{
    if(currentView == self.showView && self.timer.isValid){
        [self.timer invalidate];
        [self dismissAlert];
    }
}

-(void)prepareForNextMessage{
    [self.messages removeObject:self.showView];
    self.isShowing = NO;
    [self showAlert];
}

//getTopViewController
- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

//get notificaiton Y
-(int)getSTAlertPositionY{
    //Bottom
    if(self.showView.stAlertDisplayType == STAlertDisplayTypeBottom || self.showView.stAlertDisplayType == STAlertDisplayTypeOverlayTabBar){
//        return [self get_visible_size_bottom].height;
        NSLog(@"height = %f",[[UIScreen mainScreen] bounds].size.height);
        return (self.showView.stAlertDisplayType==STAlertDisplayTypeOverlayTabBar)?[[UIScreen mainScreen] bounds].size.height:[self get_visible_size_bottom].height;
    }
    
    //Top
    UIViewController *vcParent = self.showView.topView.parentViewController;
    if ([vcParent isKindOfClass:[UITabBarController class]]) {
        return vcParent.presentingViewController.view.frame.origin.y;
    } else if ([vcParent isKindOfClass:[UINavigationController class]]) {
        return (self.showView.stAlertDisplayType==STAlertDisplayTypeOverlayNavBar)?0:[self get_visible_size_top].height;
    } else if (vcParent.presentedViewController) {
        return vcParent.presentedViewController.view.frame.origin.y;
    } else {
        return 0;
    }
}

//get Y when STAlertDisplayTypeOverlayNavBar|STAlertDisplayTypeTop
- (CGSize)get_visible_size_top {
    CGSize result;
    CGSize size;
    
    
        size = [[UIApplication sharedApplication] statusBarFrame].size;
        result.height +=size.height;
    
        if (self.showView.topView.navigationController != nil) {
            size = self.showView.topView.navigationController.navigationBar.frame.size;
            result.height +=size.height;
        }
    
    return result;
}

//get Y when STAlertDisplayTypeBottom
- (CGSize)get_visible_size_bottom {
    CGSize result;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    result = size;
    
    if (self.showView.topView.tabBarController != nil) {
        size = self.showView.topView.tabBarController.tabBar.frame.size;
        
        result.height -= MIN(size.width, self.showView.topView.tabBarController.tabBar.isHidden?0:size.height);
    }
    
    return result;
}

@end
