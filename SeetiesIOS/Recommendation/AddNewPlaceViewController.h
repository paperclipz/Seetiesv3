//
//  AddNewPlaceViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"

@interface AddNewPlaceViewController : CommonViewController<MKMapViewDelegate>
-(void)initData:(SearchLocationModel*)model;

@end
