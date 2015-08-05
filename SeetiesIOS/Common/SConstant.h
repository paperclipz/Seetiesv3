//
//  SConstant.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/3/15.
//

#import <Foundation/Foundation.h>

@interface SConstant : NSObject
typedef enum
{
    ServerRequestTypeLogin = 1,
    ServerRequestTypeNewsFeed = 2
    
}ServerRequestType;

typedef enum
{
    ViewTypeNewsFeed = 1,
    ViewTypeExplore = 2,
    ViewTypeNitification = 3,
    ViewTypeExploreProfile
    
}ViewType;


extern NSString *const SERVER_PATH;
extern NSString *const IP_URL_PATH;

@end
