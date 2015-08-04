//
//  DraftsViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/5/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface DraftsViewController : GAITrackedViewController<UIScrollViewDelegate>{

    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSMutableArray *CategoryArray;
    NSMutableArray *LPhotoArray;
    NSMutableArray *TitleArray;
    NSMutableArray *place_nameArray;
    NSMutableArray *LocationArray;
    NSMutableArray *FullPhotoArray;
    NSMutableArray *MessageArray;
    NSMutableArray *LikesArray;
    NSMutableArray *LatArray;
    NSMutableArray *LongArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *LinkArray;
    NSMutableArray *CreatedDateArray;
    NSMutableArray *FullAddressJsonArray;
    NSMutableArray *FullPhotoStringArray;
    
    NSMutableArray *LangArray;
    
    NSString *GetLang;
    NSString *GetLangID;
    
    NSMutableArray *CategoryIDArray;
}

@end
