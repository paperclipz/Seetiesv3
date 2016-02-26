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

@end
