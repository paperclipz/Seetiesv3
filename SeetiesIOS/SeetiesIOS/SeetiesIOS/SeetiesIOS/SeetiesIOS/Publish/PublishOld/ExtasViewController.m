//
//  ExtasViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/28/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "ExtasViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
@interface ExtasViewController ()

@end

@implementation ExtasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    tagField.tagDelegate        = self;
//    tagField.delegate = self;
//    tagField.backgroundColor = [UIColor clearColor];
    TagArray = [[NSMutableArray alloc]init];
    ShowTagText.hidden = NO;
    LinkField.delegate = self;
    [ShareFB setOn:NO];
    
    
    [DoneButton setTitle:CustomLocalisedString(@"Done", nil) forState:UIControlStateNormal];
    ShowTitle.text = CustomLocalisedString(@"Extras", nil);
    TagsText.text = CustomLocalisedString(@"Tags", nil);
    TagsDetail.text = CustomLocalisedString(@"TagsDetail", nil);
    URLText.text = CustomLocalisedString(@"URL", nil);
    AlsoShareTo.text = CustomLocalisedString(@"AlsoShareto", nil);
  //  tagField.tags = @[@"Tag1", @"Tag2", @"Tag3"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Publish Extras Page";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetTagString = [defaults objectForKey:@"Extras_Tag"];
    NSLog(@"GetTagString is %@",GetTagString);
    if ([GetTagString length] == 0) {
        
    }else{
        NSArray *SplitArray = [GetTagString componentsSeparatedByString: @","];
        NSMutableArray *TampArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [SplitArray count]; i++) {
            NSString *TampString = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
            [TampArray addObject:TampString];
        }
        NSString *TestString = [TampArray componentsJoinedByString:@" "];
        NSLog(@"TestString is %@",TestString);
        
        // NSString *FinalShowString = [[NSString alloc]initWithFormat:@"@[%@]",TestString];
      //  tagField.tags = TampArray;
        [TagArray addObjectsFromArray:TampArray];
        ShowTagText.hidden = YES;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
 //   [tagField resignFirstResponder];
    [LinkField resignFirstResponder];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
//#pragma mark - SMTagField delegate
//-(void)tagField:(SMTagField *)_tagField tagAdded:(NSString *)tag{
//   // log.text                = [log.text stringByAppendingFormat:@"\nTag Added: %@", tag];
//   // [log scrollRangeToVisible: NSMakeRange(log.text.length - 1, 1)];
//    [TagArray addObject:tag];
//}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [tagField resignFirstResponder];
//    [LinkField resignFirstResponder];
//}
//-(BOOL) textFieldShouldReturn:(UITextField *)textField{
//    
//    [textField resignFirstResponder];
//    return YES;
//}
//-(void)tagField:(SMTagField *)_tagField tagRemoved:(NSString *)tag{
//    //log.text                = [log.text stringByAppendingFormat:@"\nTag Removed: %@", tag];
//   // [log scrollRangeToVisible: NSMakeRange(log.text.length - 1, 1)];
//    [TagArray removeObject:tag];
//}
//
//-(BOOL)tagField:(SMTagField *)_tagField shouldAddTag:(NSString *)tag{
//    // Limits to a maximum of 5 tags and doesn't allow to add a tag called "cat"
//    if(_tagField.tags.count >= 20 ||
//       [[tag lowercaseString] isEqualToString: @"cat"])
//        return NO;
//    
//    return YES;
//}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"did begin editing");
    ShowTagText.hidden = YES;
}
-(IBAction)onOffSwitch:(id)sender{
    
    if(ShareFB.on) {
        // lights on
        NSLog(@"Share FB On");
    }else {
        // lights off
        NSLog(@"Share FB Off");
    }
    
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)DoneButton:(id)sender{
    if ([LinkField.text length] == 0) {
        LinkField.text = @"";
    }
    NSString *TagString = [TagArray componentsJoinedByString:@","];
    if ([TagString length] == 0) {
        TagString = @"";
    }
    NSString *ShareFbCheck;
    if (ShareFB.on) {
        ShareFbCheck = @"Share";
    }else{
        ShareFbCheck = @"No Share";
    }
    
    NSLog(@"TagString is %@",TagString);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:LinkField.text forKey:@"Extras_Link"];
    [defaults setObject:TagString forKey:@"Extras_Tag"];
    [defaults setObject:ShareFbCheck forKey:@"Extras_ShareFB"];
    [defaults synchronize];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];

}
@end
