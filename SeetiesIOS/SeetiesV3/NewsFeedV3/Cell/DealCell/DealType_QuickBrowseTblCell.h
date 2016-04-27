//
//  DealType_QuickBrowseTblCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/20/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^QuickBrowseBlock)(QuickBrowseModel* model);

@interface DealType_QuickBrowseTblCell : CommonTableViewCell
-(void)initData:(NSArray*)array;
@property(nonatomic,copy)QuickBrowseBlock didSelectDealBlock;

@end
