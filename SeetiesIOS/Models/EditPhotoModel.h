//
//  EditPhotoModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"

@interface EditPhotoModel : Model

@property(nonatomic,strong)UIImage* image;
@property(nonatomic,strong)NSString* photoDescription;
@end
