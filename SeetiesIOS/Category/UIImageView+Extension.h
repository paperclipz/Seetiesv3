//
//  UIImageView+Extension.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ImageBlock) (UIImage* image);

@interface UIImageView(Extra)
-(void)setImagePlaceHolder;
-(void)setStandardBorder;
-(void)sd_setImageCroppedWithURL:(NSURL *)url completed:(ImageBlock)block;

@end
