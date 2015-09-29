//
//  EditCollectionTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditCollectionTableViewCell.h"
#import "UIImage+Tint.h"
@interface EditCollectionTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (strong, nonatomic) PostModel* postModel;
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

-(void)initData:(PostModel*)model
{
    self.postModel = model;
}

-(void)layoutSubviews
{
    [Utils setRoundBorder:self.ibContentView color:[UIColor grayColor] borderRadius:5.0f borderWidth:0.5f];
    [Utils setRoundBorder:self.ibImageView color:[UIColor grayColor] borderRadius:5.0f borderWidth:.5f];
   // [Utils setRoundBorder:self.txtDescription color:[UIColor grayColor] borderRadius:5.0f borderWidth:.5f];

    PhotoModel* pModel = self.postModel.photos[0];
    
    [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:pModel.imageURL]];
    self.lblLocation.text = self.postModel.location.name;
    self.txtDescription.text = self.postModel.collection_note;
    [self.txtDescription setEditable:YES];

}

-(void)initSelfView
{
    
    [super initSelfView];
    self.ibPhotoPin.image = [self.ibPhotoPin.image imageTintedWithColor:DEVICE_COLOR];

    self.txtDescription.placeholder = LOCALIZATION(@"Add a note");
    self.txtDescription.delegate = self;
}

-(void)saveData
{

    self.postModel.collection_note = self.txtDescription.text;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.postModel.collection_note = self.txtDescription.text;
}

@end
