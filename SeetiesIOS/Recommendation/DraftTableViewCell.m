//
//  DraftTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/3/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DraftTableViewCell.h"
#import "MGSwipeButton.h"


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
    
    self.lblTitle.text = [Utils stringIsNilOrEmpty:self.model.place_name]?LocalisedString(@"Untitled"):self.model.place_name;
    self.lblSubtitle.text = self.model.location.administrative_area_level_1;

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.imageURL]placeholderImage:nil options:SDWebImageProgressiveDownload];
    [Utils setRoundBorder:self.imageView color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f borderWidth:0.5f];

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

-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[1] = {@"Delete"};
    UIColor * colors[1] = {UIColorFromRGB(239, 94, 65, 1)};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (right).");
            BOOL autoHide = i != 0;
            
            if (self.didDeleteAtIndexPath) {
                self.didDeleteAtIndexPath(self);
            }
            
            return autoHide; //Don't autohide in delete button to improve delete expansion animation
        }];
        button.titleLabel.font = [UIFont fontWithName:CustomFontNameBold size:15];

        [result addObject:button];
    }
    
    return result;
}

#define BUTTON_THRESHOLD 80

-(void)initSelfView
{
    self.rightButtons = [self createRightButtons:1];
}





@end
