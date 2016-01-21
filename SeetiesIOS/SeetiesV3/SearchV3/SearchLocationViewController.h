//
//  SearchLocationViewController.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 19/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchLocationAreaCell.h"
#import "SearchManager.h"
#import "SearchModel.h"

@interface SearchLocationViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, copy)VoidBlock refreshLocation;
@end
