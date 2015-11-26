//
//  NewProfileV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A3ParallaxScrollView.h"
#import "AsyncImageView.h"
#import "UrlDataClass.h"

#import "EditCollectionViewController.h"

//https://github.com/freak4pc/SMTagField tag simple
@interface NewProfileV2ViewController : BaseViewController<UIScrollViewDelegate,UIActionSheetDelegate>


@property(nonatomic,strong)EditCollectionViewController* editCollectionViewController;
@property(nonatomic,strong)UINavigationController* navEditCollectionViewController;
@property(nonatomic,copy)IDBlock btnRecommendationClickBlock;
@property(nonatomic,strong)ShareV2ViewController* shareV2ViewController;
@end
