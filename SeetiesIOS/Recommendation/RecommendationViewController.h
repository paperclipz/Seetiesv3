//
//  RecommendationViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/11/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectImageViewController.h"
#import "AssetHelper.h"
#import "DoImagePickerController.h"
#import "WhereIsThisViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface RecommendationViewController : BaseViewController<DoImagePickerControllerDelegate,CLLocationManagerDelegate,MKReverseGeocoderDelegate>

@property(nonatomic,strong)SelectImageViewController* assetPickerViewController;
@end
