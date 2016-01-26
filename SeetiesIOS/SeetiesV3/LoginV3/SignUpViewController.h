//
//  SignUpViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/26/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
typedef void (^SignupBlock)(NSString* username,NSString* password,NSString* email);

@interface SignUpViewController : CommonViewController

@property(nonatomic,copy)SignupBlock signUpClickBlock;
@end
