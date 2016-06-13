//
//  CollectionListingViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "CollectionListingTabViewController.h"
#import "EditCollectionViewController.h"
#import "CollectionViewController.h"
#import "NewCollectionViewController.h"
#import "HMSegmentedControl.h"

@class CollectionViewController;
@class CT3_CollectionViewController;
@interface CollectionListingViewController : CommonViewController <UIScrollViewDelegate>

@property(nonatomic,strong)CollectionListingTabViewController* myCollectionListingViewController;
@property(nonatomic,strong)CollectionListingTabViewController* followingCollectionListingViewController;
@property(nonatomic,strong)EditCollectionViewController* editCollectionViewController;
@property(nonatomic,strong)CollectionViewController* collectionViewController;
@property(nonatomic,strong)CT3_CollectionViewController * ct3_CollectionViewController;
@property(nonatomic,strong)NewCollectionViewController* newCollectionViewController;

-(void)setType:(ProfileViewType)type ProfileModel:(ProfileModel*)model NumberOfPage:(int)page;
-(void)setType:(ProfileViewType)type ProfileModel:(ProfileModel*)model NumberOfPage:(int)page collectionType:(CollectionListingType)collType;
-(void)setTypeSeeties:(NSString*)ID;

@end
