//
//  DealType_mainTblCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/20/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonTableViewCell.h"
typedef void (^DealCollectionBlock)(DealCollectionModel* model);

@interface DealType_mainTblCell : CommonTableViewCell
-(void)initData:(HomeModel*)model;
@property(nonatomic,copy)DealCollectionBlock didSelectDealCollectionBlock;
@end
