//
//  SeCollectionView.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 01/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BtnCollectionDetailBlock)(NSString * idn);
typedef void (^BtnCollectionSeeAllBlock)(NSString * SeetiShopIDN);

@interface SeCollectionView : CommonView
@property(nonatomic,copy)BoolBlock viewDidFinishLoadBlock;
-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID;
@property(nonatomic,copy)BtnCollectionDetailBlock btnCollectionDetailClickedBlock;
@property(nonatomic,copy)BtnCollectionSeeAllBlock btnCollectionSeeAllClickedBlock;
@end
