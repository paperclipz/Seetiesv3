//
//  SearchViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewPlaceViewController.h"
#import "UIImageView+AFNetworking.h"
#import "LPGoogleFunctions.h"

@interface STSearchViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LPGoogleFunctionsDelegate>
-(void)initTableViewDelegate:(id)delegate;
-(void)initWithLocation:(CLLocation*)location;

@property(nonatomic,strong)AddNewPlaceViewController* addNewPlaceViewController;
@end
