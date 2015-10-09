//
//  TextFieldValidator.h
//  Textfield Validation Handler
//
//  Created by Dhawal Dawar on 10/06/2014.
//  Copyright (c) 2014 Dhawal Dawar. All rights reserved.
//
#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"
#import <UIKit/UIKit.h>

/**
    Image name for showing error on textfield.
 */
#define IconImageName @"ErrorIcon.png"

/**
    Background color of message popup.
 */
#define ColorPopUpBg [UIColor colorWithRed:0.702 green:0.000 blue:0.000 alpha:1.000]

/**
    Font color of the message.
 */
#define ColorFont [UIColor whiteColor]

/**
    Font size of the message.
 */
#define FontSize 13

/**
    Font style name of the message.
 */
#define FontName @"ProximaNovaSoft-Regular"

/**
    Padding in pixels for the popup.
 */
#define PaddingInErrorPopUp 5

/**
    Default message for validating length, you can also assign message separately using method 'updateLengthValidationMsg:' for textfields.
 */
#define MsgValidateLength @"This field cannot be blank"


/**
    TextFieldValidator is the inherited class of UITextField for performing validation effectively. This class will handle all kind of validations with just few lines of code using regex and it is fully customisable. You can easily port this functionality in your existing code as well, you just need to change class name from UITextField to TextFieldValidator and apply regex for performing validation.
 */
NS_CLASS_AVAILABLE_IOS(6_0) @interface TextFieldValidator : UITextField<UITextFieldDelegate>{

}

@property (nonatomic,assign) BOOL isMandatory;   /**< Default is YES*/

@property (nonatomic,retain) IBOutlet UIView *presentInView;    /**< Assign view on which you want to show popup and it would be good if you provide controller's view*/

@property (nonatomic,retain) UIColor *popUpColor;   /**< Assign popup background color, you can also assign default popup color from macro "ColorPopUpBg" at the top*/

@property (nonatomic,assign) BOOL validateOnCharacterChanged; /**< Default is YES, Use it whether you want to validate text on character change or not.*/

@property (nonatomic,assign) BOOL validateOnResign; /**< Default is YES, Use it whether you want to validate text on resign or not.*/

/**
    Use to add regex for validating textfield text, you need to specify all your regex in queue that you want to validate and their messages respectively that will show when any regex validation will fail.
    @param strRegx Regex string
    @param msg Message string to be displayed when given regex will fail.
 */
-(void)addRegx:(NSString *)strRegx withMsg:(NSString *)msg;

/**
    By deafult the message will be shown which is given in the macro "MsgValidateLength", but you can change message for each textfield as well.
    @param msg Message string to be displayed when length validation will fail.
 */
-(void)updateLengthValidationMsg:(NSString *)msg;

/**
    Use to add validation for validating confirm password
    @param txtPassword Hold reference of password textfield from which they will check text equality.
 */
-(void)addConfirmValidationTo:(TextFieldValidator *)txtPassword withMsg:(NSString *)msg;

/**
    Use to perform validation
    @return Bool It will return YES if all provided regex validation will pass else return NO
 
    Eg: If you want to apply validation on all fields simultaneously then refer below code which will be make it easy to handle validations
    if([txtField1 validate] & [txtField2 validate]){
        // Success operation
    }
 */
-(BOOL)validate;

/**
    Use to dismiss error popup.
 */
-(void)dismissPopup;

@end