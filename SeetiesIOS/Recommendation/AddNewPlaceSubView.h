//
//  AddNewPlaceSubView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/20/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"


@interface NSArray (Blocks)

@end

@interface AddNewPlaceSubView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtPlaceName;
@property (strong, nonatomic) IBOutlet TextFieldValidator *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtURL;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNo;
+ (id)initializeCustomView;
@property (weak, nonatomic) IBOutlet BKCurrencyTextField *txtPerPax;
@property (weak, nonatomic) IBOutlet UIButton *btnCurrency;
@property (weak, nonatomic) IBOutlet UIButton *btnEditHours;

@property(nonatomic,copy)ButtonBlock btnEditHourClickedBlock;
-(BOOL)validation;

@end
