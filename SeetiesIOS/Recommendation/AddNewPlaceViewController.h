//
//  AddNewPlaceViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "AddNewPlaceSubView.h"
#import "EditHoursViewController.h"


typedef void (^LocationBlock)(id object);
@interface AddNewPlaceViewController : CommonViewController<MKMapViewDelegate>

@property(nonatomic,strong)AddNewPlaceSubView* addNewPlaceSubView;
@property(nonatomic,strong)EditHoursViewController* editHoursViewController;
@property(nonatomic,copy)LocationBlock btnPressDoneBlock;

-(void)initData:(RecommendationVenueModel*)model;

@end
