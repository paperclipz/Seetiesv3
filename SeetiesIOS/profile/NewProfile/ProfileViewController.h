//
//  ProfileViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "BaseViewController.h"
#import "TLTagsControl.h"
#import "CollectionViewController.h"
#import "CollectionListingViewController.h"

@interface ProfileViewController : BaseViewController<TLTagsControlDelegate>


@property(nonatomic,strong)CollectionViewController* collectionViewController;
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
//@property(nonatomic,strong)UINavigationController* navCollectionListingViewController;

@end
