//
//  SeNearbySeetishop.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 01/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeNearbySeetishop : CommonView
@property(nonatomic,copy)VoidBlock viewDidFinishLoadBlock;
@property(nonatomic,copy)VoidBlock btnSelectSeetiShopListBlock;

-(void)initData;
@end
