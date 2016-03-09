//
//  TagModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/6/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "Model.h"

@protocol ComplexTagModel @end

@interface TagModel : Model


@property(nonatomic,strong)NSArray* arrayTag;
@property(nonatomic,strong)NSArray<ComplexTagModel>* arrComplexTag;

@end
