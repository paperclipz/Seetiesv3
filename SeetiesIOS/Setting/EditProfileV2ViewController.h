//
//  EditProfileV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/1/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
@interface EditProfileV2ViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>


-(void)initData:(ProfileModel*)model;
@property(nonatomic,copy)VoidBlock didCompleteUpdateUserProfileBlock;
@end
