//
//  InviteFriendModel.h
//  Seeties
//
//  Created by Lup Meng Poo on 04/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface InviteFriendModel : JSONModel
@property(nonatomic,strong) NSDictionary *title;
@property(nonatomic,strong) NSString *image;    //image url
@property(nonatomic,strong) NSString *expired_at;    //yyyy-MM-dd HH:mm:ss
@property(nonatomic,assign) BOOL display_expired_period;
@property(nonatomic,strong) NSDictionary *message;
@property(nonatomic,strong) NSDictionary *desc;
@property(nonnull, strong) NSString *background_image;  //background image url
@end
