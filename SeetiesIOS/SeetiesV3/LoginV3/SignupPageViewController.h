//
//  SignupPageViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/27/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
typedef void (^SignupBlock)(NSString* username,NSString* password,NSString* email, NSString *referralCode);

@interface SignupPageViewController : CommonViewController
@property(nonatomic,copy)SignupBlock signUpClickBlock;

@end
