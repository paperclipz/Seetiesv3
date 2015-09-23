//
//  EditCollectionDetailViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/23/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditCollectionDetailViewController.h"
#import "Bostring.h"

#define TITLE_MAX_COUNT 70
#define EXTRA_TEXT_COUNT 20


@interface EditCollectionDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblWordCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblWordCountDesc;

@end

@implementation EditCollectionDetailViewController
- (IBAction)btnDoneClicked:(id)sender {
}
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    [self getCounterText:self.lblWordCountTitle maxCount:TITLE_MAX_COUNT textInputCount:(int)textField.text.length];
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    //[self getCounterText:self.lblWordCountDesc maxCount:DESC_MAX_COUNT textInputCount:(int)textView.text.length];
    
}

-(void)getCounterText:(UILabel*)label  maxCount:(int)maxCount textInputCount:(int)txtCount
{
    if (txtCount>=maxCount) {
        
        label.textColor = [UIColor redColor];
    }
    else{
        
        label.textColor = [Utils defaultTextColor];
        
    }
    
    label.text = [NSString stringWithFormat:@"%d/%d",txtCount,maxCount];
    
}


@end
