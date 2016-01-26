//
//  LoginPageViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/26/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
typedef void (^LoginBlock)(NSString* username,NSString* password);

@interface LoginPageViewController : CommonViewController


@property(nonatomic,copy)LoginBlock btnLoginClickedBlock;
@end
