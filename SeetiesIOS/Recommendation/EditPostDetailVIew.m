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
    
    [Utils setRoundBorder:self.txtDescription color:[Utils defaultTextColor] borderRadius:5.0f];
    [self getCounterText:self.lblTitleIndicator maxCount:TITLE_MAX_COUNT textInputCount:(int)self.txtTitle.text.length];
    [self getCounterText:self.lblDescIndicator maxCount:DESC_MAX_COUNT textInputCount:(int)self.txtDescription.text.length];

    
    self.labelTitle.text = LOCALIZATION(@"Title");
    self.labelDescription.text = LOCALIZATION(@"Write your experience");
    
    CGFloat yourSelectedFontSize = 15.0 ;
    UIFont *yourNewSameStyleFont = [self.txtTitle.font fontWithSize:yourSelectedFontSize];
    self.txtTitle.font = yourNewSameStyleFont ;
    [self.txtDescription setFont:yourNewSameStyleFont];
    
}

-(void)initData:(RecommendationModel*)model viewNo:(int)counter
{
    self.recModel = model;
    
    self.txtTitle.text = counter==1?self.recModel.postMainTitle:self.recModel.postSecondTitle;
    self.txtDescription.text = counter==1?self.recModel.postMainDescription:self.recModel.postSecondDescription;
    
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
    if (txtCount>maxCount) {
        
        label.textColor = [UIColor redColor];
    }
    else{
    
        label.textColor = [Utils defaultTextColor];
        
    }
    
    label.text = [NSString stringWithFormat:@"%d/%d",txtCount,maxCount];

}


@end
