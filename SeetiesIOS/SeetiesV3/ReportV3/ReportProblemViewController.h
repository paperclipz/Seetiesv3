//
//  ReportProblemViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 3/22/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportProblemViewController : CommonViewController
-(void)initDataReportShop:(SeShopDetailModel*)model;
-(void)initDataReportDeal:(NSString*)dealID;

@end
