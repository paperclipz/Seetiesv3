//
//  UIImageView+Extension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView(Extra)

-(void)tintWithOverlay
{
    CAShapeLayer *shadow = [CAShapeLayer layer];
    shadow.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) cornerRadius:0].CGPath;
    shadow.position = CGPointMake(0, 0);
    shadow.fillColor = [UIColor blackColor].CGColor;
    shadow.lineWidth = 0;
    shadow.opacity = 0.3;
    [self.layer addSublayer:shadow];
}

-(void)setImagePlaceHolder
{
    self.image = [UIImage imageNamed:@"NoPhotoInCollection.png"];
    self.contentMode = UIViewContentModeCenter;
    self.backgroundColor = UIColorFromRGB(238, 238, 238, 1);
}


-(void)sd_setImageCroppedWithURL:(NSURL *)url completed:(ImageBlock)block
{
    
    [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.image = [image imageCroppedAndScaledToSize:self.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
        if (block) {
            block(self.image);
        }
    }];

}

-(void)sd_setImageCroppedWithURL:(NSURL *)url withPlaceHolder:(UIImage*)placeholderImage completed:(ImageBlock)block
{
    if (![Utils isStringNull:url.absoluteString]) {
        [self sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.image = [image imageCroppedAndScaledToSize:self.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
            if (block) {
                block(self.image);
            }
        }];
    }
    else{
        self.image = placeholderImage;
    }
   

    
}

@end
