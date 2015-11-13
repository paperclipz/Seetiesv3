//
//  EditCollectionTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditCollectionTableViewCell.h"
#import "UIImage+Tint.h"

#define MAX_TEXT_COUNT 150.0f
@interface EditCollectionTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (strong, nonatomic) DraftModel* postModel;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibPhotoPin;

@end
@implementation EditCollectionTableViewCell
- (IBAction)btnDeleteClicked:(id)sender {
    
    if (self.deleteCellBlock) {
        self.deleteCellBlock(self);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initData:(DraftModel*)model
{
    self.postModel = model;
}

-(void)layoutSubviews
{
    [Utils setRoundBorder:self.ibContentView color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f borderWidth:BORDER_WIDTH];
    [Utils setRoundBorder:self.ibImageView color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f borderWidth:BORDER_WIDTH];
    [Utils setRoundBorder:self.txtDescription color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f borderWidth:BORDER_WIDTH];

    PhotoModel* pModel = self.postModel.arrPhotos[0];
    
    [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:pModel.imageURL]];
    self.lblLocation.text = self.postModel.location.name;
    self.txtDescription.text = self.postModel.collection_note;
    [self.txtDescription setEditable:YES];

}

-(void)initSelfView
{
    
    [super initSelfView];
    self.ibPhotoPin.image = [self.ibPhotoPin.image imageTintedWithColor:UIColorFromRGB(153.0, 153.0, 153.0, 0.4)];

    self.txtDescription.placeholder = LOCALIZATION(@"Add a note");
    self.txtDescription.delegate = self;
}
 -(void)saveData
{

    self.postModel.collection_note = self.txtDescription.text;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length >= MAX_TEXT_COUNT) {
        NSString *currentString = [textView.text substringWithRange:NSMakeRange(0, textView.text.length>=MAX_TEXT_COUNT?MAX_TEXT_COUNT:textView.text.length)];
        textView.text = currentString;
    }
    self.postModel.collection_note = self.txtDescription.text;

}

@end
