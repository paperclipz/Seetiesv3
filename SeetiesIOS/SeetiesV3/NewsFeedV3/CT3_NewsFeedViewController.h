//
//  CT3_NewsFeedViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/31/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"


@interface CT3_NewsFeedViewController : BaseViewController


@property(nonatomic,copy)VoidBlock btnLoginClickedBlock;

-(void)refreshViewAfterLogin;
-(void)scrollToTop;

@end
