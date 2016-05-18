//
//  FeedContentView.h
//  Seeties
//
//  Created by Lai on 09/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TranslateText,
    ReadOrigin
} AlertButtonType;

@protocol FeedContentViewDelegate <NSObject>

- (void)alertControllerClickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface FeedContentView : UIView

@property (strong, nonatomic) NSDictionary *dataDictionary;
@property (weak, nonatomic) id<FeedContentViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withDataDictionary:(NSDictionary *)dataDictionary;
- (void)reloadView;

@end
