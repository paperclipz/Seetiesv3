//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "ProfilePageCollectionTableViewCell.h"

#import "CommonTableViewCell.h"

@interface ___FILEBASENAMEASIDENTIFIER___ : ProfilePageCollectionTableViewCell
+(int)getHeight;
-(void)initData:(CollectionModel*)model profileType:(ProfileViewType)type;

@property(nonatomic,copy)VoidBlock btnEditClickedBlock;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfCollection;
-(void)setFollowButtonSelected:(BOOL)selected button:(UIButton*)button;

@property(nonatomic,copy)VoidBlock btnFollowBlock;
@property(nonatomic,copy)VoidBlock btnShareClicked;

@end
