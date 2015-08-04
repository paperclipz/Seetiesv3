//
//  InstagramLoginWebViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/13/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramLoginWebViewController : UIViewController<UIWebViewDelegate>{

    IBOutlet UIWebView *MainWebView;
    IBOutlet UIImageView *BarImage;
    NSString *client_id;
    NSString *secret;
    NSString *callback;
    
    NSMutableData *receivedData;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
}
-(IBAction)backButton:(id)sender;
@end
