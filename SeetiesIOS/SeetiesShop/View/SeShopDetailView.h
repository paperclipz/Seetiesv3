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
typedef void (^BtnMorePhotosBlock)(SeShopPhotoModel* model);

typedef void (^DealModelBlock)(DealModel* model);

@interface SeShopDetailView : CommonView
-(BOOL)isAvailable;
@property(nonatomic,copy)BtnMoreInfoBlock btnMapClickedBlock;
@property (nonatomic,copy)ImageBlock imageDidFinishLoadBlock;
@property (nonatomic,copy)RectBlock didSelectInformationAtRectBlock;
@property (nonatomic,copy)IndexPathBlock didSelectPhotoAtIndexPath;

@property(nonatomic,copy)BtnMoreInfoBlock viewDidFinishLoadBlock;
@property(nonatomic,copy)BtnMoreInfoBlock btnMoreInfoClickedBlock;
@property(nonatomic,copy)BtnMorePhotosBlock didSelectMorePhotosBlock;

@property(nonatomic,copy)DealModelBlock didSelectDealBlock;
@property(nonatomic,copy)VoidBlock didSelectDealSeeAllBlock;

-(void)initData:(NSString*)seetiesID PlaceID:(NSString*)placeID PostID:(NSString*)postID;
-(void)getTranslation;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@end
