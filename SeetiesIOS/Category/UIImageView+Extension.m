//
//  UIImageView+Extension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView(Extra)

-(void)setImagePlaceHolder
{
    self.image = [UIImage imageNamed:@"NoPhotoInCollection.png"];
    self.contentMode = UIViewContentModeCenter;
    self.backgroundColor = UIColorFromRGB(238, 238, 238, 1);
}

@end
