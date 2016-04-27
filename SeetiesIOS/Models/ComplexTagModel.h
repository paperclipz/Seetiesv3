//
//  ComplexTagModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 3/9/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TagLocationModel.h"

@interface ComplexTagModel : JSONModel


@property(nonatomic,strong)NSString* tag;
@property(nonatomic,strong)TagLocationModel* location;
@end
