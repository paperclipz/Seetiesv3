//
//  CTWebViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/19/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"

@interface CTWebViewController : CommonViewController
-(void)initData:(AnnouncementModel*)model;
-(void)initDataWithURL:(NSString *)url andTitle:(NSString*)title;
-(void)initDataForInstagram;

@property(nonatomic,copy)VoidBlock didFinishLoadConnectionBlock;
@end
