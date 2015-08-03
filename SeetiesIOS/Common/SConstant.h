//
//  SConstant.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SConstant : NSObject
typedef enum
{
    ServerRequestTypeLogin = 1,
    ServerRequestTypeNewsFeed = 2
    
}ServerRequestType;
extern NSString *const SERVER_PATH;

@end
