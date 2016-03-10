//
//  SearchSimpleTableViewCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 3/9/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSimpleTableViewCell : CommonTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property(nonatomic,copy)VoidBlock btnSuggestSearchClickedBlock;
@end
