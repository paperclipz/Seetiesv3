//
//  SubmitProfileViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 1/8/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "LLARingSpinnerView.h"
@interface SubmitProfileViewController : GAITrackedViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

-(void)GetType:(NSString *)Type;
@end
