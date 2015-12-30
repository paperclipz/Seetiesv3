//
//  SearchTableViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/26/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SearchTableViewController : UITableViewController
-(void)initTableViewWithDelegate:(id)delegate;
@property(nonatomic,assign)SearchType type;
@end
