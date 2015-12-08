//
//  SeShopDetailView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonView.h"
typedef void (^RectBlock)(UIView* fromView, CGRect subRect);
typedef void (^BtnMoreInfoBlock)(SeShopDetailModel* model);


@interface SeShopDetailView : CommonView
-(BOOL)isAvailable;
@property(nonatomic,copy)VoidBlock btnMapClickedBlock;
@property (nonatomic,copy)ImageBlock imageDidFinishLoadBlock;
@property (nonatomic,copy)RectBlock didSelectInformationAtRectBlock;
@property (nonatomic,copy)IndexPathBlock didSelectPhotoAtIndexPath;


@property(nonatomic,copy)VoidBlock viewDidFinishLoadBlock;
@property(nonatomic,copy)BtnMoreInfoBlock btnMoreInfoClickedBlock;
-(void)initData;
@end
