//
//  QuickBrowseModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/23/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface QuickBrowseModel : JSONModel

@property(nonatomic,strong)NSString* category_group_id;
@property(nonatomic,strong)NSString* backgroundImage;
@property(nonatomic,strong)NSString* logoImage;
@property(nonatomic,strong)NSString* name;

@end
