//
//  ProfileViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "BaseViewController.h"
#import "PcollectionTableViewController.h"

@interface ProfileViewController : BaseViewController <UIScrollViewDelegate>

@property(nonatomic,strong)PcollectionTableViewController* collectionTBLVC;
@end
