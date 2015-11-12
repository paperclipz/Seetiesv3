//
//  SuggestedCollectionPostTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 11/11/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface SuggestedCollectionPostTableViewCell : CommonTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

+(float)getHeight;

@end
