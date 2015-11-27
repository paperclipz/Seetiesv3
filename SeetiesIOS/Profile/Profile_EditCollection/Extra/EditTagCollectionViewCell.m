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

-(void)setCustomView:(int)index
{
//    color 1 = r: 255 g: 183  b: 77
//    color 2 = r: 239 g: 83 b: 80
//    color 3 = r: 129 g: 199 b: 132
//    color 4 = r: 64 g: 196 b: 255
    UIColor* customColor;
    
    switch (index%4) {
      
        default:
        case 0:
        {
            customColor = UIColorFromRGB(255, 183, 77, 1);
        }
            break;
        case 1:
            customColor = UIColorFromRGB(239, 83, 80, 1);

            break;
        case 2:
            customColor = UIColorFromRGB(129, 199, 132, 1);

            break;
        case 3:
            customColor = UIColorFromRGB(64, 196, 255, 1);

            break;
    }
    
    [Utils setRoundBorder:self.ibContentView color:customColor borderRadius:5.0f borderWidth:1.2f];
    self.ibImagePlusView.image = [self.ibImagePlusView.image imageTintedWithColor:customColor];
    self.lblTitle.textColor = customColor;
    self.backgroundColor = [UIColor clearColor];

}

@end
