//
//  SeShopDetailView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonView.h"

@interface SeShopDetailView : CommonView
-(void)setupViewWithData;
-(BOOL)isAvailable;
@property(nonatomic,copy)VoidBlock btnMapClickedBlock;
@end
