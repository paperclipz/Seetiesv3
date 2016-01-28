//
//  AddCollectionDataViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "AsyncImageView.h"
#import "UrlDataClass.h"
@interface AddCollectionDataViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
-(void)GetPostID:(NSString *)PostID GetImageData:(NSString *)ImageData;
@end
