//
//  EditPostDetailVIew.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditPostDetailVIew.h"
#import "Bostring.h"

@interface EditPostDetailVIew()

@end
@implementation EditPostDetailVIew
#define TITLE_MAX_COUNT 70
#define DESC_MAX_COUNT 140

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initSelfView
{

    self.txtDescription.delegate = self;
    self.txtTitle.delegate = self;
    
    [Utils setRoundBorder:self.txtDescription color:[Utils defaultTextColor] borderRadius:5.0f];
    [self getCounterText:self.lblTitleIndicator maxCount:TITLE_MAX_COUNT textInputCount:(int)self.txtTitle.text.length];
    [self getCounterText:self.lblDescIndicator maxCount:DESC_MAX_COUNT textInputCount:(int)self.txtDescription.text.length];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    [self getCounterText:self.lblTitleIndicator maxCount:TITLE_MAX_COUNT textInputCount:(int)textField.text.length];

    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{

    [self getCounterText:self.lblDescIndicator maxCount:DESC_MAX_COUNT textInputCount:(int)textView.text.length];

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
