//
//  SuggestionFeatureCVCell.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionFeatureCVCell : CommonCollectionViewCell
-(void)initData:(ProfileModel*)model;

@property(nonatomic,copy)IDBlock didSelectUserBlock;//user profile
@end
