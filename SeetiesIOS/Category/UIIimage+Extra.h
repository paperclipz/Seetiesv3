//
//  UIIimage+Extra.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/17/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIImage (Extras)
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size;
@end;
