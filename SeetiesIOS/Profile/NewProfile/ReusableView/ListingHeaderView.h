//
//  ListingHeaderView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{

    ListingViewTypeCollection,
    ListingViewTypePost,
    ListingViewTypeLikes
    
}ListingViewType;

@interface ListingHeaderView : CommonView

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAddMore;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgLine;
-(void)setType:(ListingViewType)type addMoreClicked:(VoidBlock)addMoreClicked totalCount:(int)count;
+(float)getheight;

@end
