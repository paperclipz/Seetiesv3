//
//  DoAlbumCell.m
//  DoImagePickerController
//
//  Created by Donobono on 2014. 1. 23..
//

#import "DoAlbumCell.h"
#import "DoImagePickerController.h"

@implementation DoAlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected)
    {
        _lbAlbumName.textColor  = [UIColor whiteColor];
        _lbCount.textColor      = [UIColor whiteColor];
        
        //self.contentView.backgroundColor = DO_ALBUM_NAME_TEXT_COLOR;
    }
    else
    {
        _lbAlbumName.textColor  = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0];
        _lbCount.textColor      = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
