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




@interface AddNewPlaceViewController : CommonViewController<MKMapViewDelegate>

@property(nonatomic,strong)AddNewPlaceSubView* addNewPlaceSubView;
@property(nonatomic,assign)SearchType searchType;

@property(nonatomic,strong)EditHoursViewController* editHoursViewController;
@property(nonatomic,copy)IDBlock btnPressDoneBlock;

-(void)initDataFrom4Square:(VenueModel*)model;
-(void)initDataFromGogle:(NSString*)placeid;

@end
