//
//  UIImage+Extension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/29/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage(Extra)

-(UIImage*)getPlaceHolderImage
{
    return [UIImage imageNamed:@"NoImage.png"];
}
// Tint the image, default to half transparency if given an opaque colour.
- (UIImage *)imageWithTint:(UIColor *)tintColor {
    CGFloat white, alpha;
    [tintColor getWhite:&white alpha:&alpha];
    return [self imageWithTint:tintColor alpha:(alpha == 1.0 ? 0.5f : alpha)];
}

// Tint the image
- (UIImage *)imageWithTint:(UIColor *)tintColor alpha:(CGFloat)alpha {
    
    // Begin drawing
    CGRect aRect = CGRectMake(0.f, 0.f, self.size.width, self.size.height);
    UIGraphicsBeginImageContext(aRect.size);
    
    // Get the graphic context
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // Converting a UIImage to a CGImage flips the image,
    // so apply a upside-down translation
    CGContextTranslateCTM(c, 0, self.size.height);
    CGContextScaleCTM(c, 1.0, -1.0);
    
    // Draw the image
    [self drawInRect:aRect];
    
    // Set the fill color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorSpace(c, colorSpace);
    
    // Set the mask to only tint non-transparent pixels
    CGContextClipToMask(c, aRect, self.CGImage);
    
    // Set the fill color
    CGContextSetFillColorWithColor(c, [tintColor colorWithAlphaComponent:alpha].CGColor);
    
    UIRectFillUsingBlendMode(aRect, kCGBlendModeColor);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Release memory
    CGColorSpaceRelease(colorSpace);
    
    return img;
}

- (UIImage*)imageWithColorOverlay:(UIColor*)colorOverlay
{
    // create drawing context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    // draw current image
    [self drawAtPoint:CGPointZero];
    
    // determine bounding box of current image
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // get drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // flip orientation
    CGContextTranslateCTM(context, 0.0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set overlay
    CGContextSetBlendMode(context, kCGBlendModeColor);
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context, colorOverlay.CGColor);
    CGContextFillRect(context, rect);
    
    // save drawing-buffer
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end drawing context
    UIGraphicsEndImageContext();
    
    return returnImage;
}


@end
