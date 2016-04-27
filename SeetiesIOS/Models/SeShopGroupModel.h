//
//  SeShopGroupModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/26/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SeShopGroupModel : JSONModel


@property(nonatomic,strong)NSString* shop_group_id;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSArray<SeShopDetailModel>* other_branches;

@end
