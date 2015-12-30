//
//  CategoryCollectionViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/3/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CategoryCollectionViewCell.h"
@interface CategoryCollectionViewCell()
@property(nonatomic,strong)CategoryModel* model;
@end

@implementation CategoryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
   // [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:self.model.defaultImageUrl] placeholderImage:nil];
   // self.ibContentView.backgroundColor = [UIColor colorWithHexValue:self.model.background_color];

    self.ibTickImageView.hidden = !self.model.isSelected;
}

-(void)initData:(CategoryModel*)model
{
    self.model = model;
}

-(void)layoutSubviews{
    self.ibContentView.layer.cornerRadius = self.ibContentView.frame.size.height / 2;

}

- (void)setBounds:(CGRect)bounds {
    
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

@end
