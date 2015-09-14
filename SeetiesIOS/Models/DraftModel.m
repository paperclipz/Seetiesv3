//
//  DraftModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/10/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DraftModel.h"

@implementation Post
@end

@implementation Location

@end


@implementation PhotoModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"s.url" :@"imageURL"
                                                       }];
}
@end


@interface DraftModel ()
@property(nonatomic,strong)NSDictionary* title;
@property(nonatomic,strong)NSDictionary* message;

@end

@implementation DraftModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"location.address_components" :@"location",
                                                       @"photos" :@"arrPhotos"

                                                       }];
}

-(void)process
{
    NSMutableArray* array = [NSMutableArray new];
    NSArray* key = [self.title allKeys];
    
    for (int i = 0; i < key.count; i++) {
        
        Post* object = [Post new];
        object.title = self.title[key[i]];
        object.message = self.message[key[i]];
        [array addObject:object];
    }
    
    self.arrPost = [[NSArray alloc]initWithArray:array];
   // PhotoModel* photoModel = [PhotoModel alloc]init;
}

@end

@implementation DraftsModel

-(void)process
{
    
    for (int i = 0; i<self.posts.count; i++) {
        DraftModel* model = self.posts[i];
        [model process];
        
    }

}

@end