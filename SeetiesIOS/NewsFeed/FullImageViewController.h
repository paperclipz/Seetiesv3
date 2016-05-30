//
//  FullImageViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface FullImageViewController : UIViewController<UIScrollViewDelegate>
-(void)GetAllImageArray:(NSMutableArray *)AllImageArray GetIDN:(NSInteger)ImageIdn GetAllCaptionArray:(NSMutableArray *)AllCaptionArray;
-(void)GetImageString:(NSString *)ImageString;
-(void)GetLocalAllImageArray:(NSMutableArray *)AllImageArray GetIDN:(NSInteger)ImageIdn;
@end
