//
//  CoreModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/7/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "Location.h"
#import "PhotoModel.h"
#import "OpeningPeriodModel.h"
#import "ProfileModel.h"
#import "CTFeedModel.h"
#import "AnnouncementModel.h"
#import "LanguageModel.h"
#import "InstagramModel.h"


/*Declare custom block for model type*/
typedef void (^PostBlock)(DraftModel* postModel);
typedef void (^ProfileBlock)(ProfileModel* profileModel);


