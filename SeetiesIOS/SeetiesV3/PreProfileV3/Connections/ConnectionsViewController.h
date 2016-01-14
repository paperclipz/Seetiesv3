//
//  ConnectionsViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 14/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "ConnectionsTabViewController.h"
@interface ConnectionsViewController : CommonViewController
@property(nonatomic,strong)ConnectionsTabViewController *FollowerConnectionsTabViewController;
@property(nonatomic,strong)ConnectionsTabViewController *FollowingConnectionsTabViewController;
@end
