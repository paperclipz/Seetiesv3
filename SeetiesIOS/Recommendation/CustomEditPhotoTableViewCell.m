//
//  CustomEditPhotoTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CustomEditPhotoTableViewCell.h"


@interface CustomEditPhotoTableViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (nonatomic, weak) IBOutlet UILabel *myTextLabel;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *ibImage;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (weak, nonatomic) IBOutlet UIView *wrapperIconView;


@end


@implementation CustomEditPhotoTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
  
    
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
   // [Utils setRoundBorder:self.wrapperContentView color:[UIColor darkGrayColor]borderRadius:10.0];
    [Utils setRoundBorder:self.wrapperIconView color:[UIColor darkGrayColor]borderRadius:5.0f];

}

-(void)initData:(UIImage*)image description:(NSString*)desc
{
    self.txtDescription.text = desc;
    self.ibImage.image = image;
    
}

- (void)userPressedMoreButton:(id)sender
{
    NSLog(@"child more");
    if(_moreBlock)
    {
        self.moreBlock(nil);
    }
}

- (void)userPressedDeleteButton:(id)sender
{
    
    if(_deleteBlock)
    {
        self.deleteBlock(nil);
    }
    NSLog(@"child delete");
}





@end
