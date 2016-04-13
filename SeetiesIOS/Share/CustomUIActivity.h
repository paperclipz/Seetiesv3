//
//  CustomUIActivity.h
//  SeetiesIOS
//
//  Created by Lai on 07/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TappedAction)(id);

@interface CustomUIActivity : UIActivity

- (id)initWithTitle:(NSString *)activityTitle activityImage:(UIImage *)activityImage activityType:(NSString *)activityType completionBlock:(TappedAction)completionBlock;

@end

@interface SeetiesUIActivity : CustomUIActivity


@end