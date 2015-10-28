//
//  ShareViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/23/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AsyncImageView.h"
@interface ShareViewController : UIViewController<UIScrollViewDelegate,MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIButton *BackButton;
    
    IBOutlet UIView *CenterView;
    IBOutlet UIView *ShareToSeetiesView;
    
    NSString *GetPostID;
    NSString *GetMessage;
    NSString *GetTitle;
    NSString *GetImgData;
    
    AsyncImageView *imageMain;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowSubTitle;
    
    NSString *GetCollectionID;
    
    int CheckShareStatus;
    
    IBOutlet UILabel *ShowSendToFren;
    IBOutlet UILabel *ShowSendToFrenSub;
    IBOutlet UIImageView *GoToIcon;
    
    NSString *GetUserID;
}
 @property (nonatomic, strong) UIDocumentInteractionController *documentController;
-(void)GetPostID:(NSString *)ID GetMessage:(NSString *)Msg GetTitle:(NSString *)Title GetImageData:(NSString *)ImgData;
-(void)GetCollectionID:(NSString *)Collectionid;
-(void)GetShareProfile:(NSString *)Userid;
-(IBAction)FacebookButtonOnClick:(id)sender;
-(IBAction)InstagramButtonOnClick:(id)sender;
-(IBAction)LINEButtonOnClick:(id)sender;
-(IBAction)MessengerButtonOnClick:(id)sender;
-(IBAction)WhatsappButtonOnClick:(id)sender;
-(IBAction)CopyLinkButtonOnClick:(id)sender;
-(IBAction)EmailButtonOnClick:(id)sender;
@end
