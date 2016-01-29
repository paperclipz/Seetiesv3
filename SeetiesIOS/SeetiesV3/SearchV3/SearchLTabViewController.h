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
@property(nonatomic,strong)ProfileViewController* profileViewController;

@property(nonatomic,strong)NSString* getSearchText;
@property(nonatomic,strong)NSString* LocationName;

@property(nonatomic,strong)NSString* Getlat;
@property(nonatomic,strong)NSString* Getlong;

@property(nonatomic,strong)NSString* GetCurrentlat;
@property(nonatomic,strong)NSString* GetCurrentLong;


-(void)refreshRequest;
@end
