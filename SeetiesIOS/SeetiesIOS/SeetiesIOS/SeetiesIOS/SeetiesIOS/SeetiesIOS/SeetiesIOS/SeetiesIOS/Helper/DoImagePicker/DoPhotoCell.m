//
//  DoPhotoCell.m
//  DoImagePickerController
//
//  Created by Donobono on 2014. 1. 23..
//

#import "DoPhotoCell.h"

@implementation DoPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define UIColorWITHRGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0f blue:B/255.0f alpha:1].CGColor;
- (void)setSelectMode:(BOOL)bSelect
{
    _ivPhoto.layer.borderWidth = 3.0f;

    if (bSelect)
    {
        _ivPhoto.layer.borderColor = UIColorWITHRGB(52, 179, 253);

    }
    else
    {
        _ivPhoto.layer.borderColor = [UIColor clearColor].CGColor;

    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
