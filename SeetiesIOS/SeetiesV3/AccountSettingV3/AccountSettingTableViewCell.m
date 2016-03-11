//
//  AccountSettingTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "AccountSettingTableViewCell.h"
@interface AccountSettingTableViewCell()

@end
@implementation AccountSettingTableViewCell
- (IBAction)switchClicked:(id)sender {
    
    UISwitch* button = (UISwitch*)sender;
    
    if (self.didChangeSettingBlock) {
        self.didChangeSettingBlock(button.on);
    }
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(int)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
        
        for (id currentObject in objects ){
            if ([currentObject isKindOfClass:[self class]]) {
                
                
                AccountSettingTableViewCell* view = (AccountSettingTableViewCell*)currentObject;
                
                
                if (view.tag == type) {
                    [view initSelfView];
                    return currentObject;

                }
                
            }
        }
        return nil;
        
        
    }
    return self;
}

-(void)initSelfView
{
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)initData:(int)type
{
    

}
@end
