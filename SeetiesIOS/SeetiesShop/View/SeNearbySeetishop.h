//
//  SeNearbySeetishop.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 01/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BtnSeetiShopBlock)(NSString * idn);

@interface SeNearbySeetishop : CommonView
@property(nonatomic,copy)VoidBlock viewDidFinishLoadBlock;
@property(nonatomic,copy)VoidBlock btnSelectSeetiShopListBlock;
@property(nonatomic,copy)BtnSeetiShopBlock btnSeetiShopClickedBlock;

-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID;
@end
