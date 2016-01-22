//
//  ConnectionsTabViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 14/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectUserRowBlock)(NSString *userid);
@interface ConnectionsTabViewController : CommonViewController <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)DidSelectUserRowBlock didSelectUserRowBlock;

@property(nonatomic,strong)NSString* TabType;
@property(nonatomic,strong)NSString* userID;
-(void)reloadView;
-(void)refreshRequest;
@end
