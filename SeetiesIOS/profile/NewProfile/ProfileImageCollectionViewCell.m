//
//  ProfileImageCollectionViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/13/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileImageCollectionViewCell.h"

@implementation ProfileImageCollectionViewCell

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
  
}
@end
