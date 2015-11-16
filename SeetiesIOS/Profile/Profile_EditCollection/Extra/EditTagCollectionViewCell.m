//
//  EditTagCollectionViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/25/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditTagCollectionViewCell.h"
#import "UIImage+Tint.h"

@interface EditTagCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImagePlusView;
@end
@implementation EditTagCollectionViewCell

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
    [Utils setRoundBorder:self.ibContentView color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f borderWidth:1.0f];
    
    self.ibImagePlusView.image = [self.ibImagePlusView.image imageTintedWithColor:TWO_ZERO_FOUR_COLOR];
}
@end
