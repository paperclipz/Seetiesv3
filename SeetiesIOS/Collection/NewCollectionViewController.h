//
//  NewCollectionViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
@interface NewCollectionViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>{
    
    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    IBOutlet UITextView *NameTextView;
    IBOutlet UITextView *DescriptionTextView;
    IBOutlet UITextField *TagsField;
    IBOutlet UILabel *ShowNameCount;
    IBOutlet UILabel *ShowDescriptionCount;
    
    IBOutlet UIView *SetPublicView;
    IBOutlet UIView *SetTagsView;
    
    IBOutlet UIButton *TickButton;
    IBOutlet UIButton *SaveButton;
    IBOutlet UIButton *TagsLine;
    
    NSString *SetPublic;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_CreateCollection;
    
    IBOutlet UILabel *CollectionTitle;
    IBOutlet UILabel *DescriptionTitle;
    IBOutlet UILabel *TagTitle;
    IBOutlet UILabel *SetasPublicTitle;
    IBOutlet UILabel *SubTitleSetasPublic;
}

@end
