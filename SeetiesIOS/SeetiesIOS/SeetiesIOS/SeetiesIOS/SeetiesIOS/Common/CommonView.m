//
//  CommonView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/20/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonView.h"

@implementation CommonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSelfView];
        
        NSLog(@"initWithFrame");
    }
    return self;
}

+ (id)initializeCustomView
{
    NSString* viewName;
    
    viewName = NSStringFromClass([self class]);
    
    //    NSLog(@"name == %@",viewName);
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:viewName owner:nil options:nil];
    
    for (id currentObject in objects ){
        if ([currentObject isKindOfClass:[self class]])
            // NSLog(@"Nib View Added To [%@]", NSStringFromClass([self class]));
            
            [currentObject initSelfView];
        return currentObject;
    }
    //  NSLog(@"Nib View NOT Added To [%@]", NSStringFromClass([self class]));
    
    return nil;
}

-(void)initSelfView
{

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
