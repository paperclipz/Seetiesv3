//
//  DraftModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/10/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DraftModel.h"

@implementation Post

-(id)copyWithZone:(NSZone *)zone
{
    Post* model = [[[self class]alloc]init];
    
    [model setTitle:_title];
    [model setLanguage:_language];
    [model setMessage:_message];
    return model;
}
@end

@interface DraftModel ()

@property(nonatomic,strong)NSDictionary* title;
@property(nonatomic,strong)NSDictionary* message;




@end

@implementation DraftModel

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    for (NSString *key in [self codableProperties])
    {
        [copy setValue:[self valueForKey:key] forKey:key];
    }
    
    
    DraftModel* model = copy;
    model.user_info = [_user_info copy];
    model.post = [_post copy];
    model.arrPhotos = [[NSMutableArray alloc]initWithArray:_arrPhotos copyItems:YES];
    model.location = [_location copy];

    return copy;
    
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"photos" :@"arrPhotos",
                                                       @"description": @"postDescription",
                                                       @"url" : @"postImageURL"
                                                       }];
}

-(NSMutableArray<PhotoModel>*)arrPhotos
{
    if (!_arrPhotos) {
        _arrPhotos = [NSMutableArray<PhotoModel> new];
    }
    
    return _arrPhotos;
}

-(NSString*)post_id
{
    if (!_post_id) {
        _post_id = @"";
    }
    return _post_id;
}

-(NSString*)getPostTitle{
   
    NSString* tempTitle = @"";
    
    if (![Utils isArrayNull:_content_languages])
    {
        NSString* langCode = _content_languages[0];
        NSDictionary* content = _contents[langCode];
        tempTitle = content[@"title"];
    }
    return tempTitle;

}


-(void)process// For getting Draft title and message WITHOUT using "content_languages"
{
    @try {
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
    }
    @catch (NSException *exception) {
        SLog(@"process Fail");
    }
   
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

-(NSArray*)arrCustomPost
{
    if (!_arrCustomPost) {
        NSMutableArray* array = [NSMutableArray new];
        
        for (int i = 0; i < self.content_languages.count; i++) {
            
            NSString* langKey = self.content_languages[i];
            Post* object = [Post new];
            object.title = self.title[langKey];
            object.message = self.message[langKey];
            object.language = langKey;
            [array addObject:object];
        }
        
        _arrCustomPost = [[NSArray alloc]initWithArray:array];
    }
    
    return _arrCustomPost;
}

/*get the first language description*/
-(NSString*)getPostDescription
{
    NSString* desc = @"";
    if(![Utils isArrayNull:_content_languages])
    {
        NSString* contentLanguage = _content_languages[0];
        NSDictionary* content = _contents[contentLanguage];
        desc = content[@"message"];
    }
    
    return desc;
   
}

-(Location*)location
{
    if (!_location) {
        _location = [[Location alloc]init];
    }
    return _location;
}

-(Post*)post
{
    if (_post) {
        @try {
            _post = self.arrCustomPost[0];
        }
        @catch (NSException *exception) {
            
        }
       
    }
    else
    {
        _post = [Post new];
    }
    
    return _post;
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