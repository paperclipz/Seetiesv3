//
//  DealCollectionModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/26/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DealCollectionModel : JSONModel

@property(nonatomic,strong)NSArray<PhotoModel>* photos;

@property(nonatomic,strong)NSString* deal_collection_id;

@property(nonatomic,strong)NSArray* content;

@property(nonatomic,assign)int total_deals_collectable;

@property(nonatomic,assign)int total_deals_collected;

@property(nonatomic,strong)NSString* cDescription;

@property(nonatomic,strong)NSString* language_code;

@property(nonatomic,strong)NSString* language_name;

@property(nonatomic,strong)NSString* cTitle;

//expired_info
@property(nonatomic,strong)NSString* expired_at;
@property(nonatomic,assign)int expired_in_days;
@end
