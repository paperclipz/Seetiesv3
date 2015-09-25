//
//  NewCollectionViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
@interface NewCollectionViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>

-(void)initData:(PostModel*)model;


@end
