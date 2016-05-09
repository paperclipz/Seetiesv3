//
//  DealType_ReferFriendTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 20/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealType_ReferFriendTblCell.h"
#import "InviteFriendModel.h"

@interface DealType_ReferFriendTblCell()

@property (weak, nonatomic) IBOutlet UIView *ibCborderview;
@property (weak, nonatomic) IBOutlet UILabel *ibTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibDesc;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@end

@implementation DealType_ReferFriendTblCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [Utils setRoundBorder:self.ibCborderview color:OUTLINE_COLOR borderRadius:0 borderWidth:1.0f];

    
}

-(void)initData
{
    @try {
        InviteFriendModel* model = [[[[[DataManager Instance] appInfoModel]countries]current_country]invite_friend_banner];
        
        if (model) {
            
            self.ibTitle.text = LocalisedString(model.title);
            [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                self.ibImageView.image = image;
            }];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
