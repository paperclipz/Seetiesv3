//
//  SearchLTabViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchLTabViewController : CommonViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString* TabType;
@end
