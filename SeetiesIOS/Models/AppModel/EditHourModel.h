//
//  EditHourModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/27/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditHourModel : NSObject

@property(nonatomic,strong)NSString* fromTime;
@property(nonatomic,strong)NSString* toTime;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)NSString* day;

@end
