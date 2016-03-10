//
//  CT3_SearchListingViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchLTabViewController.h"
#import "ProfileViewController.h"
#import "CollectionViewController.h"
#import "FeedV2DetailViewController.h"
@class CollectionViewController;
@class SearchLTabViewController;

@interface CT3_SearchListingViewController : CommonViewController

/*any search also need location as default*/
@property(nonatomic,strong)NSString* keyword;
@property(nonatomic,strong)NSString* locationName;
@property(nonatomic,strong)NSString* locationLatitude;
@property(nonatomic,strong)NSString* locationLongtitude;
@property(nonatomic,strong)NSString* placeID;
@property(nonatomic,strong)NSDictionary* addressComponent;

-(void)initData:(HomeLocationModel*) model;

@end
