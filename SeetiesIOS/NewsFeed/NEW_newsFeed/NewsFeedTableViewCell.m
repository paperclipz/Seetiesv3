//
//  NewsFeedTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NewsFeedTableViewCell.h"
#import "UIImage+FX.h"

@interface NewsFeedTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@end
@implementation NewsFeedTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initSelfView
{
    
    [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:@"http://images6.fanpop.com/image/photos/36000000/Lotte-Fansign-Taeyeon-taeyeon-snsd-36001984-1280-1644.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.ibImageView.image = [image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
        
    }];
}
@end
