//
//  IntroCoverView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 3/24/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
// for introduction
@interface IntroCoverView : CommonView<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (weak, nonatomic) IBOutlet UIView *ibContentView;
@property(nonatomic,strong)NSArray* arrCoverViews;
@property(nonatomic,strong)NSArray* arrBackGroundImages;

@property(nonatomic,copy)VoidBlock didEndClickedBlock;
-(void)initDataAll;

@end
