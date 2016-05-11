//
//  DealMainCollectionViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/20/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealMainCollectionViewCell.h"
@interface DealMainCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@end

@implementation DealMainCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)setCustomIndexPath:(NSIndexPath *)indexPath
{
    [self.ibImageView setCustomBackgroundColorForIndexPath:indexPath];

}

-(void)initData:(DealCollectionModel*)model
{
    
    @try {
        NSDictionary* dictContent = model.content[0];
        self.lblTitle.text = dictContent[@"title"];
        
        PhotoModel* pModel = model.photos[0];
        
        
        if (![Utils isStringNull:pModel.imageURL]) {
            [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] withPlaceHolder:nil completed:^(UIImage *image) {
                
            }];
        }
        else
        {
            self.ibImageView.image = [Utils getPlaceHolderImage];
        }
        

    }
    @catch (NSException *exception) {
        SLog(@"parsing of model fail");
    }
   
 
}

@end
