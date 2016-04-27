//
//  AnnouncementModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/18/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AnnouncementModel : JSONModel

@property(nonatomic,strong)NSDictionary* title;
@property(nonatomic,strong)NSString* photo;
@property(nonatomic,strong)NSDictionary* desc;

@property(nonatomic,strong)NSString* relatedID;
@property(nonatomic,strong)NSString* userName;

@property(nonatomic,assign)AnnouncementType annType;//user post N/A url

@end
