//
//  MainTableViewCell.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/6/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AsyncImageView *ShowImage;
@property (weak, nonatomic) IBOutlet AsyncImageView *ShowUserImage;
@property (weak, nonatomic) IBOutlet UILabel *ShowTitle;
@property (weak, nonatomic) IBOutlet UILabel *ShowAddress;
@property (weak, nonatomic) IBOutlet UILabel *ShowLocation;
@end
