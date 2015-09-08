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


typedef void (^LocationBlock)(SearchType type,id object);
@interface AddNewPlaceViewController : CommonViewController<MKMapViewDelegate>

@property(nonatomic,strong)AddNewPlaceSubView* addNewPlaceSubView;
@property(nonatomic,assign)SearchType searchType;

@property(nonatomic,strong)EditHoursViewController* editHoursViewController;
@property(nonatomic,copy)LocationBlock btnPressDoneBlock;

-(void)initDataFrom4Square:(VenueModel*)model;
-(void)initDataFromGogle:(NSString*)placeid;
-(void)initData:(RecommendationVenueModel*)model;


@property(nonatomic,copy)IDBlock btnBackBlock;

@end
