//
//  CommonTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface CommonTableViewCell()

@property(nonatomic,weak)IBOutlet UIView *borderView;
@end
@implementation CommonTableViewCell

-(void)setCustomIndexPath
{

}

+(float)getHeight
{
    UIView *infoView = [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@",[self class]] owner:self options:nil] objectAtIndex:0];
    
    return infoView.frame.size.height;
}

- (void)awakeFromNib {
    // Initialization code
    if (self.borderView) {
        [Utils setRoundBorder:self.borderView color:OUTLINE_COLOR borderRadius:0];
    }
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    UIColor *color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.05];
    [selectedBackgroundView setBackgroundColor:color]; // set color here
    [self setSelectedBackgroundView:selectedBackgroundView];
}
@end
