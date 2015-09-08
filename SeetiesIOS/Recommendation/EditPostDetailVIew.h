//
//  EditPostDetailVIew.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AUIAutoGrowingTextView.h"


@interface EditPostDetailVIew : CommonView <UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet AUIAutoGrowingTextView *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblDescIndicator;

@end
