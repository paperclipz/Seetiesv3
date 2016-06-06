//
//  STAlertTypeViewController.m
//  TEST
//
//  Created by ZackTvZ on 6/2/16.
//  Copyright © 2016 ZackTvZ. All rights reserved.
//

#import "STAlertTypeViewController.h"

@interface STAlertTypeViewController ()
- (IBAction)click:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *successView;
@property (strong, nonatomic) IBOutlet UIView *errorView;
@property (strong, nonatomic) IBOutlet UIView *testView;
@property (strong, nonatomic) IBOutlet UIView *popoverView;

//for popover only
@property(strong, nonatomic)NSTimer *timer;
@end

@implementation STAlertTypeViewController

-(id)initWithNibName:(NSString *)nibNameOrNil
              bundle:(NSBundle *)nibBundleOrNil
         stAlertType:(STAlertType)stAlertType
             message:(NSString *)message{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.stAlertType = stAlertType;
        self.message = message;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil
              bundle:(NSBundle *)nibBundleOrNil
         stAlertType:(STAlertType)stAlertType
  stAlertDisplayType:(STAlertDisplayType)stAlertDisplayType
             message:(NSString *)message
            duration:(NSTimeInterval)duration
        showDuration:(NSTimeInterval)showDuration
             topView:(UIViewController *)topView
            tapClose:(TapClose)tapClose
 onlyCurrentViewShow:(BOOL)onlyCurrentViewShow{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.stAlertType = stAlertType;
        self.stAlertDisplayType = stAlertDisplayType;
        self.message = message;
        self.duration = duration;
        self.showDuration = showDuration;
        self.topView = topView;
        self.didTapCloseBlock = tapClose;
        self.onlyCurrentViewShow = onlyCurrentViewShow;
    }
    return self;
}


-(void)setupDisplayType{
    
    switch (self.stAlertType) {
        case STAlertSuccess:
            self.view = self.successView;
            break;
        case STAlertError:
            self.view = self.errorView;
            break;
            
        default:
            break;
    }
    
    CGRect rect = self.view.frame;
    rect.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.view.frame = rect;
    self.oriHeight = self.view.frame.size.height;
    
}

-(void)setupPopoverDisplayType{
    self.view = self.popoverView;
    
    UILabel *label = [self.view viewWithTag:1];
    label.text = self.message;
    
    CGRect rect = label.frame;
    rect.size.width = self.preferredContentSize.width;
    label.frame = rect;
    [label sizeToFit];
    
    rect = self.view.frame;
    rect.size.width = label.frame.size.width+20;
    rect.size.height = label.frame.size.height+20;
    self.view.frame = rect;
    
    self.preferredContentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    self.oriHeight = self.view.frame.size.height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    if(self.stAlertType != STAlertPopover){
        [self setupTouchEvent];
        [self setupDisplayType];
        
        UILabel *label = [self.view viewWithTag:1];
        label.text = self.message;
    }else{
        [self setupPopoverDisplayType];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissPopover) userInfo:nil repeats:NO];
    }
}

-(void)dismissPopover{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupTouchEvent{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:tapRecognizer];
    [self.view addGestureRecognizer:swipeUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)fadeMeOut
{
    [[STAlertController instance] performSelectorOnMainThread:@selector(fadeOutNotification:) withObject:self waitUntilDone:NO];
}

- (void)close {
    if (self.didTapCloseBlock) {
        NSString *type = @"TOP";
        if(self.stAlertDisplayType == STAlertDisplayTypeOverlayNavBar)
            type = @"OVERLAY";
        if(self.stAlertDisplayType == STAlertDisplayTypeBottom)
            type = @"BOTTOM";
        if(self.stAlertDisplayType == STAlertDisplayTypeOverlayTabBar)
            type = @"OVERLAY BOTTOM";
        self.didTapCloseBlock(type);
    }
    [self fadeMeOut];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
