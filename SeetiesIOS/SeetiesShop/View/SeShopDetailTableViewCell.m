//
//  SeShopDetailTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeShopDetailTableViewCell.h"

@implementation SeShopDetailTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(int)getHeight
{
    return 60;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];

    if (self) {
        [self setWidth:[Utils getDeviceScreenSize].size.width];
    }
    
    return self;
}

// seeties shop model
#define BestKnowFor @"Best known for"
#define Price @"Price"
#define Hours @"Hours"
#define Phone_Number @"Phone Number"
#define URL_Link @"URL/Link"
#define FACEBOOK @"Facebook"

-(void)setImage:(NSString *)lblTitle
{
    NSString* imageName;
    SWITCH (lblTitle) {
        
        CASE (BestKnowFor){
            imageName = @"SSBestKnowIcon.png";

            break;
            
        }
        CASE (Price){
            imageName = @"BluePrice.png";
            break;
            
        }
        CASE (Phone_Number){
            imageName = @"BluePhone.png";
            break;
            
        }
        CASE (Hours){
            imageName = @"BlueTime.png";
            break;
            
        }
        CASE (URL_Link){
            imageName = @"BlueLink.png";
            break;
        }
        CASE (FACEBOOK){
            imageName = @"SSFacebookIcon.png";
            break;
            
        }
        DEFAULT
        {
            imageName = @"";
            break;
            
        }
        
    }

    self.ibImageView.image = [UIImage imageNamed:imageName];

}
@end
