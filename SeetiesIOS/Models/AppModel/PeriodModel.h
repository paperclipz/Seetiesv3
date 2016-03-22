//
//  PeriodModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 22/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeriodModel : NSObject
@property(nonatomic) NSString *open;    //UTC - HHmm
@property(nonatomic) NSString *close;   //UTC - HHmm
@property(nonatomic) NSString *formatted12HourOpen;    //Timezone based - hh:mm aa
@property(nonatomic) NSString *formatted12HourClose;    //Timezone based - hh:mm aa
@end
