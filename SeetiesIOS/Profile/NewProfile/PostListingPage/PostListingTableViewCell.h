//
//  PostListingTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/23/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface PostListingTableViewCell : CommonTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblNoView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageNoViewIcon;
-(void)initData:(DraftModel*)model;
-(void)ProfileViewType:(ProfileViewType)type;
@end
