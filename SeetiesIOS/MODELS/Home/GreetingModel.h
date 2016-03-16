//
//  GreetingModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 3/15/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GreetingModel : JSONModel

@property(nonatomic,strong)NSString* main_msg;
@property(nonatomic,strong)NSString* sub_msg;
@property(nonatomic,strong)PhotoModel* photo;

@end
