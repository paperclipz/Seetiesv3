//
//  DealHeaderView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 3/7/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonView.h"

@interface DealHeaderView : CommonView
@property (weak, nonatomic) IBOutlet UIButton *btnDeals;
@property (weak, nonatomic) IBOutlet UIButton *btnSeeMore;


@property(nonatomic,copy)VoidBlock seeMoreBlock;
@end
