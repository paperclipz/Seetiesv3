//
//  EditCollectionTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditCollectionTableViewCell.h"
@interface EditCollectionTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (strong, nonatomic) CollectionModel* collectionModel;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIView *ibContentView;

@end
@implementation EditCollectionTableViewCell
- (IBAction)btnDeleteClicked:(id)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initData:(CollectionModel*)model
{
    self.collectionModel = model;
}

-(void)layoutSubviews
{
    
    [Utils setRoundBorder:self.ibContentView color:[UIColor grayColor] borderRadius:5.0f borderWidth:0.5f];
    [Utils setRoundBorder:self.ibImageView color:[UIColor grayColor] borderRadius:5.0f borderWidth:.5f];
    [Utils setRoundBorder:self.txtDescription color:[UIColor grayColor] borderRadius:5.0f borderWidth:.5f];

    PhotoModel* pModel = self.collectionModel.photos[0];
    
    [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:pModel.imageURL]];
    self.lblLocation.text = self.collectionModel.location.name;
    self.txtDescription.text = self.collectionModel.collection_note;

}

@end
