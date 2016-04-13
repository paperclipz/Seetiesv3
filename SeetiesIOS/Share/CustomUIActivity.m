//
//  CustomUIActivity.m
//  SeetiesIOS
//
//  Created by Lai on 07/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CustomUIActivity.h"

@interface CustomUIActivity ()

@property (nonatomic, strong) NSArray *activityItems;

@property (nonatomic, strong) NSString *customTitle;
@property (nonatomic, strong) UIImage *customImage;
@property (nonatomic, strong) NSString *customType;
@property (nonatomic, copy) TappedAction tappedActionBlock;

@end

@implementation CustomUIActivity

- (id)initWithTitle:(NSString *)activityTitle activityImage:(UIImage *)activityImage activityType:(NSString *)activityType completionBlock:(TappedAction)completionBlock {
    
    self = [super init];
    
    if (self) {
        self.customTitle = activityTitle;
        self.customImage = activityImage;
        self.customType = activityType;
        self.tappedActionBlock = completionBlock;
    }
    
    return self;
}


# pragma mark - properties and methods

- (NSString *)activityTitle {
    
    // a title shown in the sharing menu
    return self.customTitle;
}

- (UIImage *)activityImage {
    
    // an image to go with our option
    return self.customImage;
}

- (NSString *)activityType {
    
    // a unique identifier
    return self.customType;
}

+ (UIActivityCategory)activityCategory {
    
    // which row our activity is shown in
    // top row is UIActivityCategoryShare, bottom row is UIActivityCategoryAction
    return UIActivityCategoryShare;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    
    // return YES for anything that our activity can deal with
    for (id item in activityItems) {
        
        // we can deal with strings and images
        if ([item isKindOfClass:[NSString class]] || [item isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    // for everything else, return NO
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    
    // anything we need to prepare, now's the chance
    // custom UI, long running calculations, etc
    
    // also: grab a reference to the objects our user wants to share/action
    self.activityItems = activityItems;
}

# pragma mark - Optional methods for override

- (UIViewController *)activityViewController {
    
    // return a custom UI if we need it,
    // or the standard activity view controller if we don't
    return nil;
}

- (void)performActivity {
    
    // the main thing our activity does
    // act upon each item here
    
    if (self.tappedActionBlock) {
        self.tappedActionBlock(self.activityItems);
        
        [self activityDidFinish:YES];
    }
    else {
        [self activityDidFinish:YES];
    }
    
}

@end

@implementation SeetiesUIActivity

+ (UIActivityCategory)activityCategory {
    
    // which row our activity is shown in
    // top row is UIActivityCategoryShare, bottom row is UIActivityCategoryAction
    return UIActivityCategoryAction;
}

@end
