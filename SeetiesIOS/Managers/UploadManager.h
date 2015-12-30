//
//  UploadManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/5/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatingIndicatorView.h"

@interface UploadManager : NSObject
+ (id)Instance;

@property(nonatomic,strong)FloatingIndicatorView* floatView;
@end
