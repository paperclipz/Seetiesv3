//
//  SearchLTabViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
typedef void (^DidSelectIDBlock)(NSString *userid);
typedef void (^DidSelectCollectionBlock)(CollectionModel* model);
typedef void (^DidSelectDraftBlock)(DraftModel* model);
typedef void (^DidSelectShopBlock)(SeShopDetailModel* model);
typedef void (^DealBlock)(DealModel* model);

@interface SearchLTabViewController : CommonViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property(nonatomic,copy)DidSelectIDBlock didSelectUserRowBlock;
@property(nonatomic,copy)DidSelectIDBlock didSelectPostsRowBlock;
@property(nonatomic,copy)DidSelectShopBlock didSelectShopBlock;
@property(nonatomic,copy)DidSelectCollectionBlock didSelectDisplayCollectionRowBlock;
@property(nonatomic,copy)DidSelectCollectionBlock didSelectEditDisplayCollectionRowBlock;
@property(nonatomic,copy)DealBlock didSelectDealBlock;
@property(nonatomic,copy)VoidBlock viewDidFinishLoadBlock;

@property(nonatomic,copy)DidSelectDraftBlock didSelectCollectionOpenViewBlock;
@property(nonatomic,assign)SearchListingType searchListingType;

-(void)refreshRequestWithGoogleDetail:(NSString*)keyword  googleDetails:(SearchLocationDetailModel*)googleDetailModel;
-(void)refreshRequestWithModel:(HomeLocationModel*)model Keyword:(NSString*)keyword;
-(void)refreshRequestShop:(NSString*)keyword SeetieshopPlaceID:(NSString*)placeID;
-(void)refreshRequestWithText:(NSString*)keyword;
-(void)refreshRequestWithHomeLocation:(HomeLocationModel*)model filterDictionary:(NSDictionary*)filterDict;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constFilterHeight;

@end
