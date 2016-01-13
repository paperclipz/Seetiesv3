//
//  PhotoModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PhotoModel : JSONModel
@property(nonatomic,strong)NSString* tags;
@property(nonatomic,strong)NSString* photo_id;
@property(nonatomic,strong)NSString* caption;
@property(nonatomic,assign)int position;
@property(nonatomic,strong)NSString* imageURL;
@property(nonatomic,strong)UIImage* image;
@property(nonatomic,assign)float imageWidth;
@property(nonatomic,assign)float imageHeight;
-(id) copyWithZone: (NSZone *) zone;
@end
