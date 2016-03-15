//
//  SeShopPhotoModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface SePhotoModel:JSONModel
@property(nonatomic,strong)NSString* imageURL;
@end


@interface SeShopPhotoModel : JSONModel

@property(nonatomic,assign)int offset;
@property(nonatomic,assign)int limit;
@property(nonatomic,assign)int total_photos;
@property(nonatomic,strong)NSArray<SePhotoModel>* photos;
@property(nonatomic,strong)NSString<Ignore>* next;
@property(nonatomic,strong)NSString<Ignore>* previous;
@end
