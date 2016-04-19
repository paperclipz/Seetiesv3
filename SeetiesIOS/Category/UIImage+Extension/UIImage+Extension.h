//
//  UIImage+Extension.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/29/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Extra)
//- (UIImage *)imageWithTint:(UIColor *)tintColor;
//- (UIImage *)imageWithTint:(UIColor *)tintColor alpha:(CGFloat)alpha;
//- (UIImage*)imageWithColorOverlay:(UIColor*)colorOverlay;
-(UIImage*)getPlaceHolderImage;

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size;
@end