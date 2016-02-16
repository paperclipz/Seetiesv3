//
//  FilterCategoryCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FilterCategoryCollectionCell.h"
@interface FilterCategoryCollectionCell()
@property (weak, nonatomic) IBOutlet UIButton *ibCategoryBtn;

@end

@implementation FilterCategoryCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [self.ibCategoryBtn setSideCurveBorder];
    [self.ibCategoryBtn.layer setBorderColor:LINE_COLOR.CGColor];
}

-(void)setButtonText:(NSString *)text{
    [self.ibCategoryBtn setTitle:text forState:UIControlStateNormal];
}

- (IBAction)categoryBtnClicked:(id)sender {
    UIButton *button = (UIButton*)sender;
    [self setButtonState:button];
    button.selected = !button.selected;
}

-(void)setButtonState:(UIButton*)button{
    if (button.selected) {
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.textColor = TEXT_GRAY_COLOR;
        [self.ibCategoryBtn.layer setBorderColor:LINE_COLOR.CGColor];
    }
    else{
        button.backgroundColor = DEVICE_COLOR;
        button.titleLabel.textColor = [UIColor whiteColor];
        [self.ibCategoryBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    }
}
@end
