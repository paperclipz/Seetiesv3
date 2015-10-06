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
@property(nonatomic,strong)RecommendationModel* recModel;
@end
@implementation EditPostDetailVIew
#define TITLE_MAX_COUNT 70
#define DESC_MAX_COUNT 800

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
    
    [self.txtTitle addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    [Utils setRoundBorder:self.txtDescription color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f];
    [self getCounterText:self.lblTitleIndicator maxCount:TITLE_MAX_COUNT textInputCount:(int)self.txtTitle.text.length];
    [self getCounterText:self.lblDescIndicator maxCount:DESC_MAX_COUNT textInputCount:(int)self.txtDescription.text.length];
    CGFloat yourSelectedFontSize = 15.0 ;
    UIFont *yourNewSameStyleFont = [self.txtTitle.font fontWithSize:yourSelectedFontSize];
    self.txtTitle.font = yourNewSameStyleFont ;
    [self.txtDescription setFont:yourNewSameStyleFont];
    
    [self changeLanguage];
}

-(void)changeLanguage
{
    self.labelTitle.text = LocalisedString(@"Title (Optional)");
    self.labelDescription.text = LocalisedString(@"Share your thoughts");
}

-(void)initData:(RecommendationModel*)model viewNo:(int)counter
{
    self.recModel = model;
    
    self.txtTitle.text = counter==1?self.recModel.postMainTitle:self.recModel.postSecondTitle;
    self.txtDescription.text = counter==1?self.recModel.postMainDescription:self.recModel.postSecondDescription;
    
    [self getCounterText:self.lblTitleIndicator maxCount:TITLE_MAX_COUNT textInputCount:(int)self.txtTitle.text.length];
    [self getCounterText:self.lblDescIndicator maxCount:DESC_MAX_COUNT textInputCount:(int)self.txtDescription.text.length];

}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    SLog(@"count = %lu",textField.text.length);
//    NSString *currentString = [textField.text substringWithRange:NSMakeRange(0, textField.text.length>=TITLE_MAX_COUNT?TITLE_MAX_COUNT:textField.text.length)];
//
//    textField.text = currentString;
//    [self getCounterText:self.lblTitleIndicator maxCount:TITLE_MAX_COUNT textInputCount:(int)textField.text.length];
//
//    return YES;
//}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (textField.text.length >= TITLE_MAX_COUNT) {
        if ([string isEqualToString:@""]) {
            return YES;
            
        }
        return NO;
    }
    else{
        return YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= DESC_MAX_COUNT) {
        
        if ([text isEqualToString:@""]) {
            return YES;

        }
        return NO;

    }
    else{
        return YES;
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField.text.length>=TITLE_MAX_COUNT) {
    
        NSString *currentString = [textField.text substringWithRange:NSMakeRange(0, textField.text.length>=TITLE_MAX_COUNT?TITLE_MAX_COUNT:textField.text.length)];
    
        textField.text = currentString;
    }
  
    
    [self getCounterText:self.lblTitleIndicator maxCount:TITLE_MAX_COUNT textInputCount:(int)textField.text.length];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
   
    if (textView.text.length >= DESC_MAX_COUNT) {
        NSString *currentString = [textView.text substringWithRange:NSMakeRange(0, textView.text.length>=DESC_MAX_COUNT?DESC_MAX_COUNT:textView.text.length)];
        
        textView.text = currentString;

    }
    [self getCounterText:self.lblDescIndicator maxCount:DESC_MAX_COUNT textInputCount:(int)textView.text.length];

}


-(void)getCounterText:(UILabel*)label  maxCount:(int)maxCount textInputCount:(int)txtCount
{
    if (txtCount>maxCount) {
        
        label.textColor = [UIColor redColor];
    }
    else{
    
        label.textColor = [Utils defaultTextColor];
        
    }
    
    label.text = [NSString stringWithFormat:@"%d/%d",txtCount,maxCount];

}


@end
