//
//  SearchLTabViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
typedef void (^DidSelectUserRowBlock)(NSString *userid);
typedef void (^DidSelectCollectionRowBlock)(CollectionModel* model);
typedef void (^DidSelectPostsRowBlock)(NSString *postid);
typedef void (^DidSelectCollectionOpenViewBlock)(DraftModel* model);
@interface SearchLTabViewController : CommonViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy)DidSelectUserRowBlock didSelectUserRowBlock;
@property(nonatomic,copy)DidSelectPostsRowBlock didSelectPostsRowBlock;
@property(nonatomic,copy)DidSelectCollectionRowBlock didSelectDisplayCollectionRowBlock;
@property(nonatomic,copy)DidSelectCollectionOpenViewBlock didSelectCollectionOpenViewBlock;
@property(nonatomic,assign)SearchListingType searchListingType;

-(void)refreshRequestWithGoogleDetail:(NSString*)keyword  googleDetails:(SearchLocationDetailModel*)googleDetailModel;
-(void)refreshRequestWithCoordinate:(NSString*)keyword Latitude:(NSString*)latitude Longtitude:(NSString*)longtitude;

-(void)refreshRequestShop:(NSString*)keyword SeetieshopPlaceID:(NSString*)placeID;

-(void)refreshRequestWithText:(NSString*)keyword;

@end
