//
//  DraftTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/3/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DraftTableViewCell.h"


@interface DraftTableViewCell()
@property(nonatomic,strong)DraftModel* model;
@end

@implementation DraftTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)layoutSubviews
{
    PhotoModel* photoModel;
    Post* postModel;
    
    if (self.model.arrPost.count>0) {
        postModel = self.model.arrPost[0];
    }
    if (self.model.arrPhotos.count>0) {
        photoModel = self.model.arrPhotos[0];
    }
    
    self.lblTitle.text = self.model.place_name;
    self.lblSubtitle.text = self.model.place_name;

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.imageURL]placeholderImage:nil options:SDWebImageProgressiveDownload];

}

-(void)initData:(DraftModel*)model
{
    self.model = model;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
    
}




@end
