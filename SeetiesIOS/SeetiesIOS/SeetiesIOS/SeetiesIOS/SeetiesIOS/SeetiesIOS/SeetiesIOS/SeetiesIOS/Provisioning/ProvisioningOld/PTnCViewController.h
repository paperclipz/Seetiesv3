//
//  PTnCViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/20/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
@interface PTnCViewController : GAITrackedViewController{
    
    NSString *GetLoginID;
    NSString *GetPassword;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSString *CheckFBLogin;

}
-(IBAction)AcceptAndContinueButton:(id)sender;
-(void)GetFBLogin:(NSString *)Check;
-(void)SendLoginDataToServer;
@end
