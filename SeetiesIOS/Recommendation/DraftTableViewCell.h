//
//  DraftTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/3/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "MGSwipeTableCell.h"


@interface DraftTableViewCell : MGSwipeTableCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
-(void)initData:(DraftModel*)model;

@end

