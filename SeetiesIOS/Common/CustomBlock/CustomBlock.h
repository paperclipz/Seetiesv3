//
//  CustomBlock.h
//  SeetiesIOS
//
//  Created by Evan Beh on 14/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#ifndef CustomBlock_h
#define CustomBlock_h

#import "ProfileModel.h"
typedef void (^ProfileModelBlock)(ProfileModel *model);
typedef void (^NotificationModelBlock)(NotificationModel *model);
typedef void (^DealModelBlock)(DealModel *model);


#endif /* CustomBlock_h */
