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
                                                       @"photos" :@"arrPhotos",
                                                       @"description": @"postDescription",

                                                       }];
}

-(void)process// For getting Draft title and message WITHOUT using "content_languages"
{
    NSMutableArray* array = [NSMutableArray new];
    NSArray* key = [self.title allKeys];
    
    for (int i = 0; i < key.count; i++) {
        
        Post* object = [Post new];
        object.title = self.title[key[i]];
        object.message = self.message[key[i]];
        object.language = key[i];
        [array addObject:object];
    }
    
    self.arrPost = [[NSArray alloc]initWithArray:array];
   // PhotoModel* photoModel = [PhotoModel alloc]init;
}

-(void)customProcess //For getting Draft title and message  USING "content_languages"
{
    NSMutableArray* array = [NSMutableArray new];
    
    for (int i = 0; i < self.content_languages.count; i++) {
        
        NSString* langKey = self.content_languages[i];
        Post* object = [Post new];
        object.title = self.title[langKey];
        object.message = self.message[langKey];
        object.language = langKey;
        [array addObject:object];
    }
    
    self.arrCustomPost = [[NSArray alloc]initWithArray:array];
}


@end



@interface DraftsModel()

@property(nonatomic,strong)NSDictionary* paging;

@end
@implementation DraftsModel

-(void)process
{
    
    for (int i = 0; i<self.posts.count; i++) {
        DraftModel* model = self.posts[i];
        [model process];
        [model customProcess];

    }

}

-(NSString*)next
{
    if (_paging) {
        if ([[_paging allKeys]containsObject:@"next"]) {
            _next = _paging[@"next"];
        }
    }
    return _next;
    
}

-(NSString*)previous
{
    if (_paging) {
        if ([[_paging allKeys]containsObject:@"previous"]) {
            _previous = _paging[@"previous"];
        }
    }
    return _previous;
}

@end