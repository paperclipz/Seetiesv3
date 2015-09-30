//
//  CategoriesModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "JSONModel.h"

@protocol CategoryModel
@end


@interface CategoryModel : JSONModel

@property (nonatomic,strong)NSString* background_color;
@property (nonatomic,strong)NSString* defaultImageUrl;
@property (nonatomic,strong)NSString* selectedImageUrl;
@property (nonatomic,strong)NSDictionary* multiple_line;
@property (nonatomic,assign)BOOL isSelected;

@property (nonatomic,assign)int id;

@end

@interface CategoriesModel : Model

@property(nonatomic,strong)NSArray<CategoryModel>* categories;
@end
