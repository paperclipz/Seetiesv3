//
//  CT3_MeViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "WalletListingViewController.h"
#import "ProfileViewController.h"
#import "CollectionListingViewController.h"
#import "NotificationViewController.h"
#import "InviteFrenViewController.h"

@interface CT3_MeViewController : BaseViewController
@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic, strong)WalletListingViewController *walletListingViewController;
@property(nonatomic, strong)CollectionListingViewController *collectionListingViewController;
@property(nonatomic)NotificationViewController *notificationViewController;
@property(nonatomic)InviteFrenViewController *inviteFriendViewController;
@end
