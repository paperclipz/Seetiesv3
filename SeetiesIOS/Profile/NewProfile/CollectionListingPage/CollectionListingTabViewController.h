//
//  CollectionListingTabViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"

typedef void (^DidSelectCollectionRowBlock)(CollectionModel* model);
@interface CollectionListingTabViewController : CommonViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy)DidSelectCollectionRowBlock didSelectEdiCollectionRowBlock;
@property(nonatomic,copy)DidSelectCollectionRowBlock didSelectDisplayCollectionRowBlock;

@property(nonatomic,assign)ProfileViewType profileType;
@property(nonatomic,assign)CollectionListingType collectionListingType;


@property(nonatomic,strong)NSString* userID;
-(void)reloadView;
-(void)refreshRequest;

@end
