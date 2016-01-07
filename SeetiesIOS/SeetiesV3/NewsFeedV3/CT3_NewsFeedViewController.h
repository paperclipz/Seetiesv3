//
//  CT3_NewsFeedViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/31/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "CT3_MeViewController.h"

@interface CT3_NewsFeedViewController : BaseViewController

@property(nonatomic,strong)CT3_MeViewController* meViewController;
@property(nonatomic,copy)VoidBlock btnLoginClickedBlock;

-(void)refreshViewAfterLogin;

@end
