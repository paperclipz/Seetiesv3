//
//  SuggestedCollectionPostTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/11/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SuggestedCollectionPostTableViewCell.h"

@interface SuggestedCollectionPostTableViewCell()

@end
@implementation SuggestedCollectionPostTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(float)getHeight
{
    return 220.0f;
}

-(void)initSelfView
{
    [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.hdwallpaperbackgrounds.org/photo/1366685048731_[hdwallpaperbackgrounds.org].jpg"]];
    [Utils setRoundBorder:self.ibImageView color:[UIColor clearColor] borderRadius:DEFAULT_BORDER_RADIUS borderWidth:0];
    
}

-(void)setDescription:(NSString*)text userName:(NSString*)name
{
    NSString* combineText = [NSString stringWithFormat:@"%@ : %@",name,text];
    
    
    
    UIFont* fnt = [UIFont fontWithName:CustomFontNameBold size:17];
    UIFont* fnt2 = [UIFont fontWithName:CustomFontName size:17];
    
    NSAttributedString *attributedString = [combineText bos_makeString:^(BOStringMaker *make) {
        make.foregroundColor(TEXT_GRAY_COLOR);
        make.font(fnt2);
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        make.paragraphStyle(paragraphStyle);
        
        make.with.range(NSMakeRange(0, name.length), ^{
            make.foregroundColor([UIColor grayColor]);
            make.font(fnt);
        });
        
       
        
    }];
    
    self.lblDesc.attributedText = attributedString;
}
@end
