//
//  ListingHeaderView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ListingHeaderView.h"
#import "UIImage+Tint.h"

@interface ListingHeaderView()

@property(nonatomic,copy)VoidBlock btnAddMoreClickedBlock;
@end
@implementation ListingHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnAddmoreClicked:(id)sender {
    if(_btnAddMoreClickedBlock)
    {
        self.btnAddMoreClickedBlock();
    }
    

}

-(void)initSelfView
{
   
}

-(void)setType:(ListingViewType)type addMoreClicked:(VoidBlock)addMoreClicked totalCount:(int)count;
{
    
    _btnAddMoreClickedBlock = addMoreClicked;
    switch (type) {
        default:
        case ListingViewTypeCollection:
            
            self.lblTitle.text = [NSString stringWithFormat:@"%d %@",count,LocalisedString(@"Collections")];
            self.btnAddMore.hidden = false;
            
            
            break;
        case ListingViewTypePost:
            self.lblTitle.text = [NSString stringWithFormat:@"%d %@",count,LocalisedString(@"Posts")];
            
            
            self.btnAddMore.hidden = false;

            break;

        case ListingViewTypeLikes:
            self.lblTitle.text = [NSString stringWithFormat:@"%d %@",count,LocalisedString(@"Likes")];
            self.btnAddMore.hidden = true;
            self.ibImgLine.hidden = true;
            break;
    }
}


+(float)getheight
{
    return 60.0f;
}

@end
