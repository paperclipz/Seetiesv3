//
//  MessageManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/27/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageManager : NSObject
+(void)showMessage:(NSString*)title SubTitle:(NSString*)subtitle Type:(TSMessageNotificationType)type;

@end
