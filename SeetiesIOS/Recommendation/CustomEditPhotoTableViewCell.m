//
//  CustomEditPhotoTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CustomEditPhotoTableViewCell.h"
#import "Bostring.h"
#import "UITextView+Placeholder.h"

#define MAX_TEXT_COUNT 140
#define EXTRA_TEXT_COUNT 0
@interface CustomEditPhotoTableViewCell()<UIGestureRecognizerDelegate>


@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (nonatomic, weak) IBOutlet UILabel *myTextLabel;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *ibImage;

@property (weak, nonatomic) IBOutlet UIView *wrapperIconView;

@property (weak, nonatomic) IBOutlet UIView *ibContentWrapperview;
@property (weak, nonatomic) IBOutlet UILabel *lblWordCount;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@end


@implementation CustomEditPhotoTableViewCell
- (IBAction)btnDeleteClicked:(id)sender {
    
    
    if(_deleteBlock)
    {
        self.deleteBlock(self);
    }

}
- (IBAction)btnEditClicked:(id)sender {
    
    if (_editBlock) {
        self.editBlock(self);
    }
    SLog(@"btnEditClicked");
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)layoutSubviews
{
    [self reloadData];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
        
        for (id currentObject in objects ){
            if ([currentObject isKindOfClass:[self class]]) {
                
                [currentObject initSelfView];
                
                return currentObject;
            }
        }
        return nil;
        
        
    }
    return self;
}

-(void)initSelfView
{
    
    [Utils setRoundBorder:self.wrapperIconView color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f];
    [Utils setRoundBorder:self.txtDescription color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f];
    [Utils setRoundBorder:self.ibContentWrapperview color: TWO_ZERO_FOUR_COLOR borderRadius:5.0f];
    self.txtDescription.delegate = self;
    [self changeLanguage];

}

-(void)initData:(PhotoModel*)model
{
    self.model = model;
    
    
}

-(void)reloadData
{
    if (self.model.image) {
        self.ibImage.image = self.model.image;
    }
    else if(self.model.imageURL){
        
        [self.ibImage sd_setImageWithURL:[NSURL URLWithString:self.model.imageURL]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.model.image = image;
        }];
    }
    self.txtDescription.text = self.model.caption;
    [self getCounterText:self.lblWordCount maxCount:MAX_TEXT_COUNT textInputCount:(int)self.self.txtDescription.text.length];

}

//-(void)updateString:(NSString*)aText textView:(UITextView*)txtView
//{
//    
//    if(aText)
//    {
//        txtView.attributedText = [aText bos_makeString:^(BOStringMaker *make) {
//            make.foregroundColor([UIColor redColor]);
//            make.font([Utils defaultFont]);
//            
//            make.with.range(NSMakeRange(0, txtView.text.length>=MAX_TEXT_COUNT?MAX_TEXT_COUNT:txtView.text.length), ^{
//                make.foregroundColor([Utils defaultTextColor]);
//            });
//            
//        }];
//    }
//    self.lblWordCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)txtView.text.length];
//
//}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= MAX_TEXT_COUNT) {
        
        if ([text isEqualToString:@""]) {
            return YES;
            
        }
        return NO;
        
    }
    else{
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length >= MAX_TEXT_COUNT) {
        NSString *currentString = [textView.text substringWithRange:NSMakeRange(0, textView.text.length>=MAX_TEXT_COUNT?MAX_TEXT_COUNT:textView.text.length)];
        
        textView.text = currentString;
        
    }
    [self getCounterText:self.lblWordCount maxCount:MAX_TEXT_COUNT textInputCount:(int)textView.text.length];
    self.model.caption = textView.text;
    
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

-(void)changeLanguage
{
    self.txtDescription.placeholder = LocalisedString(@"Add caption");
    [self.btnEdit setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
    
}


@end
