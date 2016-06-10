//
//  FeedShopLocationView.h
//  Seeties
//
//  Created by Lai on 06/06/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedShopLocationViewDelegate <NSObject>

- (void)viewShopDetailButtonDidClicked:(id)sender;

@end

@interface FeedShopLocationView : UIView

@property (strong, nonatomic) NSDictionary *dataDictionary;
@property (weak, nonatomic) id<FeedShopLocationViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withDataDictionary:(NSDictionary *)dataDictionary;

@end
