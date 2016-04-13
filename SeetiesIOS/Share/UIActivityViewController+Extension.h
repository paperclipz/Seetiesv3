//
//  UIActivityViewController+Extension.h
//  SeetiesIOS
//
//  Created by Lai on 07/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomItemSource;

@interface UIActivityViewController (Extension)

+ (UIActivityViewController *)ShowShareViewControllerOnTopOf:(UIViewController*)viewController WithDataToPost:(CustomItemSource *)dataToPost;

@end
