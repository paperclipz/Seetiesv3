//
//  HomeModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/3/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol DealModel
@end

@interface HomeModel : JSONModel

@property(nonatomic,assign)int wallet_count;
@property(nonatomic,strong)NSArray<DealModel>* superdeals;

@end
