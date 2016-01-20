//
//  AnnounceViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 12/10/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface AnnounceViewController : UIViewController<UIScrollViewDelegate>
-(void)GetDisplayImage:(NSString *)ImageData GetContent:(NSString *)content;

/*new implementation using annoucement model 19/jan/2016*/
-(void)initData:(CTFeedTypeModel*)model;
@end
