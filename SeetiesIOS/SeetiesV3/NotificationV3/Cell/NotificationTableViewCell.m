//
//  NotificationTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/17/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "NSDate+NVTimeAgo.h"
#import "PhotoCollectionViewCell.h"


@interface NotificationTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;

@property (strong, nonatomic)NotificationModel* notificationModel;

@end
@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.ibImageView setRoundedBorder];
}


-(void)initSelfView
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initData:(NotificationModel*)model Type:(int)type
{
    
    self.notificationModel = model;
    
    [self.ibCollectionView reloadData];
    
    if (type == 2) {
        
        self.ibCollectionView.hidden = YES;
    }else
    {
        if (model.arrPosts.count == 0) {
            self.ibCollectionView.hidden = YES;

        }
        self.ibCollectionView.hidden = NO;

    }
    
    if (type == 1) {
        [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.userProfile.url] placeholderImage:[UIImage imageNamed:@"NoImage.png"]];

    }
    else{
        [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.userProfileImage] placeholderImage:[UIImage imageNamed:@"NoImage.png"]];

    }
    
    NSString* message = [model.notificationMessage stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%dpx; color:#666666;}</style>",
                                                    @"ProximaNovaSoft-Regular",
                                                    15]];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[message dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.lblDescription.attributedText = attrStr;
    
    NSString *start = model.date;
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *capturedStartDate = [dateFormatter dateFromString: start];
    
    self.lblTime.text = [capturedStartDate formattedAsTimeAgo];
    
    NSString* imageName;
    switch (model.notType) {
        case NotificationType_Follow:
        case NotificationType_CollectionFollow:

            imageName = @"NotificationFollow.png";
            break;
            
        case NotificationType_Like:
            imageName = @"NotificationLike.png";
            break;
            
        case NotificationType_Collect:
        case NotificationType_CollectionShared:
            imageName = @"NotificationCollect.png";

            break;
        case NotificationType_Mention:
        case NotificationType_Comment:

            imageName = @"NotificationComment.png";

            break;
        default:
        case NotificationType_Post:
        case NotificationType_PostShared:
        case NotificationType_SeetiesShared:

            imageName = @"NotificationShare.png";

            break;
            
        case NotificationType_Seeties:
            
            imageName = @"NotificationBySeeties.png";
            
            break;
    }
    
    self.ibImgIndicator.image = [UIImage imageNamed:imageName];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.notificationModel.arrPosts.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    
    DraftModel* model = self.notificationModel.arrPosts[indexPath.row];
    
    [cell.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:model.postImageURL] completed:nil];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.notificationModel.notType == NotificationType_Like) {
        
        
        DraftModel* draftModel = self.notificationModel.arrPosts[indexPath.row];
        if (self.didSelectPostAtIndexBlock) {
            self.didSelectPostAtIndexBlock(draftModel.post_id);
        }
    }
}


@end
