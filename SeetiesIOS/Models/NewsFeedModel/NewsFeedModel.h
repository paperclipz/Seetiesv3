//
//  NewsFeedModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NewsFeedModel : PaginationModel

@property(nonatomic,strong)NSObject* items;
@end
